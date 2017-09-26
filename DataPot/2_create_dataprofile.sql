/** Run this script as datapot user.
*/

-- These sequences are used to generate ids in all the automatically populated tables.
CREATE SEQUENCE datapot.encountersidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.allergiesidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.proceduresidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.problemsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.labresultsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.labresultsobxidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.diagnosisidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.medicationsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.doctorsidsec INCREMENT BY 1 START WITH 100000000 CACHE 1000;

-- These sequences are used by rhapsody when its grabbing data from the database
CREATE SEQUENCE datapot.readencountersidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readpatientsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readduplicatepatientsidsec INCREMENT BY 1000 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readpatientsidsecPPR INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readmedicationsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readORUsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;

-- This table stores datapot configuration, mostly data distribution parameters
CREATE TABLE datapot.configuration (
    id            NUMBER,
    val           NUMBER,
    description   VARCHAR2(100)
);

/** Next set of tables are reference tables - they store reference data as per table name.
	That data is used to generate data profile.
*/
CREATE TABLE datapot.firstname (
	id			NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    firstname   VARCHAR2(100)
);

CREATE TABLE datapot.lastname (
	id			NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    lastname   VARCHAR2(100)
);

CREATE TABLE datapot.streetaddress (
	id			NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    street   VARCHAR2(100)
);

CREATE TABLE datapot.states (
    id      NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    state   VARCHAR2(50)
);

CREATE TABLE datapot.city (
	id      NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    city   VARCHAR2(50)
);

CREATE TABLE datapot.patient_namespaces (
    id                NUMBER,
    namespace   varchar2(50)
);

CREATE TABLE datapot.patient_class (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    class_id      VARCHAR2(50),
    description   VARCHAR(100)
);

CREATE TABLE datapot.sex (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    sex_id        VARCHAR2(50),
    description   VARCHAR(100)
);

CREATE TABLE datapot.race (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    race_id       VARCHAR2(10),
    description   VARCHAR(55)
);

CREATE TABLE datapot.marital_status (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    marital_id    VARCHAR2(10),
    description   VARCHAR(200)
);

CREATE TABLE datapot.religion (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    religion_id   VARCHAR2(10),
    description   VARCHAR(55)
);

CREATE TABLE datapot.ethnicity (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    ethnic_id     VARCHAR2(10),
    description   VARCHAR(25)
);

CREATE TABLE datapot.language (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    language_id   VARCHAR2(10),
    description   VARCHAR(100)
);

CREATE TABLE datapot.identifier_code (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    code_id       VARCHAR2(10),
    description   VARCHAR(100)
);

CREATE TABLE datapot.admit_reason (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    description	varchar2(2000)
);

CREATE TABLE datapot.allergy_type (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    type       VARCHAR2(10),
    description	varchar2(50)
);

CREATE TABLE datapot.allergy_code (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    code       VARCHAR2(10),
    description	varchar2(70)
);

CREATE TABLE datapot.allergy_severity (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    severity       VARCHAR2(50),
    description	varchar2(100)
);

CREATE TABLE datapot.allergy_reaction (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    reaction       VARCHAR2(50)
);

CREATE TABLE datapot.procedure_code (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    code       VARCHAR2(10),
    description	varchar2(130)
);

CREATE TABLE datapot.procedure_type (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    type       VARCHAR2(3),
    description	varchar2(70)
);

CREATE TABLE datapot.problem_code (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    code       VARCHAR2(10),
    description	varchar2(180)
);

create table datapot.textualLabResults (
	id number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	text	varchar2(500)
	);

create table datapot.RadLabResults (
	id number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	text	varchar2(500)
	);
	
create table datapot.rad_attachments (
	id number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	image_hex	clob
	);

create table datapot.units (
	id number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	unit	varchar2(15)
	);
	
create table datapot.resultStatuses (
	id number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	status	varchar2(3)
	);
	
create table datapot.diagnosticServices (
	id number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	service	varchar2(5)
	);
	
create table datapot.uservice (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code	varchar2(15),
	description	varchar2(2000)
);

create table datapot.obr_identifiers (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code	varchar2(15),
	description	varchar2(2000)
);

create table datapot.obr_identifiers_RAD (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code	varchar2(15),
	description	varchar2(200)
);

create table datapot.diagnosis_code (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code	varchar2(10),
	description	varchar2(1000)
);

create table datapot.diagnosis_type (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code	varchar2(1),
	description	varchar2(15)
);

create table datapot.medication_names (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code varchar2(256),
	name varchar2(256),
	dosage varchar2(256)
);

create table datapot.medication_route (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	code varchar2(256),
	description varchar2(256)
);
   
create table datapot.unit_combined (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	unit varchar2(256)
);

-- This table contains strings used as NamespaceID, UniversalID, UniversalIdType etc.
CREATE TABLE datapot.namespace_or_system (
    id            NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    system_id     VARCHAR2(10),
    description   VARCHAR(100)
);

-- This table stores doctors that are generated automatically
CREATE TABLE datapot.doctors (
    id          NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    doctor_id   VARCHAR2(10),
    fname       VARCHAR2(100),
    lname       VARCHAR2(100)
);

/** This table contains all the data about the patients that Datapot uses to populate PID and PV1 segments.
	It is populated automatically during data generation. */
CREATE TABLE datapot.patients (
    id               NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    patient_id       VARCHAR2(15),
    namespace		 varchar2(20),
    pclass           VARCHAR2(1),
    fname            VARCHAR2(100),
    lname            VARCHAR2(100),
    dob              timestamp,
    sex              VARCHAR2(3),
    race             VARCHAR2(10),
    religion         VARCHAR2(5),
    language         VARCHAR2(4),
    marital_status   VARCHAR2(3),
    id_code          VARCHAR2(5),
    ethnicity        VARCHAR2(1),
    streetaddress    VARCHAR2(105),
    city             VARCHAR2(50),
    country          VARCHAR2(20),
    state            VARCHAR2(50),
    zip              VARCHAR2(10),
    phone            VARCHAR2(15),
    hasDuplicate	 NUMBER,
    hasEncounters		 NUMBER
);

/** This table contains all the data about the encounters that Datapot uses to populate PV1 and PV2 segments.
	It is populated automatically during data generation. */
CREATE TABLE datapot.encounters (
    id                NUMBER PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    visit_id          VARCHAR2(15),
    enc_number	      NUMBER,
    pid               NUMBER,
    did               VARCHAR2(10),
    dfname            VARCHAR2(20),
    dlname            VARCHAR2(20),
    admit_date        timestamp,
    discharge_date    timestamp,
    admit_reason      VARCHAR2(50),
    ns1               VARCHAR2(10),
    ns2               VARCHAR2(10),
    ns3               VARCHAR2(10),
    ns4               VARCHAR2(10),
    ns5               VARCHAR2(10),
    ns6               VARCHAR2(10),
    ns7               VARCHAR2(10),
    ns8               VARCHAR2(10),
    ns9               VARCHAR2(10),
    ns10              VARCHAR2(10),
    ns11              VARCHAR2(10)
);

/** This table contains all the data about the allergies that Datapot uses to populate AL1 segment.
	It is populated automatically during data generation. */
create table datapot.allergies (
    id  number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    pid     number,
    type_id    varchar2(10),
    type_text   varchar2(50),
    code_id    varchar2(10),
    code_text   varchar2(70),
    severity_id varchar2(5),
    severity_text    varchar2(15),
    reaction    varchar2(50)
);

/** This table contains all the data about the procedures that Datapot uses to populate PR1 segment.
	It is populated automatically during data generation. */
create table datapot.procedures (
    id  number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    pid     number,
    type_id    varchar2(3),
    type_text   varchar2(70),
    code_id    varchar2(10),
    code_text   varchar2(130),
    p_date    timestamp
);

/** This table contains all the data about the problems that Datapot uses to populate PPR messages.
	It is populated automatically during data generation. */
create table datapot.problems (
    id  number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
    pid     number,
    code_id    varchar2(10),
    code_text   varchar2(180),
    p_date    timestamp,
    zpr varchar2(15),
    role	varchar2(10),
    rolePerson	varchar2(10),
    rolePersonAuthority	varchar2(15)
);

/** This table contains all the data about the lab results that Datapot uses to populate OBR segments.
	It is populated automatically during data generation. */
create table datapot.labresults_OBR (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	pid	number,
	place_order	varchar2(15),
	filler_order	varchar2(15),
	u_serviceid_code	varchar2(15),
	u_serviceid_text	varchar2(2000),	
	obr_time  timestamp,
	requested_time	timestamp,
	received_time	timestamp,
	provider_id	varchar2(10),
	provider_fname	varchar2(20),
	provider_lname	varchar2(20),
	resultStatus	varchar2(3),
	DiagnosticServSectID	varchar2(5),
	count_n	number,
	parentplacerorder	varchar2(15),
	parentfillerorder	varchar2(15)
	
);

/** This table stores all the data about the observations that Datapot uses to populate OBX segments.
	It is populated automatically during data generation. */
create table datapot.labresults_OBX (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	obrid	number,
	ref_range	varchar2(10),
	val	number,
	flag	varchar2(1),
	units	varchar2(15),
	value_type	varchar2(5),
	result_status	varchar2(15),
	freeText	varchar2(2000),
	obx_type	varchar2(40),
	obr_identifier_code	varchar2(200),
	obr_identifier_text	varchar2(2000),
	img	number,
	image_hex	clob	
);

/** This table stores diagnosis data.
*/
create table datapot.diagnoses (
	id	number	PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	encid	number,
	code	varchar2(10),
	code_desc	varchar2(1000),
	type	varchar2(1),
	dg_time	timestamp,
	sensitivity	varchar2(1)
);

/** This table stores medications data.
*/
create table datapot.medications (
	id	number PRIMARY KEY USING INDEX TABLESPACE CLINICAL,
	pid	number,
	orderNumber	varchar2(15),
	orderControlID	varchar2(15),
	orderStartDate	timestamp,
	orderEndDate	timestamp,
	triggerEvent	varchar2(20),
	prescriberID	varchar2(10),
	medicationCode	varchar2(256),
	medicationText	varchar2(256),
	medicationUnit	varchar2(256),
	dosage	varchar2(256),
	routeID	varchar2(256),
	routeText	varchar2(256)
);

/** This set of tables stores distributions of clinical data. 
They are populated automatically during data generation. */

CREATE TABLE datapot.encounters_distribution (
    pid                 NUMBER,
    encounters_number   NUMBER
);

CREATE TABLE datapot.allergies_distribution (
    pid                NUMBER,
    allergies_number   NUMBER
);

CREATE TABLE datapot.procedures_distribution (
    pid                NUMBER,
    procedures_number   NUMBER
);

CREATE TABLE datapot.problems_distribution (
    pid                NUMBER,
    problems_number   NUMBER
);

CREATE TABLE datapot.labresults_distribution (
    pid                NUMBER,
    labresults_number   NUMBER
);

CREATE TABLE datapot.diagnosis_distribution (
    encid                NUMBER,
    diagnosis_number   NUMBER
);

CREATE TABLE datapot.medications_distribution (
    pid                NUMBER,
    medications_number   NUMBER
);

/* Create all necessary indexes.
*/
CREATE INDEX datapot.PID_PROCEDURES ON datapot.PROCEDURES ("PID") NOLOGGING;
CREATE INDEX datapot.PID_ENCOUNTERS ON datapot.ENCOUNTERS ("PID") NOLOGGING;
CREATE INDEX datapot.PID_ALLERGIES ON datapot.ALLERGIES ("PID") NOLOGGING;
CREATE INDEX datapot.PID_PROBLEMS ON datapot.PROBLEMS ("PID") NOLOGGING;
CREATE INDEX datapot.PID_MEDICATIONS ON datapot.MEDICATIONS ("PID") NOLOGGING;
CREATE INDEX datapot.PID_LABRESULTS_OBR ON datapot.LABRESULTS_OBR ("PID") NOLOGGING;
CREATE INDEX datapot.ENCID ON datapot.DIAGNOSES ("ENCID") NOLOGGING;
CREATE INDEX datapot.OBRID ON datapot.LABRESULTS_OBX ("OBRID") NOLOGGING;

/* Put all big tables in NOLOGGING mode to speed up datapot tables population.
*/
alter table datapot.patients nologging;
alter table datapot.encounters nologging; 
alter table datapot.procedures nologging; 
alter table datapot.allergies nologging;
alter table datapot.problems nologging;
alter table datapot.medications nologging;
alter table datapot.labresults_obr nologging;
alter table datapot.labresults_obx nologging;
alter table datapot.encounters_distribution nologging; 
alter table datapot.procedures_distribution nologging; 
alter table datapot.allergies_distribution nologging;
alter table datapot.problems_distribution nologging;
alter table datapot.medications_distribution nologging;
alter table datapot.labresults_distribution nologging;
alter table datapot.diagnosis_distribution nologging;
alter table datapot.diagnoses nologging;


/** Template for adding a custom distribution for one of the fields.
	The distribution would define how field values should be distributed.
	E.g. instead of uniform distribution of allergy severity you can define 50% for moderate,
	38% for severe, 12% for mild.
	Use id from the appropriate reference table (e.g. allergy_severity) to populate the id column
	and whatever percentage you need for the percentage column.
	You can either populate this table using "insert" statements, or create a distribution
	in an external tool (e.g. R or Excel) and import it as CSV file.

CREATE TABLE datapot.NAME_distribution (
    id                NUMBER,
    percentage   NUMBER
);

*/
