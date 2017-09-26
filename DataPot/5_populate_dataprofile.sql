/** BeFORe running this script, you need to create the schema 
	and to import data INTO the following reference tables
	using either the CSV files IN the "resources" folder, or your own data:
	- firstname,
	- lastname,
	- identifier_code,
	- city,
	- patient_namespaces,
	- streetaddress,
	- ethnicity,
	- language,
	- marital_status,
	- patient_class,
	- race,
	- religion,
	- sex,
	- states,
	- allergy_code,
	- allergy_type,
	- allergy_severity,
	- allergy_reaction,
	- procedure_code,
	- procedure_type,
	- problem_code,
	- diagnosticservices,
	- obr_identifiers,
	- obr_identifiers_rad,
	- obr_identifiers_text,
	- patient_namespaces,
	- radlabresults,
	- resultstatuses,
	- textuallabresults,
	- units,
	- admit_reason.
The script uses those tables to generate random data.
*/

/** Generating patients. */
DECLARE
    lastname			VARCHAR2(100);
    firstname			VARCHAR2(100);
    streetaddress			VARCHAR2(40);
    city				VARCHAR2(50);
    lastname_num		NUMBER;
    firstname_num		NUMBER;
    streetaddress_num	NUMBER;
    city_num			NUMBER;
    sex              	VARCHAR2(1);
    race             	VARCHAR2(6);
    religion         	VARCHAR2(5);
    language         	VARCHAR2(4);
    marital_status   	VARCHAR2(1);
    id_code          	VARCHAR2(5);
    ethnicity        	VARCHAR2(1);
    state            	VARCHAR2(50);
    pclass           	VARCHAR2(1);
    namespace		 	VARCHAR2(20);
    pNUMBER          	NUMBER;
    sex_num			 	NUMBER;
    race_num		 	NUMBER;
    religion_num	 	NUMBER;
    language_num	 	NUMBER;
    marital_status_num	NUMBER;
    id_code_num		 	NUMBER;
    ethnicity_num	 	NUMBER;
    state_num		 	NUMBER;
    pclass_num		 	NUMBER;
    namespace_num	 	NUMBER;
    temp 				NUMBER;
    duplicates_num		NUMBER;
    is_dup				NUMBER;
    j					NUMBER;
    startN				NUMBER;
    dob					timestamp;
BEGIN
    -- Get desired END NUMBER of patients.
    SELECT val + countn INTO pNUMBER FROM datapot.configuration, 
		(SELECT count(*) as countn FROM datapot.patients) WHERE id = 1;
	-- Get existing NUMBER of patients
	SELECT count(*) + 1 INTO startN FROM datapot.patients;
    -- Get NUMBER of duplicates - these are additional patient records that mostly copy primary ones.
    SELECT val INTO duplicates_num FROM datapot.configuration WHERE id = 12;
    -- Get NUMBER of various reference data items to use later IN a randomiser.
    SELECT count(*) INTO sex_num FROM datapot.sex;
    SELECT count(*) INTO race_num FROM datapot.race;
    SELECT count(*) INTO religion_num FROM datapot.religion;
    SELECT count(*) INTO language_num FROM datapot.language;
    SELECT count(*) INTO marital_status_num FROM datapot.marital_status;
    SELECT count(*) INTO id_code_num FROM datapot.identifier_code;
    SELECT count(*) INTO ethnicity_num FROM datapot.ethnicity;
    SELECT count(*) INTO state_num FROM datapot.states;
    SELECT count(*) INTO pclass_num FROM datapot.patient_class;
    SELECT count(*) INTO namespace_num FROM datapot.patient_namespaces;
    SELECT count(*) INTO lastname_num FROM datapot.lastname;
    SELECT count(*) INTO firstname_num FROM datapot.firstname;
    SELECT count(*) INTO city_num FROM datapot.city;
    SELECT count(*) INTO streetaddress_num FROM datapot.streetaddress;
    -- j controls the duplicate id which will be calculated as pNUMBER + j.
    j := 1;
    -- FOR each patient...
    FOR i IN startN..pNUMBER LOOP
        -- ...get random reference data to use later...
        SELECT sex_id INTO sex FROM datapot.sex WHERE id=trunc(dbms_random.value(1,sex_num + 0.9));
        SELECT race_id INTO race FROM datapot.race WHERE id=trunc(dbms_random.value(1,race_num + 0.9));
        SELECT religion_id INTO religion FROM datapot.religion WHERE id=trunc(dbms_random.value(1,religion_num + 0.9));
        SELECT language_id INTO language FROM datapot.language WHERE id=trunc(dbms_random.value(1,language_num + 0.9));
        SELECT marital_id INTO marital_status FROM datapot.marital_status WHERE id=trunc(dbms_random.value(1,marital_status_num + 0.9));
        SELECT code_id INTO id_code FROM datapot.identifier_code WHERE id=trunc(dbms_random.value(1,id_code_num + 0.9));
        SELECT ethnic_id INTO ethnicity FROM datapot.ethnicity WHERE id=trunc(dbms_random.value(1,ethnicity_num + 0.9));
        SELECT state INTO state FROM datapot.states WHERE id=trunc(dbms_random.value(1,state_num + 0.9));
        SELECT class_id INTO pclass FROM datapot.patient_class WHERE id=trunc(dbms_random.value(1,pclass_num + 0.9));
        SELECT trunc(dbms_random.value(1,namespace_num + 0.9)) INTO temp FROM dual;
        SELECT namespace INTO namespace FROM datapot.patient_namespaces WHERE id=temp;
        SELECT lastname INTO lastname FROM datapot.lastname WHERE id=trunc(dbms_random.value(1,lastname_num + 0.9));
        SELECT firstname INTO firstname FROM datapot.firstname WHERE id=trunc(dbms_random.value(1,firstname_num + 0.9));
        SELECT city INTO city FROM datapot.city WHERE id=trunc(dbms_random.value(1,city_num + 0.9));
        SELECT street INTO streetaddress FROM datapot.streetaddress WHERE id=trunc(dbms_random.value(1,streetaddress_num + 0.9));
        -- ...check whether this patient needs to have a duplicate as per datapot configuration...
        IF i > pNUMBER - duplicates_num THEN
        	is_dup := 1;
        ELSE
        	is_dup := 0;
        END IF;
        -- ...generate random DOB which will later be shifted IN the rhapsody route to be withIN 1900 and 1999...
        SELECT SYSDATE - floor(dbms_random.value(0,1000000)) INTO dob FROM dual;
        -- ...generate a patient record...
        INSERT /*+ append */ INTO datapot.patients VALUES (
            i,
            ltrim(to_char(i,'0000000009')),
            namespace,
            pclass,
            firstname,
            lastname,
            dob,
            sex,
            race,
            religion,
            language,
            marital_status,
            id_code,
            ethnicity,
            trunc(dbms_random.value(1,999)) || ' ' || streetaddress,
            city,
            'USA',
            state,
            trunc(dbms_random.value(10000,99999)),
            trunc(dbms_random.value(1000000000,9999999999)),
            is_dup,
            1
        );
        -- ...IF the patient needs to be duplicated, generate another patient record with slightly different data,
        --	  it is expected that NextGate will recognize this is the same patient and will merge both records together.
        IF is_dup = 1 THEN
        	SELECT trunc(dbms_random.value(1,namespace_num + 0.9)) INTO temp FROM dual;
        	SELECT namespace INTO namespace FROM datapot.patient_namespaces WHERE id=temp;
        	INSERT /*+ append */ INTO datapot.patients VALUES (
            	pNUMBER + j,
            	ltrim(to_char(pNUMBER+j,'0000000009')),
            	namespace,
            	pclass,
            	firstname,
            	lastname,
            	dob,
            	sex,
            	race,
            	religion,
            	language,
            	marital_status,
            	id_code,
            	ethnicity,
            	trunc(dbms_random.value(1,999)) || ' ' || streetaddress,
            	city,
            	'USA',
            	state,
            	trunc(dbms_random.value(10000,99999)),
            	trunc(dbms_random.value(1000000000,9999999999)),
            	is_dup,
            	1
        	);
        	j := j+1;
        END IF; 
        -- COMMIT every 5000 iterations to keep redo logs small
        IF mod(i, 5000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/

/** Generating a log normal distribution to define NUMBER of encounters per patient.
*/
DECLARE
    enc NUMBER;
    pNUMBER	NUMBER;
    enc_median	NUMBER;
    enc_std	NUMBER;
    startN NUMBER;
BEGIN
SELECT count(*) INTO pNUMBER FROM datapot.patients;
SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.encounters_distribution;
SELECT val INTO enc_median FROM datapot.configuration WHERE id = 2;
SELECT val INTO enc_std FROM datapot.configuration WHERE id = 3;
FOR i IN startN..pNUMBER LOOP
    LOOP
        SELECT trunc(dbms_random.normal * enc_std + enc_median) INTO enc FROM dual;
        exit when enc > 0;
    END LOOP;
    INSERT INTO datapot.encounters_distribution values (
        i,
        enc
    );
    -- COMMIT every 5000 iterations to keep redo logs small
        IF mod(i, 5000) = 0 THEN
        	COMMIT;
        END IF;
end LOOP;
COMMIT;
END;
/

/** Generating doctors
*/
declare
    dfname VARCHAR2(100);
    dlname VARCHAR2(100);
    d_count	NUMBER;
    fname_num	NUMBER;
    lname_num 	NUMBER;
begin
    SELECT val INTO d_count FROM datapot.configuration WHERE id = 13;
    select count(*) into fname_num from datapot.firstname;
    select count(*) into lname_num from datapot.lastname;
    FOR i IN 1..d_count LOOP
		select firstname into dfname from datapot.firstname where id=trunc(dbms_random.value(1,fname_num + 0.9));
		select lastname into dlname from datapot.lastname where id=trunc(dbms_random.value(1,lname_num + 0.9));
        INSERT /*+ append */ INTO datapot.doctors values (
            i,
            datapot.doctorsidsec.nextval,
            dfname,
            dlname
            );
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/

/** Generating encounters.
	Please note that ns1-ns11 fields are here to make it easier for Rhapsody route to pick up
	encounters in bulk. This might be changed to a prettier code in the next datapot version.
*/
DECLARE
    enc_num NUMBER;
    cursor enc_counts is SELECT encounters_NUMBER FROM datapot.encounters_distribution
    	WHERE pid > (SELECT nvl(max(pid), 0) FROM datapot.encounters);
    did VARCHAR2(10);
    dfname	VARCHAR2(20);
    dlname  VARCHAR2(20);
    pNUMBER	NUMBER;
    ns1 VARCHAR2(10);
    ns2 VARCHAR2(10);
    ns3 VARCHAR2(10);
    ns4 VARCHAR2(10);
    ns5 VARCHAR2(10);
    ns6 VARCHAR2(10);
    ns7 VARCHAR2(10);
    ns8 VARCHAR2(10);
    ns9 VARCHAR2(10);
    ns10 VARCHAR2(10);
    ns11 VARCHAR2(10);
    admit_reason	VARCHAR2(50);
    admit_reason_count	NUMBER;
    d_count	NUMBER;
    startN	NUMBER;
    admitDate	timestamp;
begin
    open enc_counts;
    -- Get number of doctors.
    SELECT val INTO d_count FROM datapot.configuration WHERE id = 13;
    -- Get desired number of patients with encounters.
    SELECT count(*) INTO pnumber FROM datapot.patients;
	-- Get existing number of patients with encounters
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.encounters;
    -- Get NUMBER of admit reasons.
    SELECT count(*) INTO admit_reason_count FROM datapot.admit_reason;
    SELECT system_id INTO ns1 FROM datapot.namespace_or_system WHERE id=1;
    SELECT system_id INTO ns2 FROM datapot.namespace_or_system WHERE id=2;
    SELECT system_id INTO ns3 FROM datapot.namespace_or_system WHERE id=3;
    SELECT system_id INTO ns4 FROM datapot.namespace_or_system WHERE id=4;
    SELECT system_id INTO ns5 FROM datapot.namespace_or_system WHERE id=5;
    SELECT system_id INTO ns6 FROM datapot.namespace_or_system WHERE id=6;
    SELECT system_id INTO ns7 FROM datapot.namespace_or_system WHERE id=7;
    SELECT system_id INTO ns8 FROM datapot.namespace_or_system WHERE id=8;
    SELECT system_id INTO ns9 FROM datapot.namespace_or_system WHERE id=9;
    SELECT system_id INTO ns10 FROM datapot.namespace_or_system WHERE id=10;
    SELECT system_id INTO ns11 FROM datapot.namespace_or_system WHERE id=11;
    -- FOR every non-duplicate patient...
    FOR i IN startN..pNUMBER LOOP
    	-- ...get NUMBER of encounters that patient should have...
        fetch enc_counts INTO enc_num;
        -- ...and FOR each encounter FOR that patient...
        FOR j IN 1..enc_num LOOP
        	-- ...get a random doctor...
        	SELECT doctor_id,fname,lname INTO did, dfname, dlname FROM datapot.doctors WHERE id=trunc(dbms_random.value(1,d_count + 0.9));
            -- ...get a random admit reason...
            SELECT description INTO admit_reason FROM datapot.admit_reason WHERE id=trunc(dbms_random.value(1,admit_reason_count + 0.9));
            -- ... and create an encounter with a random admit date.
            SELECT sysdate - floor(dbms_random.value(1000,10000)) into admitDate from dual;
            INSERT /*+ append */ INTO datapot.encounters values (
                datapot.encountersidsec.nextval,
                dbms_random.string('U',10),
                j,
                i,
                did,
                dfname,
                dlname,
                admitDate,
                admitDate + floor(dbms_random.value(0,50)),  -- Set discharge date as 0-50 days after admit date.
                admit_reason,
                ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9, ns10, ns11
            );
        END LOOP;
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;    
	COMMIT;
	update datapot.patients set hasEncounters=0 WHERE id > (select max(pid) from datapot.encounters_distribution);
END;
/

/** Generating a log normal distribution to define NUMBER of allergies per patient.
*/
DECLARE
    allergies NUMBER;
    pNUMBER	NUMBER;
    startN	NUMBER;
    allergies_median	NUMBER;
    allergies_std	NUMBER;
BEGIN
 	-- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.allergies_distribution;
	SELECT val INTO allergies_median FROM datapot.configuration WHERE id = 4;
	SELECT val INTO allergies_std FROM datapot.configuration WHERE id = 5;
	FOR i IN startN..pNUMBER LOOP
	    LOOP
	        SELECT trunc(dbms_random.normal * allergies_std + allergies_median) INTO allergies FROM dual;
	        exit when allergies > 0;
	    END LOOP;
	    INSERT /*+ append */ INTO datapot.allergies_distribution values (
        	i,
        	allergies
    	);
    -- COMMIT every 1000 patients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
	end LOOP;
COMMIT;
END;
/

/** Generate allergies
*/
DECLARE
    allergies_num NUMBER;
    cursor allergies_counts is SELECT allergies_NUMBER FROM datapot.allergies_distribution
    	WHERE pid > (SELECT nvl(max(pid),0) FROM datapot.allergies);
    pNUMBER	NUMBER;
    startN	NUMBER;
    a_type VARCHAR2(10);
    a_type_text VARCHAR2(50);
    a_code VARCHAR2(10);
    a_code_text VARCHAR2(70);
    a_severity VARCHAR2(5);
    a_severity_text VARCHAR2(15);
    a_reaction VARCHAR2(50);
    a_code_count    NUMBER;
    a_type_count    NUMBER;
    a_reaction_count    NUMBER;
    a_severity_count    NUMBER;
begin
    open allergies_counts;
     -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.allergies;
    -- Get NUMBER of allergy codes.
    SELECT count(*) INTO a_code_count FROM datapot.allergy_code;
    -- Get NUMBER of allergy types.
    SELECT count(*) INTO a_type_count FROM datapot.allergy_type;
    -- Get NUMBER of allergy reactions.
    SELECT count(*) INTO a_reaction_count FROM datapot.allergy_reaction;
    -- Get NUMBER of allergy severity options.
    SELECT count(*) INTO a_severity_count FROM datapot.allergy_severity;
    -- FOR each non-duplicate patient...
    FOR i IN startN..pNUMBER LOOP
    	-- ...fetch NUMBER of allergies that patient should have...
        fetch allergies_counts INTO allergies_num;
        -- ...and FOR each allergy...
        FOR j IN 1..allergies_num LOOP
        	-- ...get random allergy type, code, severity and reaction...
            SELECT type, description INTO a_type, a_type_text FROM datapot.allergy_type WHERE id=trunc(dbms_random.value(1,a_type_count + 0.9));
            SELECT code, description INTO a_code, a_code_text FROM datapot.allergy_code WHERE id=trunc(dbms_random.value(1,a_code_count + 0.9));
            SELECT severity, description INTO a_severity, a_severity_text FROM datapot.allergy_severity WHERE id=trunc(dbms_random.value(1,a_severity_count + 0.9));
            SELECT reaction INTO a_reaction FROM datapot.allergy_reaction WHERE id=trunc(dbms_random.value(1,a_reaction_count + 0.9));
            -- ...and generate an allergy using those random values.
            INSERT /*+ append */ INTO datapot.allergies values (
                datapot.allergiesidsec.nextval,
                i,
                a_type,
                a_type_text,
                a_code,
                a_code_text,
                a_severity,
                a_severity_text,
                a_reaction
            );
        END LOOP;
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/

/** Generating a log normal distribution to define NUMBER of procedures per patient.
*/
DECLARE
    procedures NUMBER;
    pNUMBER	NUMBER;
    startN	NUMBER;
    procedures_median	NUMBER;
    procedures_std	NUMBER;
BEGIN
 	-- Get desired NUMBER of patients.
	SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.problems_distribution;
	SELECT val INTO procedures_median FROM datapot.configuration WHERE id = 8;
	SELECT val INTO procedures_std FROM datapot.configuration WHERE id = 9;
	FOR i IN startN..pNUMBER LOOP
	    LOOP
	        SELECT trunc(dbms_random.normal * procedures_std + procedures_median) INTO procedures FROM dual;
	        exit when procedures > 0;
	    END LOOP;
	    INSERT /*+ append */ INTO datapot.procedures_distribution values (
	        i,
	        procedures
	    );
    -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
	end LOOP;
COMMIT;
END;
/

/** Generate procedures
*/
DECLARE
    procedures_num NUMBER;
    cursor procedures_counts is SELECT procedures_NUMBER FROM datapot.procedures_distribution
    	WHERE pid > (SELECT nvl(max(pid),0) FROM datapot.procedures);
    pNUMBER	NUMBER;
    startN	NUMBER;
    p_type VARCHAR2(10);
    p_type_text VARCHAR2(70);
    p_code VARCHAR2(10);
    p_code_text VARCHAR2(130);
    p_code_count    NUMBER;
    p_type_count    NUMBER;
begin
    open procedures_counts;
    -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.procedures;
    -- Get NUMBER of procedure codes.
    SELECT count(*) INTO p_code_count FROM datapot.procedure_code;
    -- Get NUMBER of procedure types.
    SELECT count(*) INTO p_type_count FROM datapot.procedure_type;
    -- FOR each non-duplicate patient...
    FOR i IN startN..pNUMBER LOOP
    	-- ...fetch NUMBER of procedures that patient should have...
        fetch procedures_counts INTO procedures_num;
        -- ...and FOR each procedure...
        FOR j IN 1..procedures_num LOOP
        	-- ...get random procedure type and code...
            SELECT type, description INTO p_type, p_type_text FROM datapot.procedure_type 
            	WHERE id=trunc(dbms_random.value(1,p_type_count + 0.9));
            SELECT code, description INTO p_code, p_code_text FROM datapot.procedure_code 
            	WHERE id=trunc(dbms_random.value(1,p_code_count + 0.9));
            -- ...and generate a procedure using those random values.
            INSERT /*+ append */ INTO datapot.procedures values (
                datapot.proceduresidsec.nextval,
                i,
                p_type,
                p_type_text,
                p_code,
                p_code_text,
                sysdate - floor(dbms_random.value(500,1500))
            );
        END LOOP;
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/

/** Generating a log normal distribution to define NUMBER of problems per patient.
*/
DECLARE
    problems NUMBER;
    pNUMBER	NUMBER;
    startN	NUMBER;
    problems_median	NUMBER;
    problems_std	NUMBER;
BEGIN
 -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.problems_distribution;
	SELECT val INTO problems_median FROM datapot.configuration WHERE id = 6;
	SELECT val INTO problems_std FROM datapot.configuration WHERE id = 7;
	FOR i IN startN..pNUMBER LOOP
    	LOOP
        	SELECT trunc(dbms_random.normal * problems_std + problems_median) INTO problems FROM dual;
        	exit when problems > 0;
    	end LOOP;
    	INSERT /*+ append */ INTO datapot.problems_distribution values (
        	i,
        	problems
    	);
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
	end LOOP;
COMMIT;
END;
/

/** Generate problems
*/
DECLARE
    problems_num NUMBER;
    cursor problems_counts is SELECT problems_NUMBER FROM datapot.problems_distribution
    	WHERE pid > (SELECT nvl(max(pid),0) + 1 FROM datapot.problems);
    pNUMBER	NUMBER;
    startN	NUMBER;
    p_code VARCHAR2(10);
    p_code_text VARCHAR2(180);
    p_code_count    NUMBER;
    d_count	NUMBER;
    did	VARCHAR2(10);
    problem_id	NUMBER;
begin
    open problems_counts;
     -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.problems;
    -- Get NUMBER of problem codes.
    SELECT count(*) INTO p_code_count FROM datapot.problem_code;
    -- Get NUMBER of doctors.
    SELECT val INTO d_count FROM datapot.configuration WHERE id = 13;
    -- FOR each non-duplicate patient...
    FOR i IN startN..pNUMBER LOOP
    	-- ...fetch NUMBER of problems that patient should have...
        fetch problems_counts INTO problems_num;
        -- ...and FOR each problem...
        FOR j IN 1..problems_num LOOP
        	-- ...get a random doctor and a procedure code...
        	SELECT doctor_id INTO did FROM datapot.doctors WHERE id=trunc(dbms_random.value(1,d_count + 0.9));
            SELECT code, description INTO p_code, p_code_text FROM datapot.problem_code 
            	WHERE id=trunc(dbms_random.value(1,p_code_count + 0.9));
            SELECT datapot.problemsidsec.nextval into problem_id from dual;
            -- ...and generate a problem using those random values.
            INSERT /*+ append */ INTO datapot.problems values (
                problem_id,
                i,
                p_code,
                p_code_text,
                sysdate - floor(dbms_random.value(500,1500)),
                CASE mod(problem_id,2) WHEN 1 THEN 'G' ELSE 'D' END,
                'PCP',
                did,
                'OHCP'
            );
        END LOOP;
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/

	
/** Generating a log normal distribution to define NUMBER of lab results per patient.
*/
DECLARE
    labresults NUMBER;
    pNUMBER	NUMBER;
    startN	NUMBER;
    labresults_median	NUMBER;
    labresults_std	NUMBER;
BEGIN
	 -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.labresults_distribution;
	SELECT val INTO labresults_median FROM datapot.configuration WHERE id = 10;
	SELECT val INTO labresults_std FROM datapot.configuration WHERE id = 11;
	FOR i IN startN..pNUMBER LOOP
	    LOOP
	        SELECT trunc(dbms_random.normal * labresults_std + labresults_median) INTO labresults FROM dual;
	        exit when labresults > 0;
	    END LOOP;
	    INSERT INTO datapot.labresults_distribution values (
	        i,
 	       labresults
	    );
    	-- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
	end LOOP;
COMMIT;
END;
/

/* Populating OBR - as per data distribution */
DECLARE
    labresults_num NUMBER;
    cursor labresults_counts is SELECT labresults_NUMBER FROM datapot.labresults_distribution
    	WHERE pid > (SELECT nvl(max(pid), 0) FROM datapot.labresults_OBR);
    pNUMBER	NUMBER;
    startN	NUMBER;
    status	VARCHAR2(15);
    status_count	NUMBER;
    service	VARCHAR2(5);
    service_count	NUMBER;
    did VARCHAR2(10);
    dfname	VARCHAR2(20);
    dlname  VARCHAR2(20);
    count_n	NUMBER;
    uservice_code	VARCHAR2(15);
    uservice_text	VARCHAR2(2000);
    uservice_count	NUMBER;
    obr_count	NUMBER;
    parentplacer	VARCHAR2(15);
    parentfiller	VARCHAR2(15);
    doctor_n NUMBER;
    obr_date	timestamp;
begin
    open labresults_counts;
     -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.labresults_OBR;
    -- Get the NUMBER of result statuses and diagnostic services to use with a randomizer later
    SELECT count(*) INTO status_count FROM datapot.resultStatuses;
    SELECT count(*) INTO service_count FROM datapot.diagnosticServices;
    SELECT count(*) INTO uservice_count FROM datapot.uservice;
    -- Get desired NUMBER of doctors
    SELECT val INTO doctor_n FROM datapot.configuration WHERE id = 13;

    -- FOR each patient...
    FOR i IN startN..pNUMBER LOOP
    	-- ...fetch the NUMBER of lab results this patient should have...
        fetch labresults_counts INTO labresults_num;
        -- ...and FOR each of lab results...
        FOR j IN 1..labresults_num LOOP
        	-- ...generate a random NUMBER of observations...
        	count_n := floor(dbms_random.value(1,11));
        	-- ...get random result status, diagnostic service and doctor...
        	SELECT status INTO status FROM datapot.resultStatuses 
        		WHERE id=trunc(dbms_random.value(1,status_count + 0.9));
        	SELECT code, description INTO uservice_code, uservice_text FROM datapot.uservice 
        		WHERE id=trunc(dbms_random.value(1,uservice_count + 0.9));
           	SELECT service INTO service FROM datapot.diagnosticServices 
           		WHERE id=trunc(dbms_random.value(1,service_count + 0.9));
            SELECT doctor_id,fname,lname INTO did, dfname, dlname FROM datapot.doctors 
            	WHERE id=trunc(dbms_random.value(1,doctor_n));
            SELECT sysdate - floor(dbms_random.value(500,1500)) into obr_date from dual;
            -- ...and generate a lab result record...
            INSERT /*+ append */ INTO datapot.labresults_OBR values (
                datapot.labresultsidsec.nextval,
                i,
                dbms_random.string('U',10),
                dbms_random.string('U',10),
                uservice_code,
                uservice_text,
                obr_date,
                obr_date + 2,	-- Set requested time as time of observations + 2. This is to pass validation IN CDR later.
                obr_date + 5,   -- Set received time as time of observations + 5. This is to pass validation IN CDR later.
                did,
                dfname,
                dlname,
                status,
                service,
                count_n,
                '',
                ''
            );
        END LOOP;
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    SELECT count(*) INTO obr_count FROM dual;
    SELECT val INTO count_n FROM datapot.configuration WHERE id=19;
    count_n := floor(obr_count * count_n / 100);
    FOR j IN 1..count_n LOOP
    	SELECT place_Order, filler_order INTO parentplacer, parentfiller FROM datapot.labresults_OBR 
    			WHERE id = trunc(dbms_random.value(1, obr_count));
  		update datapot.labresults_OBR set 
  			parentplacerorder=parentplacer,
  			parentfillerorder = parentfiller WHERE id=j;
  	end LOOP;
  	COMMIT;
END;
/

/*
 * Populating OBX table
 * Note that IF you want this to be cumulative, you will need to uncomment out the
 * alternative line FOR setting startOBR_n and comment out the default one.
*/
DECLARE
	OBR_n	NUMBER;
	startOBR_n	NUMBER;
	service VARCHAR2(3);
	low	NUMBER;
	high	NUMBER;
	val	NUMBER;
	flag	VARCHAR2(2);
	unit	VARCHAR2(15);
	unit_count	NUMBER;
	count_n	NUMBER;
	resultType	VARCHAR2(3);
	resultStatus	VARCHAR2(2);
	resultStatus_count  NUMBER;
	obr_id_code	VARCHAR2(200);
	obr_id_text	VARCHAR2(2000);
	obr_id_count	NUMBER;
	obr_id_rad_count	NUMBER;
	freeText	VARCHAR2(2000);
	freeText_rad_count	NUMBER;
	freeText_txt_count	NUMBER;
	isimg	NUMBER;
	img_id	NUMBER;
	img_count	NUMBER;
	image_hex	clob;
BEGIN
	-- Get the NUMBER of lab results/OBR segments.
	SELECT count(*) INTO OBR_n FROM datapot.labresults_OBR;
	-- Get the current NUMBER of OBR segments
	-- SELECT nvl(max(obrid),0) + 1 INTO startOBR_n FROM datapot.labresults_OBX;
  SELECT 1 INTO startOBR_n FROM dual;
	-- Get the NUMBERs of various reference data items to use with a randomizer later.
	SELECT count(*) INTO resultStatus_count FROM datapot.resultStatuses;
	SELECT count(*) INTO obr_id_count FROM datapot.obr_identifiers;
	SELECT count(*) INTO obr_id_rad_count FROM datapot.obr_identifiers_RAD;
	SELECT count(*) INTO unit_count FROM datapot.units;
	SELECT count(*) INTO freeText_txt_count FROM datapot.textualLabResults;
	SELECT count(*) INTO freeText_rad_count FROM datapot.RadLabResults;
	SELECT count(*) - 1 INTO img_count FROM datapot.rad_attachments;
	-- FOR each lab result...
	FOR i IN startOBR_n..OBR_n LOOP
		-- Grab inFORmation about that lab result - it defines which observation info needs to be generated...
		SELECT DiagnosticServSectID, count_n INTO resultType, count_n FROM datapot.labresults_OBR WHERE id = i;
		-- ...FOR each observation...
		FOR j IN 1..count_n LOOP
			/** ...depending on the lab result type, generate a set of fields needed FOR that lab result,
				retrieve whatever random reference data necessary and populate an OBX record accordingly.
			*/
			IF resultType IN ('HM', 'MB') THEN
				low := floor(dbms_random.value(1,25));
				high := floor(dbms_random.value(1,100)) + low + 10;
				val := floor(dbms_random.value(1,135));
				IF val < low THEN
					flag := 'L';
				elsIF val > high THEN
					flag := 'H';
				ELSE
					flag := 'N';
				end IF;
				SELECT status INTO resultStatus FROM datapot.resultStatuses 
					WHERE id = trunc(dbms_random.value(1,resultStatus_count + 0.9));
				SELECT code, description INTO obr_id_code, obr_id_text FROM datapot.obr_identifiers 
					WHERE id = trunc(dbms_random.value(1,obr_id_count + 0.9));
				SELECT unit INTO unit FROM datapot.units 
					WHERE id = trunc(dbms_random.value(1,unit_count + 0.9));
				INSERT /*+ append */ INTO datapot.labresults_OBX values (
					datapot.labresultsobxidsec.nextval,
					i,
					to_char(low) || '-' || to_char(high),
					val,
					flag,
					unit,
					'ST',
					resultStatus,
					null,
					null,
					obr_id_code,
					obr_id_text,
					0,
					null
				);
			elsIF resultType = 'CT' THEN
				SELECT text INTO freeText FROM datapot.textualLabResults WHERE
					id = trunc(dbms_random.value(1,freeText_txt_count + 0.9));
				SELECT code, description INTO obr_id_code, obr_id_text FROM datapot.obr_identifiers 
					WHERE id = trunc(dbms_random.value(1,obr_id_count + 0.9));
				SELECT status INTO resultStatus FROM datapot.resultStatuses 
					WHERE id = trunc(dbms_random.value(1,resultStatus_count + 0.9));
				INSERT /*+ append */ INTO datapot.labresults_OBX values (
					datapot.labresultsobxidsec.nextval,
					i,
					null,
					null,
					null,
					null,
					'ST',
					resultStatus,
					freeText,
					null,
					obr_id_code,
					obr_id_text,
					0,
					null
				);
			elsIF resultType = 'RAD' THEN
				SELECT code, description INTO obr_id_code, obr_id_text FROM datapot.obr_identifiers_RAD 
						WHERE id = trunc(dbms_random.value(1,obr_id_rad_count + 0.9));
				SELECT status INTO resultStatus FROM datapot.resultStatuses 
						WHERE id = trunc(dbms_random.value(1,resultStatus_count + 0.9));
				isimg := trunc(dbms_random.value(1,10));
				IF isimg > 1 THEN
					SELECT text INTO freeText FROM datapot.RadLabResults WHERE
						id = trunc(dbms_random.value(1,freeText_rad_count + 0.9));
					INSERT /*+ append */ INTO datapot.labresults_OBX values (
					datapot.labresultsobxidsec.nextval,
					i,
					null,
					null,
					null,
					null,
					'FT',
					resultStatus,
					freeText,
					null,
					obr_id_code,
					obr_id_text,
					0,
					null
					);
				ELSE
					SELECT trunc(dbms_random.value(1,img_count + 0.9)) INTO img_id FROM dual;
					SELECT image_hex INTO image_hex FROM datapot.rad_attachments WHERE id=img_id;
					INSERT /*+ append */ INTO datapot.labresults_OBX values (
					datapot.labresultsobxidsec.nextval,
					i,
					null,
					null,
					null,
					null,
					'ED',
					resultStatus,
					'RAD Attachment',
					null,
					obr_id_code,
					obr_id_text,
					img_id,
					image_hex
					);
			end IF; 
    END IF;
		end LOOP;
		-- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;     
	end LOOP;
	COMMIT;
END;
/

/** Generating a log normal distribution to define NUMBER of diagnosis per encounter.
*/
DECLARE
    diagnosis NUMBER;
    encNUMBER	NUMBER;
    encStartN	NUMBER;
    diagnosis_median	NUMBER;
    diagnosis_std	NUMBER;
BEGIN
SELECT count(*) INTO encNUMBER FROM datapot.encounters;
SELECT nvl(max(encid),0) + 1 INTO encStartN FROM datapot.diagnosis_distribution;
SELECT val INTO diagnosis_median FROM datapot.configuration WHERE id = 14;
SELECT val INTO diagnosis_std FROM datapot.configuration WHERE id = 15;
FOR i IN encStartN..encNUMBER LOOP
    LOOP
        SELECT trunc(dbms_random.normal * diagnosis_median + diagnosis_median) INTO diagnosis FROM dual;
        exit when diagnosis > 0;
    END LOOP;
    INSERT /*+ append */ INTO datapot.diagnosis_distribution values (
        i,
        diagnosis
    );
    -- COMMIT every 1000 encounters to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
end LOOP;
COMMIT;
END;
/

/** Generate diagnosis
*/
DECLARE
    diagnosis_num NUMBER;
    cursor diagnosis_counts is SELECT diagnosis_NUMBER FROM datapot.diagnosis_distribution
    	WHERE encid > (SELECT nvl(max(encid),0) FROM datapot.diagnoses);
    encNUMBER	NUMBER;
    encStartN	NUMBER;
    dg_type VARCHAR2(1);
    dg_code VARCHAR2(10);
    dg_code_text VARCHAR2(1000);
    dg_code_count    NUMBER;
    dg_type_count    NUMBER;
    dg_sensitivity	VARCHAR2(1);
    enc_time	timestamp;
    dg_sensitive_k	NUMBER;		-- Each dg_sensitive_k encounter will have sensitive diagnoses
    dg_id			NUMBER;
begin
    open diagnosis_counts;
    -- Get NUMBER of encounters.
    SELECT count(*) INTO encNUMBER FROM datapot.encounters;
    SELECT nvl(max(encid),0) + 1 INTO encStartN FROM datapot.diagnoses;
    -- Get NUMBER of diagnosis codes.
    SELECT count(*) INTO dg_code_count FROM datapot.diagnosis_code;
    -- Get NUMBER of diagnosis types.
    SELECT count(*) INTO dg_type_count FROM datapot.diagnosis_type;
    -- Calculate dg_sensitive_k
    SELECT round(100/(SELECT val FROM datapot.configuration WHERE id=16)) into dg_sensitive_k from dual;
    -- FOR each encounter...
    FOR i IN encStartN..encNUMBER LOOP
    	-- ...fetch NUMBER of diagnosis FOR that encounter...
        fetch diagnosis_counts INTO diagnosis_num;
        -- ...and FOR each diagnosis...
        FOR j IN 1..diagnosis_num LOOP
        	-- ...get random diagnosis type and code...
            SELECT code INTO dg_type FROM datapot.diagnosis_type WHERE id=trunc(dbms_random.value(1,dg_type_count + 0.9));
            SELECT code, description INTO dg_code, dg_code_text FROM datapot.diagnosis_code WHERE id=trunc(dbms_random.value(1,dg_code_count + 0.9));
            -- ...get encounter time...
            SELECT admit_date INTO enc_time FROM datapot.encounters WHERE id=i;
            -- ...and generate a diagnosis using those random values.
            INSERT /*+ append */ INTO datapot.diagnoses values (
                datapot.diagnosisidsec.nextval,
                i,
                dg_code,
                dg_code_text,
                dg_type,
                enc_time,
                CASE mod(i, dg_sensitive_k) WHEN 0 THEN 'Y' ELSE 'N' END
            );
        END LOOP;
        -- COMMIT every 1000 encounters to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/

/** Generating a log normal distribution to define NUMBER of medications per patient.
*/
DECLARE
    medications NUMBER;
    pNUMBER	NUMBER;
    startN	NUMBER;
    medications_median	NUMBER;
    medications_std	NUMBER;
BEGIN
	 -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.medications_distribution;
	SELECT val INTO medications_median FROM datapot.configuration WHERE id = 17;
	SELECT val INTO medications_std FROM datapot.configuration WHERE id = 18;
	FOR i IN startN..pNUMBER LOOP
    	LOOP
    	    SELECT trunc(dbms_random.normal * medications_std + medications_median) INTO medications FROM dual;
   	     exit when medications > 0;
  	  	end LOOP;
  	  	INSERT /*+ append */ INTO datapot.medications_distribution values (
        	i,
        	medications
    	);
    	-- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
	end LOOP;
COMMIT;
END;
/

/** Generate medications
*/
DECLARE
    medications_num NUMBER;
    cursor medications_counts is SELECT medications_NUMBER FROM datapot.medications_distribution
    	WHERE pid > (SELECT nvl(max(pid),0) FROM datapot.medications);
    pNUMBER	NUMBER;
    startN	NUMBER;
    route_code VARCHAR2(256);
    route_text VARCHAR2(256);
    route_count    NUMBER;
    medication_code VARCHAR2(256);
    medication_text VARCHAR2(256);
    medication_count    NUMBER;
    unit_text	VARCHAR2(256);
    unit_count	NUMBER;
    dosage	VARCHAR2(256);
    d_count	NUMBER;
    did	VARCHAR2(10);
    orderStartDate	timestamp;
begin
    open medications_counts;
     -- Get desired NUMBER of patients.
    SELECT count(*) INTO pNUMBER FROM datapot.patients;
	-- Get existing NUMBER of patients
	SELECT nvl(max(pid),0) + 1 INTO startN FROM datapot.medications;
    -- Get NUMBER of medication names.
    SELECT count(*) INTO medication_count FROM datapot.medication_names;
    -- Get NUMBER of medication units.
    SELECT count(*) INTO unit_count FROM datapot.unit_combined;
    -- Get NUMBER of medication routes.
    SELECT count(*) INTO route_count FROM datapot.medication_route;
    -- Get NUMBER of doctors.
    SELECT val INTO d_count FROM datapot.configuration WHERE id = 13;
    -- FOR each non-duplicate patient...
    FOR i IN startN..pNUMBER LOOP
    	-- ...fetch NUMBER of medications that patient should have...
        fetch medications_counts INTO medications_num;
        -- ...and FOR each medication...
        FOR j IN 1..medications_num LOOP
        	-- ...get a random doctor and a procedure code...
        	SELECT doctor_id INTO did FROM datapot.doctors WHERE id=trunc(dbms_random.value(1,d_count + 0.9));
            SELECT code, description INTO route_code, route_text FROM datapot.medication_route 
            	WHERE id=trunc(dbms_random.value(1,route_count + 0.9));
            SELECT unit INTO unit_text FROM datapot.unit_combined WHERE id=trunc(dbms_random.value(1,unit_count + 0.9));
            SELECT code, name, dosage INTO medication_code, medication_text, dosage FROM datapot.medication_names
            	WHERE id=trunc(dbms_random.value(1,medication_count + 0.9));
            SELECT sysdate - floor(dbms_random.value(500,1500)) into orderStartDate from dual;
            -- ...and generate a medication using those random values.
            INSERT /*+ append */ INTO datapot.medications values (
                datapot.medicationsidsec.nextval,
                i,
                dbms_random.string('U',10),
                'completed',
                orderStartDate,
                orderStartDate + floor(dbms_random.value(0,5)),
                'datapotImport',
                did,
                medication_code,
                medication_text,
                unit_text,
                dosage,
                route_code,
                route_text
            );
        END LOOP;
        -- COMMIT every 1000 parients to keep redo logs small
        IF mod(i, 1000) = 0 THEN
        	COMMIT;
        END IF;
    END LOOP;
    COMMIT;
END;
/


/** The code below is an example on how to switch FROM a uniFORm distribution FROM some field values
	to a custom distribution. It is assumed you have already created the distribution table
	and populated it as shown IN the END of create_dataprofile.sql.
	The example modifies allergy population script FROM above to use allergy severity as per custom distribution.
	

DECLARE
    allergies_num NUMBER;
    cursor allergies_counts is SELECT allergies_NUMBER FROM datapot.allergies_distribution;
    pNUMBER	NUMBER;
    a_type VARCHAR2(10);
    a_type_text VARCHAR2(50);
    a_code VARCHAR2(10);
    a_code_text VARCHAR2(70);
    a_severity VARCHAR2(5);
    a_severity_text VARCHAR2(15);
    a_reaction VARCHAR2(50);
    a_code_count    NUMBER;
    a_type_count    NUMBER;
    a_reaction_count    NUMBER;
    a_severity_count    NUMBER;
    a_id	NUMBER;  -- This line was added
    a_low	NUMBER;  -- This line was added
    a_high	NUMBER;  -- This line was added
begin
    
    open allergies_counts;
    -- Get NUMBER of patients.
    SELECT val INTO pNUMBER FROM datapot.configuration WHERE id = 1;
    -- Get NUMBER of allergy codes.
    SELECT count(*) INTO a_code_count FROM datapot.allergy_code;
    -- Get NUMBER of allergy types.
    SELECT count(*) INTO a_type_count FROM datapot.allergy_type;
    -- Get NUMBER of allergy reactions.
    SELECT count(*) INTO a_reaction_count FROM datapot.allergy_reaction;
    -- Get NUMBER of allergy severity options.
    -- SELECT count(*) INTO a_severity_count FROM datapot.allergy_severity; --don't need this
    alter table allergy_severity_distribution add (range_low NUMBER, range_high NUMBER);
    update allergy_severity_distribution set range_low = 0 WHERE id = 1;
    FOR i IN 2..a_severity_count LOOP
    	SELECT percentage + range_low INTO a_low FROM allergy_severity_distribution WHERE id = i-1;
    	update allergy_severity_distribution
    		set range_low = a_low WHERE id = i;
		SELECT percentage + low INTO a_high FROM allergy_severity_distribution WHERE id = i;
		update allergy_severity_distribution
			set range_high = a_high WHERE id = i;
	end LOOP;		
    
    -- FOR each non-duplicate patient...
    FOR i IN 1..pNUMBER LOOP
    	-- ...fetch NUMBER of allergies that patient should have...
        fetch allergies_counts INTO allergies_num;
        -- ...and FOR each allergy...
        FOR j IN 1..allergies_num LOOP
        	-- ...get random allergy type, code, severity and reaction...
            SELECT type, description INTO a_type, a_type_text FROM datapot.allergy_type WHERE id=trunc(dbms_random.value(1,a_type_count + 0.9));
            SELECT code, description INTO a_code, a_code_text FROM datapot.allergy_code WHERE id=trunc(dbms_random.value(1,a_code_count + 0.9));
            
            -- Choose random allergy severity as per distribution
            SELECT id INTO a_id FROM allergy_severity_distribution 
            	WHERE trunc(dbms_random.value(1,101)) is between range_low and range_high;
            SELECT severity, description INTO a_severity, a_severity_text FROM datapot.allergy_severity WHERE id=a_id;
            
            SELECT reaction INTO a_reaction FROM datapot.allergy_reaction WHERE id=trunc(dbms_random.value(1,a_reaction_count + 0.9));
            -- ...and generate an allergy using those random values.
            INSERT INTO datapot.allergies values (
                datapot.allergiesidsec.nextval,
                i,
                a_type,
                a_type_text,
                a_code,
                a_code_text,
                a_severity,
                a_severity_text,
                a_reaction
            );
        END LOOP;
    END LOOP;
    COMMIT;
END;
/
*/
