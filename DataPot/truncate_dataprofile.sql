/**	Use this script to clear all non-reference tables in the data profile, 
	and to reset the sequences to their initial state.
*/
truncate TABLE datapot.patients;
truncate TABLE datapot.encounters_distribution;
truncate TABLE datapot.encounters;
truncate TABLE datapot.allergies_distribution;
truncate TABLE datapot.allergies;
truncate TABLE datapot.problems_distribution;
truncate TABLE datapot.problems;
truncate TABLE datapot.procedures_distribution;
truncate TABLE datapot.procedures;
truncate TABLE datapot.labresults_distribution;
truncate TABLE datapot.labresults_OBR;
truncate TABLE datapot.labresults_OBX;
truncate TABLE datapot.diagnosis_distribution;
truncate TABLE datapot.diagnoses;
truncate TABLE datapot.medications_distribution;
truncate TABLE datapot.medications;
truncate table datapot.doctors;

DROP SEQUENCE datapot.encountersidsec;
DROP SEQUENCE datapot.allergiesidsec;
DROP SEQUENCE datapot.proceduresidsec;
DROP SEQUENCE datapot.problemsidsec;
DROP SEQUENCE datapot.labresultsidsec;
DROP SEQUENCE datapot.labresultsobxidsec;
DROP SEQUENCE datapot.diagnosisidsec;
DROP SEQUENCE datapot.medicationsidsec;
DROP SEQUENCE datapot.readORUsidsec;
DROP SEQUENCE datapot.readencountersidsec;
DROP SEQUENCE datapot.readpatientsidsec;
DROP SEQUENCE datapot.readduplicatepatientsidsec;
DROP SEQUENCE datapot.readpatientsidsecPPR;
DROP SEQUENCE datapot.readmedicationsidsec;

CREATE SEQUENCE datapot.encountersidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.allergiesidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.proceduresidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.problemsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.labresultsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.labresultsobxidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.diagnosisidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.medicationsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readencountersidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readpatientsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readduplicatepatientsidsec INCREMENT BY 1000 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readpatientsidsecPPR INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readmedicationsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;
CREATE SEQUENCE datapot.readORUsidsec INCREMENT BY 1 START WITH 1 CACHE 1000;