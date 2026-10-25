// ============================================================
// 03_crud.cypher
// CRUD operations (replaces the Java Swing insert/update/delete forms)
// ============================================================

// A1. CREATE: new customer, vehicle and service card
CREATE (c:Customer {person_id:6, name:'Anita Das', phone:'9876501007', address:'Porur', registration_date:date()})
CREATE (c)-[:OWNS]->(v:Vehicle:Car {vehicle_id:9, chassis_no:'CHS10009', registration_no:'TN11ST4455', brand:'Tata'})
CREATE (v)-[:HAS_SERVICE]->(s:ServiceCard {service_id:11, start_date:date(), complaint:'Steering vibration', est_delivery:date()+duration({days:3}), status:'Received'})
RETURN c, v, s;

// A2. READ
MATCH (c:Customer {name:'Anita Das'})-[:OWNS]->(v)-[:HAS_SERVICE]->(s)
RETURN c.name, v.registration_no, s.service_id, s.complaint, s.status;

// A3. UPDATE: assign a mechanic and change status
MATCH (s:ServiceCard {service_id:11}), (m:Mechanic {mechanic_id:3})
CREATE (m)-[:ASSIGNED_TO]->(s)
SET s.status = 'In Progress'
RETURN s.service_id, s.status, m.name;

// A4. CONSTRAINT TEST: this is EXPECTED to fail (duplicate registration_no)
CREATE (:Vehicle {vehicle_id:99, chassis_no:'CHSXXXX', registration_no:'TN01AB1234', brand:'Test'});

// A5. DELETE (cleanup of the test records)
MATCH (c:Customer {person_id:6})-[:OWNS]->(v:Vehicle)
OPTIONAL MATCH (v)-[:HAS_SERVICE]->(s:ServiceCard)
DETACH DELETE s, v, c;

// A5 check: should return 0 rows
MATCH (c:Customer {person_id:6}) RETURN c;
