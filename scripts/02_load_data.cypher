// ============================================================
// 02_load_data.cypher
// Sample dataset. Run the statements in order, one at a time.
// To start over: MATCH (n) DETACH DELETE n;
// ============================================================

// ---------- Customers ----------
UNWIND [
 {id:1,name:'Arun Kumar',phone:'9876501001',addr:'Chennai',reg:'2026-01-10'},
 {id:2,name:'Meena Ravi',phone:'9876501002',addr:'Tambaram',reg:'2026-02-12'},
 {id:3,name:'Karthik S',phone:'9876501004',addr:'Adyar',reg:'2026-03-01'},
 {id:4,name:'Priya Nair',phone:'9876501005',addr:'Anna Nagar',reg:'2026-03-15'},
 {id:5,name:'Rahul Verma',phone:'9876501006',addr:'Velachery',reg:'2026-04-02'}
] AS r
CREATE (:Customer {person_id:r.id, name:r.name, phone:r.phone, address:r.addr, registration_date:date(r.reg)});

// ---------- Mechanics ----------
UNWIND [
 {id:1,name:'Suresh B',phone:'9876501003',join:'2024-06-01',sal:28000,shift:'Day'},
 {id:2,name:'Ravi T',phone:'9876502001',join:'2023-02-15',sal:26000,shift:'Night'},
 {id:3,name:'Divya M',phone:'9876502002',join:'2025-01-20',sal:27000,shift:'Day'}
] AS r
CREATE (:Mechanic {mechanic_id:r.id, name:r.name, phone:r.phone, joining_date:date(r.join), salary:r.sal, shift:r.shift});

// Specializations (overlapping) as extra labels
MATCH (m:Mechanic) WHERE m.mechanic_id IN [1,2] SET m:EngineMechanic;
MATCH (m:Mechanic) WHERE m.mechanic_id IN [1,3] SET m:ElectricalMechanic;

// ---------- Vehicles (Cars) + OWNS ----------
UNWIND [
 {id:1,chs:'CHS10001',reg:'TN01AB1234',brand:'Honda',owner:1},
 {id:2,chs:'CHS10002',reg:'TN10CD5678',brand:'Hyundai',owner:2},
 {id:4,chs:'CHS10004',reg:'TN22GH3456',brand:'Toyota',owner:3},
 {id:6,chs:'CHS10006',reg:'TN01LM2345',brand:'Maruti',owner:4},
 {id:7,chs:'CHS10007',reg:'TN07NP6789',brand:'Hyundai',owner:5}
] AS r
MATCH (c:Customer {person_id:r.owner})
CREATE (c)-[:OWNS]->(:Vehicle:Car {vehicle_id:r.id, chassis_no:r.chs, registration_no:r.reg, brand:r.brand});

// ---------- Vehicles (Motorcycles) + OWNS ----------
UNWIND [
 {id:3,chs:'CHS10003',reg:'TN01EF9012',brand:'Honda',owner:1},
 {id:5,chs:'CHS10005',reg:'TN09JK7890',brand:'Yamaha',owner:4},
 {id:8,chs:'CHS10008',reg:'TN10QR1122',brand:'Royal Enfield',owner:2}
] AS r
MATCH (c:Customer {person_id:r.owner})
CREATE (c)-[:OWNS]->(:Vehicle:Motorcycle {vehicle_id:r.id, chassis_no:r.chs, registration_no:r.reg, brand:r.brand});

// ---------- Spare parts ----------
UNWIND [
 {id:1,name:'Oil Filter',stock:40,price:250},
 {id:2,name:'Brake Pad',stock:25,price:900},
 {id:3,name:'Spark Plug',stock:60,price:150},
 {id:4,name:'Air Filter',stock:30,price:350},
 {id:5,name:'Battery',stock:8,price:4500},
 {id:6,name:'Clutch Plate',stock:6,price:1200},
 {id:7,name:'Headlight Bulb',stock:50,price:120},
 {id:8,name:'Engine Oil 5L',stock:35,price:2100}
] AS r
CREATE (:SparePart {part_id:r.id, part_name:r.name, stock_quantity:r.stock, unit_price:r.price});

// ---------- Suppliers ----------
UNWIND [
 {id:1,name:'AutoParts Co',phone:'9000000001',addr:'Guindy'},
 {id:2,name:'SpeedSpares',phone:'9000000002',addr:'Ambattur'},
 {id:3,name:'PowerCell Traders',phone:'9000000003',addr:'Perungudi'},
 {id:4,name:'MotoMart',phone:'9000000004',addr:'T Nagar'}
] AS r
CREATE (:Supplier {supplier_id:r.id, name:r.name, phone:r.phone, address:r.addr});

// ---------- SUPPLIED_BY (many-to-many, no junction table) ----------
UNWIND [[1,1],[2,1],[2,2],[3,2],[4,1],[5,3],[6,4],[7,3],[7,4],[8,1],[8,2]] AS pair
MATCH (p:SparePart {part_id:pair[0]}), (s:Supplier {supplier_id:pair[1]})
CREATE (p)-[:SUPPLIED_BY]->(s);

// ---------- Service cards + HAS_SERVICE + ASSIGNED_TO ----------
UNWIND [
 {id:1,veh:1,mech:1,start:'2026-03-05',end:'2026-03-08',comp:'Engine noise and oil leak',est:'2026-03-08',act:'2026-03-08',st:'Completed'},
 {id:2,veh:2,mech:2,start:'2026-03-10',end:'2026-03-12',comp:'Brake squealing',est:'2026-03-12',act:'2026-03-13',st:'Completed'},
 {id:3,veh:3,mech:1,start:'2026-03-20',end:'2026-03-21',comp:'Bike not starting',est:'2026-03-21',act:'2026-03-21',st:'Completed'},
 {id:4,veh:4,mech:2,start:'2026-04-02',end:'2026-04-05',comp:'Regular service and oil change',est:'2026-04-05',act:'2026-04-05',st:'Completed'},
 {id:5,veh:5,mech:3,start:'2026-04-10',end:'2026-04-11',comp:'Headlight not working',est:'2026-04-11',act:'2026-04-11',st:'Completed'},
 {id:6,veh:1,mech:1,start:'2026-05-02',end:null,comp:'AC not cooling and battery weak',est:'2026-05-06',act:null,st:'In Progress'},
 {id:7,veh:6,mech:2,start:'2026-05-05',end:null,comp:'Clutch slipping',est:'2026-05-09',act:null,st:'In Progress'},
 {id:8,veh:7,mech:1,start:'2026-05-08',end:null,comp:'Overheating engine',est:'2026-05-12',act:null,st:'Received'},
 {id:9,veh:2,mech:2,start:'2026-05-10',end:null,comp:'Periodic service',est:'2026-05-13',act:null,st:'In Progress'},
 {id:10,veh:8,mech:3,start:'2026-05-12',end:null,comp:'Spark plug misfire',est:'2026-05-14',act:null,st:'Received'}
] AS r
MATCH (v:Vehicle {vehicle_id:r.veh}), (m:Mechanic {mechanic_id:r.mech})
CREATE (v)-[:HAS_SERVICE]->(s:ServiceCard {service_id:r.id, start_date:date(r.start), end_date:date(r.end), complaint:r.comp, est_delivery:date(r.est), actual_delivery:date(r.act), status:r.st})
CREATE (m)-[:ASSIGNED_TO]->(s);

// ---------- Service items: parts used (INCLUDES, USES) ----------
UNWIND [
 {item:1,svc:1,part:1,qty:1,price:250},{item:3,svc:2,part:2,qty:1,price:900},
 {item:5,svc:3,part:3,qty:1,price:150},{item:7,svc:4,part:1,qty:1,price:250},
 {item:8,svc:4,part:8,qty:1,price:2100},{item:10,svc:4,part:4,qty:1,price:350},
 {item:11,svc:5,part:7,qty:2,price:120},{item:13,svc:6,part:5,qty:1,price:4500},
 {item:15,svc:7,part:6,qty:1,price:1200},{item:18,svc:8,part:8,qty:1,price:2100},
 {item:19,svc:9,part:1,qty:1,price:250},{item:20,svc:9,part:4,qty:1,price:350},
 {item:22,svc:10,part:3,qty:4,price:150}
] AS r
MATCH (s:ServiceCard {service_id:r.svc}), (p:SparePart {part_id:r.part})
CREATE (s)-[:INCLUDES]->(:ServiceItem:PartUsed {item_id:r.item, quantity:r.qty, unit_price:r.price, discount:0})-[:USES]->(p);

// ---------- Service items: labour ----------
UNWIND [
 {item:2,svc:1,hrs:2,charge:800},{item:4,svc:2,hrs:1.5,charge:600},
 {item:6,svc:3,hrs:1,charge:400},{item:9,svc:4,hrs:1.5,charge:700},
 {item:12,svc:5,hrs:0.5,charge:300},{item:14,svc:6,hrs:2,charge:900},
 {item:16,svc:7,hrs:3,charge:1500},{item:17,svc:8,hrs:2,charge:1000},
 {item:21,svc:9,hrs:1.5,charge:700},{item:23,svc:10,hrs:1,charge:500}
] AS r
MATCH (s:ServiceCard {service_id:r.svc})
CREATE (s)-[:INCLUDES]->(:ServiceItem:LabourService {item_id:r.item, quantity:1, unit_price:r.charge, discount:0, labour_hours:r.hrs});

// ---------- Invoices + GENERATES ----------
UNWIND [
 {id:1,svc:1,date:'2026-03-08',sub:1050.0,tax:189.0,total:1239.0},
 {id:2,svc:2,date:'2026-03-13',sub:1500.0,tax:270.0,total:1770.0},
 {id:3,svc:3,date:'2026-03-21',sub:550.0,tax:99.0,total:649.0},
 {id:4,svc:4,date:'2026-04-05',sub:3400.0,tax:612.0,total:4012.0},
 {id:5,svc:5,date:'2026-04-11',sub:540.0,tax:97.2,total:637.2}
] AS r
MATCH (s:ServiceCard {service_id:r.svc})
CREATE (s)-[:GENERATES]->(:Invoice {invoice_id:r.id, invoice_date:date(r.date), subtotal:r.sub, tax:r.tax, total:r.total});

// ---------- Payments + PAYS ----------
UNWIND [
 {id:1,inv:1,date:'2026-03-08',amt:1239.0,method:'UPI',upi:'arun@upi',txn:'TXN778899',last4:null,bank:null},
 {id:2,inv:2,date:'2026-03-13',amt:1000.0,method:'Cash',upi:null,txn:null,last4:null,bank:null},
 {id:3,inv:2,date:'2026-03-13',amt:770.0,method:'Card',upi:null,txn:null,last4:'4321',bank:'HDFC'},
 {id:4,inv:3,date:'2026-03-21',amt:649.0,method:'Cash',upi:null,txn:null,last4:null,bank:null},
 {id:5,inv:4,date:'2026-04-05',amt:4012.0,method:'Card',upi:null,txn:null,last4:'9876',bank:'SBI'},
 {id:6,inv:5,date:'2026-04-11',amt:637.2,method:'UPI',upi:'priya@upi',txn:'TXN445566',last4:null,bank:null}
] AS r
MATCH (i:Invoice {invoice_id:r.inv})
CREATE (:Payment {payment_id:r.id, payment_date:date(r.date), amount:r.amt, method:r.method, upi_id:r.upi, txn_id:r.txn, card_last4:r.last4, bank:r.bank})-[:PAYS]->(i);

// ---------- Verification ----------
MATCH (n) UNWIND labels(n) AS label RETURN label, count(*) AS total ORDER BY label;
CALL db.schema.visualization();
