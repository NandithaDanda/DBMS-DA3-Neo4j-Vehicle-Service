# Vehicle Service Management System: Neo4j Implementation (DA3)

**Course:** Database Management Systems  

**Team Members:**  
- 25BCE1890 - Danda Nanditha  
- 25BCE5102 - Pooja KR  
- 25BCE5658 - Manasa LS  

---
# DBMS-DA3-Neo4j-Vehicle-Service
Vehicle Service Management System implemented using Neo4j (Graph Database)

## Overview
Re-implementation of the Vehicle Service Management System (DA1/DA2) using **Neo4j**, a property graph database, with queries written in **Cypher**.

## Why Neo4j?
the project is naturally a graph. Customer → Vehicle → Service Card → Service Item → Spare Part → Supplier is a chain of relationships, and the EER diagram maps almost one-to-one onto nodes and edges.
No JOINs for multi-hop queries. Finding “which customers are affected by a faulty brake pad” takes about 6 JOINs in MySQL. In Neo4j it is one readable path pattern, and it stays fast as data grows because relationships are stored as direct pointers.
Many-to-many relationships are simpler. The part–supplier relationship needs a SUPPLIES junction table in SQL. In Neo4j it is just a SUPPLIED_BY edge.
Specialization is easy to model. A mechanic who is engine, electrical, both or neither (overlapping) is just multiple labels on one node. Car/Motorcycle works the same way, with no extra subtype tables.
Powerful relationship-based queries. Shortest path, service-history traversal, supplier impact analysis and “parts used together” recommendations are built-in strengths of Cypher and hard to write in SQL.
Flexible schema and strong visuals. You can add new properties or relationship types (for example warranty or feedback) without ALTER TABLE. Neo4j Browser also draws the graph, which makes the demo very clear.


## Tools & Environment
- **Neo4j AuraDB Free** (Cloud Instance)
- **Cypher Query Language**
- **Neo4j Query Tool / Workspace**

## Repository Structure
- `scripts/`: Cypher scripts covering schema constraints, data loading, CRUD operations, business queries (Q1–Q10), graph traversals (G1–G9), and optimizations (D1–D4).
- `screenshots/`: Execution outputs and visual graph representations.
- `report/`: Final assignment documentation.

## How to Run
1. Log in to [Neo4j Aura Console](https://console.neo4j.io/).
2. Open the **Query** tab of the running instance.
3. Execute the Cypher scripts in sequential order:
   1. `scripts/01_constraints.cypher`
   2. `scripts/02_load_data.cypher`
   3. `scripts/03_crud.cypher`
   4. `scripts/04_queries_Q1_Q10.cypher`
   5. `scripts/05_graph_queries_G1_G9.cypher`
   6. `scripts/06_extras.cypher`
