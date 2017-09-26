# Pritcel Report

This repository contains scripts that will analyse a bunch of logs taken during the performance test run and produce a summary report. The idea is that instead of manually looking through multiple sources in order to identify whether there was a performance issue, and if yes, where - you can run the scripts and then read through one report that would highlight identified problematic areas for you, and then proceed with the investigation if necessary.

This is not meant to be a replacement of a performance analysis, but merely an automation of the routine information gathering stage of it.

The logs that are currently analysed:
- OHP logs - strictly to check whether there were any ERRORs. ERRORs in OHP log might mean that the solution is not properly configured, or that there are errors in the load generation scripts.
- GC logs - to identify all GC pauses bigger than 0.5 seconds. It is a very crude metric, and if a problem is identified, a proper analysis is required.
- Event logs from OHP - to identify slowest events.
- Snapshot logs from OHP - to identify DB pool connection issues.
- JMeter logs - to identify slow pages, low concurrency problems and response times distribution during the test. Ideally you want all response times to meet SLAs, average concurrency for all requests to be above 1, and response times to be distributed more or less evenly throughout the test. Concurrency = 1 means that at no time two users are accessing the same server resource. Spikes in response times might mean that there are long stop-the-world pauses happening in JVM, or that test load is not distributed evenly, or that there is an external factor slowing down the system at the time of a spike.
- AWR report - to identify slow running queries.

Run the script as Rscript generate_report.R after you've placed all the logs nearby, e.g. in the "in" folder, and modified the Pritcel.properties as needed.
Set any given log to "none" if the file is not available - and it will not be processed.

For those outside of Orion Health: feel free to use the script as an example of how R can be used for automated logs analysis.
