import logging

import pulp

from helper import write_to_csv
from parameters import model_params
from process_data import write_outputs

__author__ = 'Ehsan Khodabandeh'
__version__ = '1.0'
# ====================================

logger = logging.getLogger(__name__ + ': ')


# Pulp addConstraint function doesn't return the constraint object.
# So, to have a consistent object, we return it ourselves.
# Rather than a function, you can also define this as a method on OptimizationModel class
def add_constr(model, constraint):
    model.addConstraint(constraint)
    return constraint


class OptimizationModel(object):
    def __init__(self, input_data, input_params):
        self.input_data = input_data
        self.input_params = input_params
        self.model = pulp.LpProblem(name='prod_planning', sense=pulp.LpMinimize)
        self._create_decision_variables()
        self._create_main_constraints()
        self._set_objective_function()

    # ================== Decision variables ==================
    def _create_decision_variables(self):
        self.production_variables = pulp.LpVariable.dicts(name='X', indexs=self.input_data.index,
                                                          lowBound=0, cat=pulp.LpContinuous)

        self.inventory_variables = pulp.LpVariable.dicts(name='I', indexs=self.input_data.index,
                                                         lowBound=0, cat=pulp.LpContinuous)

        # Alternative way of creating the variables:
        # self.production_variables = {
        #     index: pulp.LpVariable(name='X_' + str(row['period']),
        #                            lowBound=0, cat=pulp.LpContinuous)
        #     for index, row in self.input_data.iterrows()}
        #
        # self.inventory_variables = {
        #     index: pulp.LpVariable(name='I_' + str(row['period']),
        #                            lowBound=0, cat=pulp.LpContinuous)
        #     for index, row in self.input_data.iterrows()}

    # ================== Constraints ==================
    def _create_main_constraints(self):
        # Depending on what you need, you may want to consider creating any of
        # the expressions (constraints or objective terms) as an attribute of
        # the OptimizationModel class (e.g. self.inv_balance_constraints).
        # That way if, for example, at the end of the optimization you need to check
        # the slack variables of certain constraints, you know they already exists in your model

        # ================== Inventory balance constraints ==================
        self.inv_balance_constraints = {
            period: add_constr(self.model, pulp.LpConstraint(
                e=self.inventory_variables[period - 1] + self.production_variables[period]
                  - self.inventory_variables[period],
                sense=pulp.LpConstraintEQ,
                name='inv_balance' + str(period),
                rhs=value.demand))
            for period, value in self.input_data.iloc[1:].iterrows()}

        # inv balance for first period
        self.first_period_inv_balance_constraints = add_constr(self.model, pulp.LpConstraint(
            e=self.production_variables[0] - self.inventory_variables[0],
            sense=pulp.LpConstraintEQ,
            name='inv_balance0',
            rhs=self.input_data.iloc[0].demand - self.input_params['initial_inventory']))

        # ================== Production capacity constraints ==================
        self.production_capacity_constraints = {
            index: add_constr(self.model, pulp.LpConstraint(
                e=value,
                sense=pulp.LpConstraintLE,
                name='prod_cap_month_' + str(index),
                rhs=self.input_data.iloc[index].production_capacity))
            for index, value in self.production_variables.items()}

    # ================== Costs and objective function ==================
    def _set_objective_function(self):
        # Similar to constraints, saving the costs expressions as attributes
        # can give you the chance to retrieve their values at the end of the optimization
        self.total_holding_cost = self.input_params['holding_cost'] * pulp.lpSum(self.inventory_variables)
        self.total_production_cost = pulp.lpSum(row['production_cost'] * self.production_variables[index]
                                                for index, row in self.input_data.iterrows())

        objective = self.total_holding_cost + self.total_production_cost
        self.model.setObjective(objective)

    # ================== Optimization ==================
    def optimize(self):
        """
        Default solver is 'cbc' unless solver is set to something else.
        You may need to provide a path for any of the solvers using 'path' argument.
        """

        if model_params['write_lp']:
            logger.info('Writing the lp file!')
            self.model.writeLP(self.model.name + '.lp')

        logger.info('Optimization starts!')
        _solver = pulp.PULP_CBC_CMD(keepFiles=model_params['write_log'],
                                    fracGap=model_params['mip_gap'],
                                    maxSeconds=model_params['time_limit'],
                                    msg=model_params['display_log'])

        if model_params['solver'] == 'gurobi':
            _solver = pulp.GUROBI(msg=model_params['write_log'],
                                  timeLimit=model_params['time_limit'],
                                  epgap=model_params['mip_gap'])
        elif model_params['solver'] == 'cplex':
            options = []
            if model_params['mip_gap']:
                set_mip_gap = "set mip tolerances mipgap {}".format(model_params['mip_gap'])
                options.append(set_mip_gap)
            _solver = pulp.CPLEX_CMD(keepFiles=model_params['write_log'],
                                     options=options, timelimit=model_params['time_limit'],
                                     msg=model_params['display_log'])
        elif model_params['solver'] == 'glpk':
            # Read more about glpk options: https://en.wikibooks.org/wiki/GLPK/Using_GLPSOL
            options = []
            if model_params['mip_gap']:
                set_mip_gap = "--mipgap {}".format(model_params['mip_gap'])
                options.append(set_mip_gap)
            if model_params['time_limit']:
                set_time_limit = "--tmlim {}".format(model_params['time_limit'])
                options.append(set_time_limit)
            _solver = pulp.GLPK_CMD(keepFiles=model_params['write_log'], options=options,
                                    msg=model_params['display_log'])

        self.model.solve(solver=_solver)

        if self.model.status == pulp.LpStatusOptimal:
            logger.info('The solution is optimal and the objective value '
                        'is ${:,.2f}'.format(pulp.value(self.model.objective)))

    # ================== Output ==================
    def create_output(self):
        dict_of_variables = {'production_variables': self.production_variables,
                             'inventory_variables': self.inventory_variables}

        output_df = write_outputs(dict_of_variables)
        write_to_csv(output_df)