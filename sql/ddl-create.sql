
/*
DROP TABLE candidate_all;
DROP TABLE candidate_committee;
DROP TABLE contrib_cmte_2_cand;
DROP TABLE contrib_indiv_2_cmte;
DROP TABLE fed_current_campaign_summary;
DROP TABLE trans_among_cmte;
DROP TABLE operating_expenditure;
DROP TABLE pac_party_summary;
DROP TABLE candidate_master;
DROP TABLE committee_master;
DROP TABLE ici_status;
DROP TABLE party;
*/


-- DROP TABLE campaign_finance.candidate_all;
CREATE TABLE campaign_finance.candidate_all (
  `CAND_ID` varchar(9) NOT NULL,
  `CAND_NAME` varchar(200) DEFAULT NULL,
  `CAND_ICI` char(1) DEFAULT NULL COMMENT 'Incumbent challenger status',
  `PTY_CD` char(1) DEFAULT NULL COMMENT 'Party code',
  `CAND_PTY_AFFILIATION` varchar(3) DEFAULT NULL COMMENT 'Party affiliation',
  `TTL_RECEIPTS` double DEFAULT NULL,
  `TRANS_FROM_AUTH` double DEFAULT NULL COMMENT 'Transfers from authorized committees',
  `TTL_DISB` double DEFAULT NULL COMMENT 'Total disbursements',
  `TRANS_TO_AUTH` double DEFAULT NULL COMMENT 'Transfers to authorized committees',
  `COH_BOP` double DEFAULT NULL COMMENT 'Beginning cash',
  `COH_COP` double DEFAULT NULL COMMENT ' Ending cash',
  `CAND_CONTRIB` double DEFAULT NULL COMMENT 'Contributions from candidate',
  `CAND_LOANS` double DEFAULT NULL COMMENT 'Loans from candidate',
  `OTHER_LOANS` double DEFAULT NULL COMMENT 'Other loans',
  `CAND_LOAN_REPAY` double DEFAULT NULL,
  `OTHER_LOAN_REPAY` double DEFAULT NULL,
  `DEBTS_OWED_BY` double DEFAULT NULL,
  `TTL_INDIV_CONTRIB` double DEFAULT NULL,
  `CAND_OFFICE_ST` varchar(2) DEFAULT NULL,
  `CAND_OFFICE_DISTRICT` varchar(2) DEFAULT NULL,
  `SPEC_ELECTION` char(1) DEFAULT NULL,
  `PRIM_ELECTION` char(1) DEFAULT NULL,
  `RUN_ELECTION` char(1) DEFAULT NULL,
  `GEN_ELECTION` char(1) DEFAULT NULL,
  `GEN_ELECTION_PRECENT` double DEFAULT NULL,
  `OTHER_POL_CMTE_CONTRIB` double DEFAULT NULL COMMENT 'Contributions from other political committees',
  `POL_PTY_CONTRIB` double DEFAULT NULL COMMENT 'Contributions from party committees',
  `CVG_END_DT` datetime DEFAULT NULL,
  `INDIV_REFUNDS` double DEFAULT NULL,
  `CMTE_REFUNDS` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

-- DROP TABLE campaign_finance.candidate_master;
CREATE TABLE campaign_finance.candidate_master (
  `CAND_ID` varchar(9) NOT NULL COMMENT 'A 9-character alpha-numeric code assigned to a candidate by the Federal Election Commission. The candidate ID for a specific candidate remains the same across election cycles as long as the candidate is running for the same office.',
  `CAND_NAME` varchar(200) DEFAULT NULL,
  `CAND_PTY_AFFILIATION` varchar(3) DEFAULT NULL,
  `CAND_ELECTION_YR` bigint(20) DEFAULT NULL COMMENT 'Candidate''s election year from a Statement of Candidacy or state ballot list',
  `CAND_OFFICE_ST` varchar(2) DEFAULT NULL,
  `CAND_OFFICE` char(1) DEFAULT NULL COMMENT 'H = House\nP = President\nS = Senate ',
  `CAND_OFFICE_DISTRICT` varchar(2) DEFAULT NULL COMMENT 'Congressional district number\nCongressional at-large 00\nSenate 00\nPresidential 00 ',
  `CAND_ICI` char(1) DEFAULT NULL COMMENT 'C = Challenger\nI = Incumbent\nO = Open Seat is used to indicate an open seat; Open seats are defined as seats where the incumbent never sought re-election. ',
  `CAND_STATUS` char(1) DEFAULT NULL COMMENT 'C = Statutory candidate\nF = Statutory candidate for future election\nN = Not yet a statutory candidate\nP = Statutory candidate in prior cycle',
  `CAND_PCC` varchar(9) DEFAULT NULL COMMENT 'The ID assigned by the Federal Election Commission to the candidate''s principal campaign committee for a given election cycle. ',
  `CAND_ST1` varchar(34) DEFAULT NULL,
  `CAND_ST2` varchar(34) DEFAULT NULL,
  `CAND_CITY` varchar(30) DEFAULT NULL,
  `CAND_ST` varchar(2) DEFAULT NULL,
  `CAND_ZIP` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

-- DROP TABLE campaign_finance.fed_current_campaign_summary;
CREATE TABLE campaign_finance.fed_current_campaign_summary
(
  `CAND_ID` varchar(9) NOT NULL,
  `CAND_NAME` varchar(200) DEFAULT NULL,
  `CAND_ICI` char(1) DEFAULT NULL COMMENT 'Incumbent challenger status',
  `PTY_CD` char(1) DEFAULT NULL COMMENT 'Party code',
  `CAND_PTY_AFFILIATION` varchar(3) DEFAULT NULL COMMENT 'Party affiliation',
  `TTL_RECEIPTS` double DEFAULT NULL,
  `TRANS_FROM_AUTH` double DEFAULT NULL COMMENT 'Transfers from authorized committees',
  `TTL_DISB` double DEFAULT NULL COMMENT 'Total disbursements',
  `TRANS_TO_AUTH` double DEFAULT NULL COMMENT 'Transfers to authorized committees',
  `COH_BOP` double DEFAULT NULL COMMENT 'Beginning cash',
  `COH_COP` double DEFAULT NULL COMMENT ' Ending cash',
  `CAND_CONTRIB` double DEFAULT NULL COMMENT 'Contributions from candidate',
  `CAND_LOANS` double DEFAULT NULL COMMENT 'Loans from candidate',
  `OTHER_LOANS` double DEFAULT NULL COMMENT 'Other loans',
  `CAND_LOAN_REPAY` double DEFAULT NULL,
  `OTHER_LOAN_REPAY` double DEFAULT NULL,
  `DEBTS_OWED_BY` double DEFAULT NULL,
  `TTL_INDIV_CONTRIB` double DEFAULT NULL,
  `CAND_OFFICE_ST` varchar(2) DEFAULT NULL,
  `CAND_OFFICE_DISTRICT` varchar(2) DEFAULT NULL,
  `SPEC_ELECTION` char(1) DEFAULT NULL,
  `PRIM_ELECTION` char(1) DEFAULT NULL,
  `RUN_ELECTION` char(1) DEFAULT NULL,
  `GEN_ELECTION` char(1) DEFAULT NULL,
  `GEN_ELECTION_PRECENT` double DEFAULT NULL,
  `OTHER_POL_CMTE_CONTRIB` double DEFAULT NULL COMMENT 'Contributions from other political committees',
  `POL_PTY_CONTRIB` double DEFAULT NULL COMMENT 'Contributions from party committees',
  `CVG_END_DT` datetime DEFAULT NULL,
  `INDIV_REFUNDS` double DEFAULT NULL,
  `CMTE_REFUNDS` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- DROP TABLE campaign_finance.candidate_committee
CREATE TABLE  campaign_finance.candidate_committee (
    CAND_ID VARCHAR(9) NOT NULL COMMENT 'A 9-character alpha-numeric code assigned to a candidate by the Federal Election Commission. The candidate ID for a specific candidate remains the same across election cycles as long as the candidate is running for the same office.',
    CAND_ELECTION_YR SMALLINT NOT NULL COMMENT 'Candidate''s election year',
    FEC_ELECTION_YR SMALLINT NOT NULL COMMENT 'Active 2-year period 	2018',
    CMTE_ID VARCHAR(9) 	COMMENT 'A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission. The committee ID for a specific committee always remains the same',
    CMTE_TP CHAR(1) COMMENT 'List of committee type codes',
    CMTE_DSGN CHAR(1) COMMENT 'A = Authorized by a candidate\nB = Lobbyist/Registrant PAC\nD = Leadership PAC\nJ = Joint fundraiser\nP = Principal campaign committee of a candidate\nU = Unauthorized',
    LINKAGE_ID BIGINT(20) COMMENT 'Unique link ID'
)
;

-- Committee master file
-- DROP TABLE committee_master
CREATE TABLE committee_master (
CMTE_ID	VARCHAR(9)	NOT NULL	COMMENT 'Committee identification A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission. Committee IDs are unique and an ID for a specific committee always remains the same. ',
CMTE_NM	VARCHAR(200)		COMMENT ' Committee name',
TRES_NM	VARCHAR(90)		COMMENT 'Treasurer''s name The officially registered treasurer for the committee. ',
CMTE_ST1	VARCHAR(34)		COMMENT ' Street one',
CMTE_ST2	VARCHAR(34)		COMMENT ' Street two',
CMTE_CITY	VARCHAR(30)		COMMENT ' City or town',
CMTE_ST	VARCHAR(2)		COMMENT ' State',
CMTE_ZIP	VARCHAR(9)		COMMENT ' ZIP code',
CMTE_DSGN	VARCHAR(1)		COMMENT 'Committee designation A = Authorized by a candidate B = Lobbyist/Registrant PAC D = Leadership PAC J = Joint fundraiser P = Principal campaign committee of a candidate U = Unauthorized',
CMTE_TP	CHAR(1)		COMMENT ' Committee type',
CMTE_PTY_AFFILIATION	VARCHAR(3)		COMMENT ' Committee party',
CMTE_FILING_FREQ	CHAR(1)		COMMENT 'Filing frequency A = Administratively terminated D = Debt M = Monthly filer Q = Quarterly filer T = Terminated W = Waived ',
ORG_TP	CHAR(1)		COMMENT 'Interest group category C = Corporation L = Labor organization M = Membership organization T = Trade association V = Cooperative W = Corporation without capital stock',
CONNECTED_ORG_NM	VARCHAR(200)		COMMENT ' Connected organization''s name',
CAND_ID	VARCHAR(9)		COMMENT 'Candidate identification When a committee has a committee type designation of H, S, or P, the candidate''s identification number will be entered in this field.'
)
;

-- Contributions by individuals file
-- DROP TABLE contrib_indiv_2_cmte;
CREATE TABLE contrib_indiv_2_cmte (
CMTE_ID	VARCHAR (9)	NOT NULL	COMMENT 'Filer identification number A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission ',
AMNDT_IND	CHAR(1)		COMMENT 'Amendment indicator Indicates if the report being filed is new (N), an amendment (A) to a previous report or a termination (T) report. ',
RPT_TP	VARCHAR (3)		COMMENT 'Report type Indicates the type of report filed List of report type codes ',
TRANSACTION_PGI	VARCHAR (5)		COMMENT 'Primary-general indicator This code indicates the election for which the contribution was made. EYYYY (election plus election year) P = Primary G = General O = Other C = Convention R = Runoff S = Special E = Recount',
IMAGE_NUM	VARCHAR (18)		COMMENT 'Image number 11-digit Image Number Format YYOORRRFFFF YY - scanning year  OO - office (01 - House, 02 - Senate, 03 - FEC Paper, 90-99- FEC Electronic)  RRR - reel number  FFFF- frame number  18-digit Image Number Format (June 29, 2015) YYYYMMDDSSPPPPPPPP YYYY - scanning year  MM - scanning month  DD - scanning day  SS - source (02 - Senate, 03 - FEC Paper, 90-99 - FEC Electronic)  PPPPPPPP - page (reset to zero every year on January 1) ',
TRANSACTION_TP	VARCHAR (3)		COMMENT 'Transaction type Transaction types 10, 11, 15, 15C, 15E, 15I, 15T, 19, 22Y, 24I, 24T, 20Y and 21Y are included in the INDIV file. Beginning with 2016 transaction types 30, 30T, 31, 31T, 32, 32T, 40T, 40Y, 41T, 41Y, 42T and 42Y are also included in the INDIV file. For more information about transaction type codes see this list of transaction type codes ',
ENTITY_TP	VARCHAR (3)		COMMENT 'Entity type ONLY VALID FOR ELECTRONIC FILINGS received after April 2002. CAN = Candidate CCM = Candidate Committee COM = Committee IND = Individual (a person) ORG = Organization (not a committee and not a person) PAC = Political Action Committee PTY = Party Organization',
NAME	VARCHAR (200)		COMMENT 'Contributor/Lender/Transfer Name Contributor/Lender/Transfer Name',
CITY	VARCHAR (30)		COMMENT 'City City',
STATE	CHAR(2)		COMMENT 'State State',
ZIP_CODE	VARCHAR (9)		COMMENT 'ZIP code ZIP code',
EMPLOYER	VARCHAR (38)		COMMENT 'Employer Employer',
OCCUPATION	VARCHAR (38)		COMMENT 'Occupation Occupation',
TRANSACTION_DT	DATETIME		COMMENT 'Transaction date (MMDDYYYY) Transaction date (MMDDYYYY)',
TRANSACTION_AMT	DECIMAL		COMMENT 'Transaction amount Transaction amount',
OTHER_ID	VARCHAR (9)		COMMENT 'Other identification number For contributions from individuals this column is null. For contributions from candidates or other committees this column will contain that contributor''s FEC ID.',
TRAN_ID	VARCHAR (32)		COMMENT 'Transaction ID ONLY VALID FOR ELECTRONIC FILINGS. A unique identifier associated with each itemization or transaction appearing in an FEC electronic file. A transaction ID is unique for a specific committee for a specific report. In other words, if committee, C1, files a Q3 New with transaction SA123 and then files 3 amendments to the Q3 transaction SA123 will be identified by transaction ID SA123 in all 4 filings.',
FILE_NUM	BIGINT		COMMENT ' Unique report id ',
MEMO_CD	CHAR(1)		COMMENT 'Memo code ''X'' indicates that the amount is NOT to be included in the itemization total. ',
MEMO_TEXT	VARCHAR (100)		COMMENT 'Memo text A description of the activity. Memo Text is available on itemized amounts on Schedules A and B. These transactions are included in the itemization total. ',
SUB_ID	BIGINT	NOT NULL	COMMENT 'FEC record number Unique row ID '
)
;

-- Contributions from committees to candidates file
-- DROP TABLE contrib_cmte_2_cand;
 CREATE TABLE contrib_cmte_2_cand (
 CMTE_ID	VARCHAR (9)	NOT NULL	COMMENT 'Filer identification number A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission ',
AMNDT_IND	CHAR(1)		COMMENT 'Amendment indicator Indicates if the report being filed is new (N), an amendment (A) to a previous report or a termination (T) report. ',
RPT_TP	VARCHAR (3)		COMMENT 'Report type Indicates t',
TRANSACTION_PGI	VARCHAR (5)		COMMENT 'Primary-general indicator This code indicates the election for which the contribution was made. EYYYY (election Primary, General, Other plus election year) ',
IMAGE_NUM	VARCHAR (18)		COMMENT 'Image number 11-digit image number format YYOORRRFFFF YY - scanning year  OO - office (01 - House, 02 - Senate, 03 - FEC Paper, 90-99 - FEC Electronic)  RRR - reel number  FFFF- frame number  18-digit image number normat (June 29, 2015) YYYYMMDDSSPPPPPPPP YYYY - scanning year  MM - scanning month  DD - scanning day  SS - source (02 - Senate, 03 - FEC Paper, 90-99 - FEC Electronic)  PPPPPPPP - page (reset to zero every year on January 1)',
TRANSACTION_TP	VARCHAR (3)		COMMENT 'Transaction type Transaction types 10J, 11J, 13, 15J, 15Z, 16C, 16F, 16G, 16R, 17R, 17Z, 18G, 18J, 18K, 18U, 19J, 20, 20C, 20F, 20G, 20R, 22H, 22Z, 23Y, 24A, 24C, 24E, 24F, 24G, 24H, 24K, 24N, 24P, 24R, 24U, 24Z and 29 are included in the OTH file. Beginning with 2016 transaction types 30F, 30G, 30J, 30K, 31F, 31G, 31J, 31K, 32F, 32G, 32J, 32K, 40, 40Z, 41, 41Z, 42 and 42Z are also included in the OTH file. For more information about transaction type codes see this',
ENTITY_TP	VARCHAR (3)		COMMENT 'Entity type ONLY VALID FOR ELECTRONIC FILINGS received after April 2002. CAN = Candidate CCM = Candidate Committee COM = Committee IND = Individual (a person) ORG = Organization (not a committee and not a person) PAC = Political Action Committee PTY = Party Organization',
NAME	VARCHAR (200)		COMMENT 'Contributor/lender/transfer Name Contributor/lender/transfer Name',
CITY	VARCHAR (30)		COMMENT 'City City',
STATE	CHAR(2)		COMMENT 'State State',
ZIP_CODE	VARCHAR (9)		COMMENT 'ZIP code ZIP code',
EMPLOYER	VARCHAR (38)		COMMENT 'Employer Employer',
OCCUPATION	VARCHAR (38)		COMMENT 'Occupation Occupation',
TRANSACTION_DT	DATETIME		COMMENT 'Transaction date (MMDDYYYY) Transaction date (MMDDYYYY)',
TRANSACTION_AMT	DECIMAL		COMMENT 'Transaction amount Transaction amount',
OTHER_ID	VARCHAR (9)		COMMENT 'Other identification number For contributions from individuals this column is null. For contributions from candidates or other committees this column will contain that contributor''s FEC ID.',
CAND_ID	VARCHAR (9)		COMMENT 'Candidate ID A 9-character alpha-numeric code assigned to a candidate by the Federal Election Commission. The candidate ID for a specific candidate remains the same across election cycles as long as the candidate is running for the same office.',
TRAN_ID	VARCHAR (32)		COMMENT 'Transaction ID ONLY VALID FOR ELECTRONIC FILINGS. A unique identifier associated with each itemization or transaction appearing in an FEC electronic file. A transaction ID is unique for a specific committee for a specific report. In other words, if committee, C1, files a Q3 New with transaction SA123 and then files 3 amendments to the Q3 transaction SA123 will be identified by transaction ID SA123 in all 4 filings.',
FILE_NUM	BIGINT		COMMENT 'File number - Report ID Unique report id ',
MEMO_CD	CHAR(1)		COMMENT 'Memo code ''X'' indicates that the amount is NOT to be included in the itemization total. ',
MEMO_TEXT	VARCHAR (100)	COMMENT 'Memo text A description of the activity. Memo text is available on itemized amounts on Schedules A and B. These transactions are included in the itemization total. ',
SUB_ID	BIGINT	NOT NULL	COMMENT 'FEC record number Unique row ID '
 )
 ;
 
-- DROP TABLE campaign_finance.operating_expenditure;
CREATE TABLE campaign_finance.operating_expenditure (
  `CMTE_ID` varchar(9) DEFAULT NULL COMMENT 'Identification number of committee filing report. A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission ',
  `AMNDT_IND` char(1) DEFAULT NULL COMMENT ' Indicates if the report being filed is new (N), an amendment (A) to a previous report, or a termination (T) report. ',
  `RPT_YR` bigint(20) DEFAULT NULL,
  `RPT_TP` varchar(3) DEFAULT NULL COMMENT 'Indicates the type of report filed.',
  `IMAGE_NUM` varchar(18) DEFAULT NULL COMMENT '11-digit Image Number Format\nYYOORRRFFFF\nYY - scanning year\nOO - office (01 - House, 02 - Senate, 03 - FEC Paper, 90-99 - FEC Electronic)\nRRR - reel number\nFFFF- frame number\n\n18-digit Image Number Format (June 29, 2015)\nYYYYMMDDSSPPPPPPPP\nYYYY - scanning year\nMM - scanning month\nDD - scanning day\nSS - source (02 - Senate, 03 - FEC Paper, 90-99 - FEC Electronic)\nPPPPPPPP - page (reset to zero every year on January 1) ',
  `LINE_NUM` varchar(3) DEFAULT NULL COMMENT 'Indicates FEC form line number ',
  `FORM_TP_CD` varchar(8) DEFAULT NULL COMMENT 'Indicates FEC Form',
  `SCHED_TP_CD` varchar(8) DEFAULT NULL COMMENT ' Schedule B - Itemized disbursements ',
  `NAME` varchar(200) DEFAULT NULL,
  `CITY` varchar(30) DEFAULT NULL,
  `STATE` varchar(2) DEFAULT NULL,
  `ZIP_CODE` varchar(9) DEFAULT NULL,
  `TRANSACTION_DT` datetime DEFAULT NULL,
  `TRANSACTION_AMT` double DEFAULT NULL,
  `TRANSACTION_PGI` varchar(5) DEFAULT NULL,
  `PURPOSE` varchar(100) DEFAULT NULL,
  `CATEGORY` varchar(3) DEFAULT NULL COMMENT '001-012 and 101-107 ',
  `CATEGORY_DESC` varchar(40) DEFAULT NULL,
  `MEMO_CD` char(1) DEFAULT NULL COMMENT '''X'' indicates that the amount is NOT to be included in the itemization total. ',
  `MEMO_TEXT` varchar(100) DEFAULT NULL COMMENT 'A description of the activity. Memo Text is available on itemized amounts on Schedule B. These transactions are included in the itemization total. ',
  `ENTITY_TP` varchar(3) DEFAULT NULL COMMENT 'VARCHAR2 (3) 	ONLY VALID FOR ELECTRONIC FILINGS received after April 2002. CAN = Candidate\nCCM = Candidate committee\nCOM = Committee\nIND = Individual (a person)\nORG = Organization (not a committee and not a person)\nPAC = Political action committee\nPTY = Party organization ',
  `SUB_ID` bigint DEFAULT NULL COMMENT 'Unique row ID ',
  `FILE_NUM` int(11) DEFAULT NULL COMMENT 'Unique report id ',
  `TRAN_ID` varchar(32) DEFAULT NULL COMMENT 'ONLY VALID FOR ELECTRONIC FILINGS. A unique identifier associated with each itemization or transaction appearing in an FEC electronic file. A transaction ID is unique for a specific committee for a specific report. In other words, if committee, C1, files a Q3 New with transaction SA123 and then files 3 amendments to the Q3 transaction SA123 will be identified by transaction ID SA123 in all 4 filings.',
  `BACK_REF_TRAN_ID` varchar(32) DEFAULT NULL COMMENT 'ONLY VALID FOR ELECTRONIC FILINGS. Used to associate one transaction with another transaction in the same report (using file number, transaction ID and back reference transaction ID). For example, a credit card payment and the subitemization of specific purchases. The back reference transaction ID of the specific purchases will equal the transaction ID of the payment to the credit card company. '
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


 
-- PAC and party summary file
-- DROP TABLE pac_party_summary;
CREATE TABLE pac_party_summary (
    CMTE_ID	VARCHAR (9)	NOT NULL	COMMENT 'Committee identification',
    CMTE_NM	VARCHAR (200)		COMMENT 'Committee name',
    CMTE_TP	CHAR(1)		COMMENT 'Committee type',
    CMTE_DSGN	CHAR(1)		COMMENT 'Committee designation',
    CMTE_FILING_FREQ	CHAR(1)		COMMENT 'Committee filing frequency',
    TTL_RECEIPTS	DECIMAL		COMMENT 'Total receipts',
    TRANS_FROM_AFF	DECIMAL		COMMENT 'Transfers from affiliates',
    INDV_CONTRIB	DECIMAL		COMMENT 'Contributions from individuals',
    OTHER_POL_CMTE_CONTRIB	DECIMAL		COMMENT 'Contributions from other political committees',
    CAND_CONTRIB	DECIMAL		COMMENT 'Contributions from candidate',
    CAND_LOANS	DECIMAL		COMMENT 'Candidate loans',
    TTL_LOANS_RECEIVED	DECIMAL		COMMENT 'Total loans received',
    TTL_DISB	DECIMAL		COMMENT 'Total disbursements',
    TRANF_TO_AFF	DECIMAL		COMMENT 'Transfers to affiliates',
    INDV_REFUNDS	DECIMAL		COMMENT 'Refunds to individuals',
    OTHER_POL_CMTE_REFUNDS	DECIMAL		COMMENT 'Refunds to other political committees',
    CAND_LOAN_REPAY	DECIMAL		COMMENT 'Candidate loan repayments',
    LOAN_REPAY	DECIMAL		COMMENT 'Loan repayments',
    COH_BOP	DECIMAL		COMMENT 'Cash beginning of period',
    COH_COP	DECIMAL		COMMENT 'Cash close Of period',
    DEBTS_OWED_BY	DECIMAL		COMMENT 'Debts owed by',
    NONFED_TRANS_RECEIVED	DECIMAL		COMMENT 'Nonfederal transfers received',
    CONTRIB_TO_OTHER_CMTE	DECIMAL		COMMENT 'Contributions to other committees',
    IND_EXP	DECIMAL		COMMENT 'Independent expenditures',
    PTY_COORD_EXP	DECIMAL		COMMENT 'Party coordinated expenditures',
    NONFED_SHARE_EXP	DECIMAL		COMMENT 'Nonfederal share expenditures',
    CVG_END_DT	DATETIME		COMMENT 'Coverage end date '
)
;


-- DROP TABLE campaign_finance.trans_among_cmte
CREATE TABLE campaign_finance.trans_among_cmte (
    CMTE_ID 	VARCHAR(9) NOT NULL COMMENT 'A 9-character alpha-numeric code assigned to a committee by the Federal Election Commission',
    AMNDT_IND 	CHAR(1) COMMENT 'Indicates if the report being filed is new (N), an amendment (A) to a previous report, or a termination (T) report.',
    RPT_TP 	    VARCHAR(3) COMMENT 'Indicates the type of report filed. List of report type codes',
    TRANSACTION_PGI VARCHAR(5) COMMENT 'This code indicates the election for which the contribution was made. EYYYY (election Primary, General, Other plus election year)',
    IMAGE_NUM 	VARCHAR(18),
    TRANSACTION_TP 	VARCHAR(3) COMMENT 'Transaction types 10J, 11J, 13, 15J, 15Z, 16C, 16F, 16G, 16R, 17R, 17Z, 18G, 18J, 18K, 18U, 19J, 20, 20C, 20F, 20G, 20R, 22H, 22Z, 23Y, 24A, 24C, 24E, 24F, 24G, 24H, 24K, 24N, 24P, 24R, 24U, 24Z and 29 are included in the OTH file. Beginning with 2016 transaction types 30F, 30G, 30J, 30K, 31F, 31G, 31J, 31K, 32F, 32G, 32J, 32K, 40, 40Z, 41, 41Z, 42 and 42Z are also included in the OTH file.
    For more information about transaction type codes see this list of transaction type codes',
    ENTITY_TP 	VARCHAR(3) COMMENT 'ONLY VALID FOR ELECTRONIC FILINGS received after April 2002. CAN = Candidate\nCCM = Candidate Committee\nCOM = Committee\nIND = Individual (a person)\nORG = Organization (not a committee and not a person)\nPAC = Political Action Committee\nPTY = Party Organization',
    `NAME` 	VARCHAR(200),
    CITY 	VARCHAR(30),		
    STATE 	VARCHAR(2),	
    ZIP_CODE 	VARCHAR(9),
    EMPLOYER 	VARCHAR(38),
    OCCUPATION 	VARCHAR(38),
    TRANSACTION_DT 	DATETIME,
    TRANSACTION_AMT 	DOUBLE,
    OTHER_ID 	VARCHAR(9) COMMENT 'For contributions from individuals this column is null. For contributions from candidates or other committees this column will contain that contributor''s FEC ID.',
    TRAN_ID 	VARCHAR(32) COMMENT 'ONLY VALID FOR ELECTRONIC FILINGS. A unique identifier associated with each itemization or transaction appearing in an FEC electronic file. A transaction ID is unique for a specific committee for a specific report. In other words, if committee, C1, files a Q3 New with transaction SA123 and then files 3 amendments to the Q3 transaction SA123 will be identified by transaction ID SA123 in all 4 filings.',
    FILE_NUM 	DECIMAL COMMENT 'Unique report id',
    MEMO_CD 	CHAR(1) COMMENT '''X'' indicates that the amount is NOT to be included in the itemization total.',
    MEMO_TEXT 	VARCHAR(100) COMMENT 'A description of the activity. Memo text is available on itemized amounts on Schedules A and B. These transactions are included in the itemization total.',
    SUB_ID 	BIGINT	NOT NULL COMMENT 'Unique row ID'
)
;




-- DROP TABLE campaign_finance.party
CREATE TABLE `party` (
  `MAJOR_MINOR` char(1) NOT NULL COMMENT 'Party code. 1 digit integer. 1 = DEM. 2 = REP. 3 = all other parties',
  `PTY_AFFILIATION` varchar(3) NOT NULL COMMENT '3 character string abbreviation for party',
  `PARTY_NAME` varchar(50) DEFAULT NULL,
  `DETAILS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PTY_AFFILIATION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


-- DROP TABLE ici_status
CREATE TABLE `ici_status` (
  `CAND_ICI` CHAR(1) NOT NULL COMMENT 'Status: I, C or O',
  `STATUS` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CAND_ICI`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


