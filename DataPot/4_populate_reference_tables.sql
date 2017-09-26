/**  This script will load data from CSV files into reference tables.
	 Before running it, make sure you have copied all reference CSV files to the oracle server
	 and put it under a path where oracle (and 'grid' user in case of oracle 12c)
	 can access it.
	 Run this script after create_dataprofile.sql but before populate_dataprofile.sql.
	 Run the script as sysdba or another user who can create directories.
	 Alternatively use existing directory to which datapot has access already.
*/

-- Set the path here to wherever you put your reference csv files
CREATE OR REPLACE directory MYCSV
AS
  '/data_pump/mycsv';
GRANT read, write ON directory MYCSV TO datapot;
  
CREATE
  TABLE datapot.PATIENT_CLASS_ext
  (
    id          NUMBER,
    class_id    VARCHAR2(10),
    description VARCHAR(20)
  )
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('patient_class.csv')
  )
  reject limit unlimited;
  
CREATE TABLE datapot.firstname_ext (
    id			NUMBER,
    firstname   VARCHAR2(20)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('firstname.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.lastname_ext (
    id			NUMBER,
    lastname   VARCHAR2(20)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('lastname.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.streetaddress_ext (
    id			NUMBER,
    street   VARCHAR2(50)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('streetaddress.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.states_ext (
    id      NUMBER,
    state   VARCHAR2(30)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('states.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.city_ext (
	id     NUMBER,
    city   VARCHAR2(50)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('city.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.patient_namespaces_ext (
    id                NUMBER,
    namespace   varchar2(20)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('patient_namespaces.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.sex_ext (
    id            NUMBER,
    sex_id        VARCHAR2(10),
    description   VARCHAR(20)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('sex.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.race_ext (
    id            NUMBER,
    race_id       VARCHAR2(10),
    description   VARCHAR(55)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('race.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.marital_status_ext (
    id            NUMBER,
    marital_id    VARCHAR2(10),
    description   VARCHAR(30)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('marital_status.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.religion_ext (
    id            NUMBER,
    religion_id   VARCHAR2(10),
    description   VARCHAR(55)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('religion.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.ethnicity_ext (
    id            NUMBER,
    ethnic_id     VARCHAR2(10),
    description   VARCHAR(25)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('ethnicity.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.language_ext (
    id            NUMBER,
    language_id   VARCHAR2(10),
    description   VARCHAR(100)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('language.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.identifier_code_ext (
    id            NUMBER,
    code_id       VARCHAR2(10),
    description   VARCHAR(100)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('identifier_code.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.admit_reason_ext (
    id            NUMBER,
    description	varchar2(50)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('admit_reason.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.allergy_type_ext (
    id            NUMBER,
    type       VARCHAR2(10),
    description	varchar2(50)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('allergy_type.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.allergy_code_ext (
    id            NUMBER,
    code       VARCHAR2(10),
    description	varchar2(70)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('allergy_code.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.allergy_severity_ext (
    id            NUMBER,
    severity       VARCHAR2(5),
    description	varchar2(15)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('allergy_severity.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.allergy_reaction_ext (
    id            NUMBER,
    reaction       VARCHAR2(50)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('allergy_reaction.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.procedure_code_ext (
    id            NUMBER,
    code       VARCHAR2(10),
    description	varchar2(130)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('procedure_code.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.procedure_type_ext (
    id            NUMBER,
    type       VARCHAR2(3),
    description	varchar2(70)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('procedure_type.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.problem_code_ext (
    id            NUMBER,
    code       VARCHAR2(10),
    description	varchar2(180)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('problem_code.csv')
  )
  reject limit unlimited;

create table datapot.textualLabResults_ext (
	id NUMBER,
	text	varchar2(500)
	)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('textualLabResults.csv')
  )
  reject limit unlimited;

create table datapot.RadLabResults_ext (
	id NUMBER,
	text	varchar2(500)
	)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('RADLabResults.csv')
  )
  reject limit unlimited;

create table datapot.units_ext (
	id NUMBER,
	unit	varchar2(15)
	)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('units.csv')
  )
  reject limit unlimited;
	
create table datapot.resultStatuses_ext (
	id NUMBER,
	status	varchar2(3)
	)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('resultstatuses.csv')
  )
  reject limit unlimited;
	
create table datapot.diagnosticServices_ext (
	id NUMBER,
	service	varchar2(5)
	)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('diagnosticservices.csv')
  )
  reject limit unlimited;

create table datapot.uservice_ext (
	id	number,
	code	varchar2(15),
	description	varchar2(2000)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('uservice.csv')
  )
  reject limit unlimited;

create table datapot.obr_identifiers_ext (
	id	number,
	code	varchar2(15),
	description	varchar2(2000)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('obr_identifiers.csv')
  )
  reject limit unlimited;

create table datapot.obr_identifiers_RAD_ext (
	id	number,
	code	varchar2(15),
	description	varchar2(200)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('obr_identifiers_rad.csv')
  )
  reject limit unlimited;

create table datapot.diagnosis_code_ext (
	id	NUMBER,
	code	varchar2(10),
	description	varchar2(1000)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('diagnosis_code.csv')
  )
  reject limit unlimited;

create table datapot.diagnosis_type_ext (
	id	NUMBER,
	code	varchar2(1),
	description	varchar2(15)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('diagnosis_type.csv')
  )
  reject limit unlimited;

CREATE TABLE datapot.namespace_or_system_ext (
    id            NUMBER,
    system_id     VARCHAR2(10),
    description   VARCHAR(100)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('namespace_or_system.csv')
  )
  reject limit unlimited;
  
create table datapot.medication_names_ext (
	id	number,
	code varchar2(256),
	name varchar2(256),
	dosage varchar2(256)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('medication_names.csv')
  )
  reject limit unlimited;

create table datapot.medication_route_ext (
	id	number,
	code varchar2(256),
	description varchar2(256)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('medication_route.csv')
  )
  reject limit unlimited;

create table datapot.unit_combined_ext (
	id	number,
	unit varchar2(256)
)
  organization external
  (
    type ORACLE_LOADER DEFAULT directory MYCSV access parameters
    (
    records delimited BY newline
    fields terminated BY ","
    ) location ('unit_combined.csv')
  )
  reject limit unlimited;
  
INSERT INTO datapot.patient_class
  (SELECT * FROM datapot.patient_class_ext);
commit;
INSERT INTO datapot.admit_reason
  (SELECT * FROM datapot.admit_reason_ext);
commit;
INSERT INTO datapot.allergy_code
  (SELECT * FROM datapot.allergy_code_ext);
commit;
INSERT INTO datapot.allergy_reaction
  (SELECT * FROM datapot.allergy_reaction_ext);
commit;
INSERT INTO datapot.allergy_severity
  (SELECT * FROM datapot.allergy_severity_ext);
commit;
INSERT INTO datapot.allergy_type
  (SELECT * FROM datapot.allergy_type_ext);
commit;
INSERT INTO datapot.city
  (SELECT * FROM datapot.city_ext);
commit;
INSERT INTO datapot.diagnosis_code
  (SELECT * FROM datapot.diagnosis_code_ext);
commit;
INSERT INTO datapot.diagnosis_type
  (SELECT * FROM datapot.diagnosis_type_ext);
commit;
INSERT INTO datapot.diagnosticservices
  (SELECT * FROM datapot.diagnosticservices_ext);
commit;
INSERT INTO datapot.ethnicity
  (SELECT * FROM datapot.ethnicity_ext);
commit;
INSERT INTO datapot.firstname
  (SELECT * FROM datapot.firstname_ext);
commit;
INSERT INTO datapot.identifier_code
  (SELECT * FROM datapot.identifier_code_ext);
commit;
INSERT INTO datapot.language
  (SELECT * FROM datapot.language_ext);
commit;
INSERT INTO datapot.lastname
  (SELECT * FROM datapot.lastname_ext);
commit;
INSERT INTO datapot.marital_status
  (SELECT * FROM datapot.marital_status_ext);
commit;
INSERT INTO datapot.namespace_or_system
  (SELECT * FROM datapot.namespace_or_system_ext);
commit;
INSERT INTO datapot.obr_identifiers_rad
  (SELECT * FROM datapot.obr_identifiers_rad_ext);
commit;
INSERT INTO datapot.obr_identifiers
  (SELECT * FROM datapot.obr_identifiers_ext);
commit;
  INSERT INTO datapot.uservice
  (SELECT * FROM datapot.uservice_ext);
commit;
INSERT INTO datapot.patient_namespaces
  (SELECT * FROM datapot.patient_namespaces_ext);
commit;
INSERT INTO datapot.problem_code
  (SELECT * FROM datapot.problem_code_ext);
commit;
INSERT INTO datapot.procedure_code
  (SELECT * FROM datapot.procedure_code_ext);
commit;
INSERT INTO datapot.procedure_type
  (SELECT * FROM datapot.procedure_type_ext);
commit;
INSERT INTO datapot.race
  (SELECT * FROM datapot.race_ext);
commit;
INSERT INTO datapot.RADLabResults
  (SELECT * FROM datapot.RADLabResults_ext);
commit;
INSERT INTO datapot.religion
  (SELECT * FROM datapot.religion_ext);
commit;
INSERT INTO datapot.resultstatuses
  (SELECT * FROM datapot.resultstatuses_ext);
commit;
INSERT INTO datapot.sex
  (SELECT * FROM datapot.sex_ext);
commit;
INSERT INTO datapot.states
  (SELECT * FROM datapot.states_ext);
commit;
INSERT INTO datapot.streetaddress
  (SELECT * FROM datapot.streetaddress_ext);
commit;
INSERT INTO datapot.textualLabResults
  (SELECT * FROM datapot.textualLabResults_ext);
commit;
INSERT INTO datapot.units
  (SELECT * FROM datapot.units_ext);
commit;
INSERT INTO datapot.unit_combined
  (SELECT * FROM datapot.unit_combined_ext);
commit
INSERT INTO datapot.medication_names
  (SELECT * FROM datapot.medication_names_ext);
commit;
INSERT INTO datapot.medication_route
  (SELECT * FROM datapot.medication_route_ext);
commit;


drop table datapot.admit_reason_ext;
drop table datapot.allergy_code_ext;
drop table datapot.allergy_reaction_ext;
drop table datapot.allergy_severity_ext;
drop table datapot.allergy_type_ext;
drop table datapot.city_ext;
drop table datapot.diagnosis_code_ext;
drop table datapot.diagnosis_type_ext;
drop table datapot.diagnosticservices_ext;
drop table datapot.ethnicity_ext;
drop table datapot.firstname_ext;
drop table datapot.identifier_code_ext;
drop table datapot.language_ext;
drop table datapot.lastname_ext;
drop table datapot.marital_status_ext;
drop table datapot.medication_names_ext;
drop table datapot.medication_route_ext;
drop table datapot.namespace_or_system_ext;
drop table datapot.obr_identifiers_ext;
drop table datapot.obr_identifiers_rad_ext;
drop table datapot.patient_class_ext;
drop table datapot.patient_namespaces_ext;
drop table datapot.problem_code_ext;
drop table datapot.procedure_code_ext;
drop table datapot.procedure_type_ext;
drop table datapot.race_ext;
drop table datapot.radlabresults_ext;
drop table datapot.religion_ext;
drop table datapot.resultstatuses_ext;
drop table datapot.sex_ext;
drop table datapot.states_ext;
drop table datapot.streetaddress_ext;
drop table datapot.textuallabresults_ext;
drop table datapot.unit_combined_ext;
drop table datapot.units_ext;
drop table datapot.uservice_ext;