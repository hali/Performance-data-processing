Run this script by pointing "generate-report.R" to a .har file and by running "Rscript generate-report.R" command.
It will analyze .har file to search for:
* Uncached static resources
* Resources that are cached after being requested from the server few times (instead of after the first time)
* Pages with a lot of requests on them
* Uncompressed static resources
