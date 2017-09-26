/** Modify second values in the insert statements to configure data distributions.
	I.e. to create 400 patients, change "(1, 100, 'Number of patients')" to "(1, 400, 'Number of patients')".
	Do not change values in the first column, the script depends on them!
*/
insert into datapot.configuration values (1, 100, 'Number of patients');
insert into datapot.configuration values (2, 2, 'Median number of encounters per patient');
insert into datapot.configuration values (3, 2.5, 'Standard deviation for the number of encounters per patient');
insert into datapot.configuration values (4, 2, 'Median number of allergies per patient');
insert into datapot.configuration values (5, 2.5, 'Standard deviation for the number of allergies per patient');
insert into datapot.configuration values (6, 2, 'Median number of problems per patient');
insert into datapot.configuration values (7, 2.5, 'Standard deviation for the number of problems per patient');
insert into datapot.configuration values (8, 2, 'Median number of procedures per patient');
insert into datapot.configuration values (9, 2.5, 'Standard deviation for the number of procedures per patient');
insert into datapot.configuration values (10, 2, 'Median number of lab results per patient');
insert into datapot.configuration values (11, 2.5, 'Standard deviation for the number of lab results per patient');
insert into datapot.configuration values (12, 20, 'Number of patients who exist in multiple namespaces');
insert into datapot.configuration values (13, 5000, 'Number of doctors');
insert into datapot.configuration values (14, 1, 'Median number of diagnoses per encounter');
insert into datapot.configuration values (15, 1, 'Standard deviation for the number of diagnoses per encounter');
insert into datapot.configuration values (16, 10, 'Percentage of sensitive diagnoses');
insert into datapot.configuration values (17, 3, 'Median number of medications per patient');
insert into datapot.configuration values (18, 1, 'Standard deviation for the number of medications per patient');
insert into datapot.configuration values (19, 10, 'Percentage of laboratory results that are linked to a parental lab result');