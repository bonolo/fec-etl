Introduction
=============

The United States Federal Election Commission (FEC) releases data on contributions to federal election campaigns and committees (including political action committees, party committees and campaign committees). I noticed the bulk downloads were not user-friendly for those who want to quickly pop it into a database...
- confusing filenames
- pipe-delimited data
- comma-delimited headers (in separate files)
- no quoting or escapes
- inconsistent date strings
- orphan child records
- fields with opaque codes & no lookup tables

I used free software to extract, transform and load (ETL) the bulk FEC data into a database. This repository contains transformations, SQL to create tables and keys, CSV files for lookup tables and sample SQL queries.

I could more easily have written some command-line scripts, but I thought this would be a good learning experience and would allow non-programmers to import the bulk data on their own.

This repo is a respectful gift to anyone who might want to quickly pop FEC data into a database and do their own queries. I'd like to use SSIS to pull it into SQL Server soon, but that may be a separate repo/project.
 
Contributions/improvements welcome.


Basic requirements
------------------

You will need...
- Pentaho Data Integration (Community Edition is fine)
- MySQL (or another relational database)
- Java Virtual Machine (to run Pentaho Data Integration)
- Files from FEC

Files in this repo
------------------

- Pentaho Data Integration (Kettle) Jobs and transformations
	- .KTR & .KJB
- Lookup table CSV files (not provided by FEC)
	- /txt-import/lookup/incumbent.csv
	- /txt-import/lookup/party.csv


Setup
=====

Directory structure
-------------------

The .KTR files (Pentaho transformations) use a relative file path to find the text imports, so leave them in the root directory.

sql/ - SQL to create and modify tables.

txt-import/ - place unzipped files from the FEC here.

txt-import/lookup/ - contains CSV files to enhance FEC data


Pentaho Data Integration
------------------------

Pentaho Data Integration (PDI) is an ETL tool from Hitachi Vantara. It's available in a free Community Edition and a commercial Enterprise Edition and runs on multiple operating systems, including Windows, Mac, Linux. You can download PDI from...

- Sourceforge (Community Edition): <https://sourceforge.net/projects/pentaho/>
- Hitachi (Enterprise Edition): <https://www.hitachivantara.com>


Java
----

You'll need the Java Virtual Machine to run Pentaho. There is a version included in the Pentaho installer, or you can use your own.


MySQL (or other database)
-------------------------

I created the Pentaho transformations using MySQL 8.0 on MacOS. Any of these transformations can be configured to use different databases.

MySQL installation instructions are beyond the scope of this document. Once you have MySQL (or your database of choice) up and running, do the following...

- Create a database schema named: campaign_finance
- Create the user: fec_data
- Set fec_data's password to 'watchThem$L1ke@Hawk' (or edit the MySQL shared connection in pentaho-kettle-ETL-job.kjb to use any password you want).
- Give user fec_data appropriate permissions in the schema.
	- SELECT
	- INSERT
	- UPDATE
	- DELETE
	- LOCK TABLES
	- SHOW VIEW
	- DROP
- Some of the SQL scripts need further DDL privileges. Give these to fec_data or use root.
	- CREATE
	- ALTER
	- REFERENCES
	- INDEX
- Use the file /sql/ddl-create.sql to create your tables files to create tables


FEC files
---------

All files are available for downloaded from the FEC: <https://www.fec.gov/data/browse-data/?tab=bulk-data>. There are many years available as zip files grouped by 2-year federal election cycle.

Download and extract the files for the time period of interest. Place the extracted .TXT files in txt-import/

When I have time, I'd like to add unzipping to the Pentaho job.


Files and Entities - Details
============================

From the FEC
------------

After unzipping, there are 10 FEC files, each of which maps to a database table.

To run the transformations, place unzipped files in the txt-import/ directory.

File [Table]
* ccl.txt [candidate_committee]
* cm.txt [committee_master]
* weblYY.txt [fed_current_campaign_summary]
* cn.txt [candidate_master]
* itcont.txt [contrib_indiv_2_cmte]
* itoth.txt [trans_among_cmte]
* itpas2.txt [contrib_cmte_2_cand]
* oppexp.txt [operating_expenditure]
* weballYY.txt [candidate_all	]
* webkYY.txt [pac_party_summary]


Project Files
-------------

These CSV files contain the lookup tables.

* txt-import/lookup/party.csv [party]
* txt-import/lookup/incumbent.csv [ici_status]


To Do
=====

- Load MySQL user credentials from config file.
- Add unzipping to the PDI job.


Descriptions of zip file downloads from Federal Elections Commission
====================================================================

Descriptions here are directly from the FEC. The US federal government can't copyright anything, so I reproduced them here.

web-allYY.zip
-------------
* table:	candidate_all
* <https://www.fec.gov/campaign-finance-data/all-candidates-file-description/>
* The all candidate summary file contains one record including summary financial information for all candidates who raised or spent money during the period no matter when they are up for election. 


cnYY.zip
------
* table: candidate_master
* <https://www.fec.gov/campaign-finance-data/candidate-master-file-description/>
* The candidate master file contains one record for each candidate who has either registered with the Federal Election Commission or appeared on a ballot list prepared by a state elections office.


cclYY.zip
---------
* table: candidate_committee
* <https://www.fec.gov/data/browse-data/?tab=bulk-data>
* This file contains one record for each candidate to committee linkage.


weblYY.zip
----------
* table: fed_current_campaign_summary
* <https://www.fec.gov/campaign-finance-data/current-campaigns-house-and-senate-file-description/>
* These files contain one record for each campaign. This record contains summary financial information.


cmYY.zip
--------
* table: committee_master
* <https://www.fec.gov/campaign-finance-data/committee-master-file-description/>
* The committee master file contains one record for each committee registered with the Federal Election Commission. This includes federal political action committees and party committees, campaign committees for presidential, house and senate candidates, as well as groups or organizations who are spending money for or against candidates for federal office.


webkYY.zip
----------
* table: pac_party_summary
* <https://www.fec.gov/campaign-finance-data/pac-and-party-summary-file-description/>
* This file gives overall receipts and disbursements for each PAC and party committee registered with the commission, along with a breakdown of overall receipts by source and totals for contributions to other committees, independent expenditures made and other information.


indivYY.zip
-----------
* table: contrib_indiv_2_cmte
* <https://www.fec.gov/campaign-finance-data/contributions-individuals-file-description/>
* The individual contributions file contains each contribution from an individual to a federal committee. It includes the ID number of the committee receiving the contribution, the name, city, state, zip code, and place of business of the contributor along with the date and amount of the contribution.


pas2YY.zip
----------
* table: contrib_cmte_2_cand
* <https://www.fec.gov/campaign-finance-data/contributions-committees-candidates-file-description/>
* The itemized committee contributions file contains each contribution or independent expenditure made by a PAC, party committee, candidate committee, or other federal committee to a candidate during the two-year election cycle.


othYY.zip
---------
* table: trans_among_cmte
* <https://www.fec.gov/campaign-finance-data/any-transaction-one-committee-another-file-description/>
* The itemized records (miscellaneous transactions) file contains all transactions (contributions, transfers, etc. among federal committees). It contains all data in the itemized committee contributions file plus PAC contributions to party committees, party transfers from state committee to state committee, and party transfers from national committee to state committee. This file only includes federal transfers not soft money transactions.

oppexpYY.zip
----------
* table: operating_expenditure
* <https://www.fec.gov/campaign-finance-data/operating-expenditures-file-description/>
* This file contains disbursements reported on FEC Form 3 Line 17, FEC Form 3P Line 23and FEC Form 3X Lines 21(a)(i), 21(a)(ii) and 21(b).
