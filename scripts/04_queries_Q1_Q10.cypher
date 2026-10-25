// ============================================================
// 04_queries_Q1_Q10.cypher
// DA2 SQL queries re-written in Cypher
// ============================================================

// Q1: Vehicles with owner details (expect 8 rows)
MATCH (c:Customer)-[:OWNS]->(v:Vehicle)
RETURN v.vehicle_id, v.registration_no, v.brand, c.name AS customer, c.phone
ORDER BY c.name;

// Q2: Service cards not yet completed (expect services 6,7,8,9,10)
MATCH (s:ServiceCard)
WHERE s.status <> 'Completed'
RETURN s.service_id, s.complaint, s.status, s.est_delivery
ORDER BY s.est_delivery;

// Q3: Count of service jobs by status (Completed 5, In Progress 3, Received 2)
MATCH (s:ServiceCard)
RETURN s.status, count(*) AS total_jobs
ORDER BY total_jobs DESC;

// Q4: Mechanics assigned to more than two service cards (Suresh B 4, Ravi T 4)
MATCH (m:Mechanic)-[:ASSIGNED_TO]->(s:ServiceCard)
WITH m, count(s) AS jobs
WHERE jobs > 2
RETURN m.name, jobs;

// Q5: Vehicles of a selected brand (Honda, expect 2)
MATCH (v:Vehicle {brand:'Honda'})
RETURN v.registration_no, v.brand, labels(v) AS type;

// Q6: Registration numbers containing 'TN01' (expect 3)
MATCH (v:Vehicle)
WHERE v.registration_no CONTAINS 'TN01'
RETURN v.registration_no, v.brand;

// Q7: Total spare-part stock value (expect 174700)
MATCH (p:SparePart)
RETURN sum(p.stock_quantity * p.unit_price) AS total_stock_value;

// Q8: Highest-value invoices
MATCH (i:Invoice)
RETURN i.invoice_id, i.total
ORDER BY i.total DESC
LIMIT 3;

// Q9: Customers who own more than one vehicle (Arun, Meena, Priya)
MATCH (c:Customer)-[:OWNS]->(v:Vehicle)
WITH c, count(v) AS vehicles
WHERE vehicles > 1
RETURN c.name, vehicles;

// Q10: Total payments received for each invoice
MATCH (i:Invoice)<-[:PAYS]-(p:Payment)
RETURN i.invoice_id, i.total AS invoice_total, sum(p.amount) AS paid, count(p) AS payments
ORDER BY i.invoice_id;
