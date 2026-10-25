// ============================================================
// 05_graph_queries_G1_G9.cypher
// Graph-specific queries (multi-hop, path finding, recommendation)
// Tip: use "graph view" in the result panel for G1, G4 and G7
// ============================================================

// G1: Full service history of a customer (4 hops, no JOINs)
MATCH path = (c:Customer {name:'Arun Kumar'})-[:OWNS]->(:Vehicle)-[:HAS_SERVICE]->(:ServiceCard)-[:GENERATES]->(:Invoice)
RETURN path;

// G2: Everything about one vehicle: mechanic, parts, supplier
MATCH (v:Vehicle {registration_no:'TN01AB1234'})-[:HAS_SERVICE]->(s:ServiceCard)
OPTIONAL MATCH (m:Mechanic)-[:ASSIGNED_TO]->(s)
OPTIONAL MATCH (s)-[:INCLUDES]->(:PartUsed)-[:USES]->(p:SparePart)-[:SUPPLIED_BY]->(sup:Supplier)
RETURN s.service_id, s.status, m.name AS mechanic, p.part_name, sup.name AS supplier;

// G3: Supplier impact analysis: open services depending on AutoParts Co
MATCH (sup:Supplier {name:'AutoParts Co'})<-[:SUPPLIED_BY]-(p:SparePart)<-[:USES]-(:PartUsed)<-[:INCLUDES]-(s:ServiceCard)
WHERE s.status <> 'Completed'
RETURN DISTINCT s.service_id, s.status, p.part_name;

// G4 (graph view): Recall analysis, customers affected if Oil Filter is faulty
MATCH path = (p:SparePart {part_name:'Oil Filter'})<-[:USES]-(:PartUsed)<-[:INCLUDES]-(:ServiceCard)<-[:HAS_SERVICE]-(v:Vehicle)<-[:OWNS]-(c:Customer)
RETURN path;

// G4 (table view)
MATCH (p:SparePart {part_name:'Oil Filter'})<-[:USES]-(:PartUsed)<-[:INCLUDES]-(:ServiceCard)<-[:HAS_SERVICE]-(v:Vehicle)<-[:OWNS]-(c:Customer)
RETURN DISTINCT c.name, c.phone, v.registration_no;

// G5: Parts frequently used together (recommendation)
MATCH (p1:SparePart)<-[:USES]-(:PartUsed)<-[:INCLUDES]-(s:ServiceCard)-[:INCLUDES]->(:PartUsed)-[:USES]->(p2:SparePart)
WHERE p1.part_id < p2.part_id
RETURN p1.part_name, p2.part_name, count(DISTINCT s) AS times_together
ORDER BY times_together DESC;

// G6: Mechanics qualified in both specializations (multi-label)
MATCH (m:Mechanic:EngineMechanic:ElectricalMechanic)
RETURN m.name, labels(m) AS roles;

// G7: Shortest path from a customer to a supplier
MATCH (c:Customer {name:'Arun Kumar'}), (s:Supplier {name:'AutoParts Co'})
MATCH path = shortestPath((c)-[*..10]-(s))
RETURN path;

// G8: Revenue per mechanic
MATCH (m:Mechanic)-[:ASSIGNED_TO]->(:ServiceCard)-[:GENERATES]->(i:Invoice)
RETURN m.name, count(i) AS invoices, sum(i.total) AS revenue
ORDER BY revenue DESC;

// G9: Low-stock parts needed by pending jobs (Battery, Clutch Plate)
MATCH (s:ServiceCard)-[:INCLUDES]->(:PartUsed)-[:USES]->(p:SparePart)
WHERE s.status IN ['In Progress','Received'] AND p.stock_quantity < 10
RETURN DISTINCT p.part_name, p.stock_quantity, s.service_id;
