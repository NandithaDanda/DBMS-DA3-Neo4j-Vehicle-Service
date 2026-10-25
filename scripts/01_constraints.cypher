// ============================================================
// 01_constraints.cypher
// Vehicle Service Management System - Neo4j (DA3)
// Uniqueness constraints (graph equivalent of PRIMARY KEY / UNIQUE)
// ============================================================

CREATE CONSTRAINT cust_id IF NOT EXISTS FOR (c:Customer) REQUIRE c.person_id IS UNIQUE;
CREATE CONSTRAINT mech_id IF NOT EXISTS FOR (m:Mechanic) REQUIRE m.mechanic_id IS UNIQUE;
CREATE CONSTRAINT veh_id IF NOT EXISTS FOR (v:Vehicle) REQUIRE v.vehicle_id IS UNIQUE;
CREATE CONSTRAINT veh_reg IF NOT EXISTS FOR (v:Vehicle) REQUIRE v.registration_no IS UNIQUE;
CREATE CONSTRAINT veh_chs IF NOT EXISTS FOR (v:Vehicle) REQUIRE v.chassis_no IS UNIQUE;
CREATE CONSTRAINT svc_id IF NOT EXISTS FOR (s:ServiceCard) REQUIRE s.service_id IS UNIQUE;
CREATE CONSTRAINT item_id IF NOT EXISTS FOR (i:ServiceItem) REQUIRE i.item_id IS UNIQUE;
CREATE CONSTRAINT part_id IF NOT EXISTS FOR (p:SparePart) REQUIRE p.part_id IS UNIQUE;
CREATE CONSTRAINT sup_id IF NOT EXISTS FOR (s:Supplier) REQUIRE s.supplier_id IS UNIQUE;
CREATE CONSTRAINT inv_id IF NOT EXISTS FOR (i:Invoice) REQUIRE i.invoice_id IS UNIQUE;
CREATE CONSTRAINT pay_id IF NOT EXISTS FOR (p:Payment) REQUIRE p.payment_id IS UNIQUE;
