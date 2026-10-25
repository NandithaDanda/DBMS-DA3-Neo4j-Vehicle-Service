// ============================================================
// 06_extras.cypher
// Transaction, audit log (trigger equivalent), index/PROFILE, full-text search
// ============================================================

// D1. Atomic transaction: add a part to a service and reduce stock together
MATCH (s:ServiceCard {service_id:10}), (p:SparePart {part_id:7})
WHERE p.stock_quantity >= 2
CREATE (s)-[:INCLUDES]->(:ServiceItem:PartUsed {item_id:24, quantity:2, unit_price:p.unit_price, discount:0})-[:USES]->(p)
SET p.stock_quantity = p.stock_quantity - 2
RETURN p.part_name, p.stock_quantity;

// D2. Audit log (graph equivalent of the MySQL status-change trigger)
MATCH (s:ServiceCard {service_id:8})
WITH s, s.status AS old_status
SET s.status = 'In Progress'
CREATE (s)-[:HAS_LOG]->(:StatusLog {old_status:old_status, new_status:'In Progress', changed_at:datetime()})
RETURN s.service_id, old_status, s.status;

// D2 view the log
MATCH (s:ServiceCard)-[:HAS_LOG]->(l:StatusLog)
RETURN s.service_id, l.old_status, l.new_status, l.changed_at;

// D3. Index and query plan
CREATE INDEX svc_status IF NOT EXISTS FOR (s:ServiceCard) ON (s.status);

PROFILE MATCH (s:ServiceCard {status:'In Progress'}) RETURN s.service_id;

// D4. Full-text search on complaints
CREATE FULLTEXT INDEX complaint_search IF NOT EXISTS FOR (s:ServiceCard) ON EACH [s.complaint];

// (wait about 30 seconds before running the next query)
CALL db.index.fulltext.queryNodes('complaint_search', 'brake OR clutch OR engine')
YIELD node, score
RETURN node.service_id, node.complaint, score
ORDER BY score DESC;

// ------------------------------------------------------------
// OPTIONAL CLEANUP: restores the data changed by D1 and D2
// ------------------------------------------------------------
// MATCH (s:ServiceCard {service_id:8}) SET s.status='Received';
// MATCH (l:StatusLog) DETACH DELETE l;
// MATCH (i:ServiceItem {item_id:24})-[:USES]->(p:SparePart) SET p.stock_quantity = p.stock_quantity + 2 DETACH DELETE i;
