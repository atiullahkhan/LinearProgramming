\* Shipping_Cost_Optimization_2 *\
Minimize
OBJ: 3000 Expand_Kolkata + 1.5 Flow_Ahmedabad_C2 + 0.5 Flow_Ahmedabad_C3
 + 1.5 Flow_Ahmedabad_C5 + Flow_Ahmedabad_C6 + 0.4 Flow_Chennai_C2
 + 0.5 Flow_Chennai_C4 + 0.6 Flow_Chennai_C5 + 0.9 Flow_Chennai_C6
 + 1.5 Flow_Coimbatore_C2 + 2 Flow_Coimbatore_C3 + 0.5 Flow_Coimbatore_C5
 + 1.5 Flow_Coimbatore_C6 + Flow_Kolkata_C1 + 0.5 Flow_Kolkata_C2
 + 0.5 Flow_Kolkata_C3 + Flow_Kolkata_C4 + 0.5 Flow_Kolkata_C5
 + 0.2 Flow_Nagpur_C3 + 1.5 Flow_Nagpur_C4 + 0.5 Flow_Nagpur_C5
 + 1.5 Flow_Nagpur_C6 + 0.5 Flow_NewDelhi_Ahmedabad + Flow_NewDelhi_C1
 + 1.5 Flow_NewDelhi_C3 + 2 Flow_NewDelhi_C4 + Flow_NewDelhi_C6
 + 0.4 Flow_NewDelhi_Chennai + Flow_NewDelhi_Coimbatore
 + 0.5 Flow_NewDelhi_Kolkata + 0.2 Flow_NewDelhi_Nagpur
 + 0.6 Flow_NewDelhi_Patna + 1.2 Flow_Patna_C1 + 0.6 Flow_Patna_C2
 + 0.5 Flow_Patna_C3 + 0.3 Flow_Patna_C5 + 0.8 Flow_Patna_C6
 + 2 Flow_Vishakhapatnam_C1 + 0.3 Flow_Vishakhapatnam_Chennai
 + 0.5 Flow_Vishakhapatnam_Coimbatore + 0.3 Flow_Vishakhapatnam_Kolkata
 + 0.2 Flow_Vishakhapatnam_Nagpur + 0.4 Flow_Vishakhapatnam_Patna
 + 10000 Open_Ahmedabad + 4000 Open_Chennai + 5000 Open_Nagpur
 + 12000 Open_Patna
Subject To
Customer_Demand_At_C1: Flow_Kolkata_C1 + Flow_NewDelhi_C1 + Flow_Patna_C1
 + Flow_Vishakhapatnam_C1 = 50000
Customer_Demand_At_C2: Flow_Ahmedabad_C2 + Flow_Chennai_C2
 + Flow_Coimbatore_C2 + Flow_Kolkata_C2 + Flow_Patna_C2 = 10000
Customer_Demand_At_C3: Flow_Ahmedabad_C3 + Flow_Coimbatore_C3
 + Flow_Kolkata_C3 + Flow_Nagpur_C3 + Flow_NewDelhi_C3 + Flow_Patna_C3 = 40000
Customer_Demand_At_C4: Flow_Chennai_C4 + Flow_Kolkata_C4 + Flow_Nagpur_C4
 + Flow_NewDelhi_C4 = 35000
Customer_Demand_At_C5: Flow_Ahmedabad_C5 + Flow_Chennai_C5
 + Flow_Coimbatore_C5 + Flow_Kolkata_C5 + Flow_Nagpur_C5 + Flow_Patna_C5
 = 60000
Customer_Demand_At_C6: Flow_Ahmedabad_C6 + Flow_Chennai_C6
 + Flow_Coimbatore_C6 + Flow_Nagpur_C6 + Flow_NewDelhi_C6 + Flow_Patna_C6
 = 20000
Depot_Capacity_From_Ahmedabad: Flow_Ahmedabad_C2 + Flow_Ahmedabad_C3
 + Flow_Ahmedabad_C5 + Flow_Ahmedabad_C6 - 70000 Open_Ahmedabad <= 0
Depot_Capacity_From_Chennai: Flow_Chennai_C2 + Flow_Chennai_C4
 + Flow_Chennai_C5 + Flow_Chennai_C6 - 25000 Open_Chennai <= 0
Depot_Capacity_From_Coimbatore: Flow_Coimbatore_C2 + Flow_Coimbatore_C3
 + Flow_Coimbatore_C5 + Flow_Coimbatore_C6 - 100000 Open_Coimbatore <= 0
Depot_Capacity_From_Kolkata: - 20000 Expand_Kolkata + Flow_Kolkata_C1
 + Flow_Kolkata_C2 + Flow_Kolkata_C3 + Flow_Kolkata_C4 + Flow_Kolkata_C5
 - 50000 Open_Kolkata <= 0
Depot_Capacity_From_Nagpur: Flow_Nagpur_C3 + Flow_Nagpur_C4 + Flow_Nagpur_C5
 + Flow_Nagpur_C6 - 40000 Open_Nagpur <= 0
Depot_Capacity_From_Patna: Flow_Patna_C1 + Flow_Patna_C2 + Flow_Patna_C3
 + Flow_Patna_C5 + Flow_Patna_C6 - 30000 Open_Patna <= 0
Depot_Count: Open_Ahmedabad + Open_Chennai + Open_Coimbatore + Open_Kolkata
 + Open_Nagpur + Open_Patna <= 4
Depot_Throughput_At_Ahmedabad: - Flow_Ahmedabad_C2 - Flow_Ahmedabad_C3
 - Flow_Ahmedabad_C5 - Flow_Ahmedabad_C6 + Flow_NewDelhi_Ahmedabad = 0
Depot_Throughput_At_Chennai: - Flow_Chennai_C2 - Flow_Chennai_C4
 - Flow_Chennai_C5 - Flow_Chennai_C6 + Flow_NewDelhi_Chennai
 + Flow_Vishakhapatnam_Chennai = 0
Depot_Throughput_At_Coimbatore: - Flow_Coimbatore_C2 - Flow_Coimbatore_C3
 - Flow_Coimbatore_C5 - Flow_Coimbatore_C6 + Flow_NewDelhi_Coimbatore
 + Flow_Vishakhapatnam_Coimbatore = 0
Depot_Throughput_At_Kolkata: - Flow_Kolkata_C1 - Flow_Kolkata_C2
 - Flow_Kolkata_C3 - Flow_Kolkata_C4 - Flow_Kolkata_C5 + Flow_NewDelhi_Kolkata
 + Flow_Vishakhapatnam_Kolkata = 0
Depot_Throughput_At_Nagpur: - Flow_Nagpur_C3 - Flow_Nagpur_C4 - Flow_Nagpur_C5
 - Flow_Nagpur_C6 + Flow_NewDelhi_Nagpur + Flow_Vishakhapatnam_Nagpur = 0
Depot_Throughput_At_Patna: Flow_NewDelhi_Patna - Flow_Patna_C1 - Flow_Patna_C2
 - Flow_Patna_C3 - Flow_Patna_C5 - Flow_Patna_C6 + Flow_Vishakhapatnam_Patna
 = 0
Factory_Capacity_From_NewDelhi: Flow_NewDelhi_Ahmedabad + Flow_NewDelhi_C1
 + Flow_NewDelhi_C3 + Flow_NewDelhi_C4 + Flow_NewDelhi_C6
 + Flow_NewDelhi_Chennai + Flow_NewDelhi_Coimbatore + Flow_NewDelhi_Kolkata
 + Flow_NewDelhi_Nagpur + Flow_NewDelhi_Patna <= 150000
Factory_Capacity_From_Vishakhapatnam: Flow_Vishakhapatnam_C1
 + Flow_Vishakhapatnam_Chennai + Flow_Vishakhapatnam_Coimbatore
 + Flow_Vishakhapatnam_Kolkata + Flow_Vishakhapatnam_Nagpur
 + Flow_Vishakhapatnam_Patna <= 200000
Binaries
Expand_Kolkata
Open_Ahmedabad
Open_Chennai
Open_Coimbatore
Open_Kolkata
Open_Nagpur
Open_Patna
End
