

/*

    ccl.txt       candidate_committee
    cm.txt        committee_master
    weblYY.txt    fed_current_campaign_summary
    cn.txt        candidate_master
    itcont.txt    contrib_indiv_2_cmte
    itoth.txt     trans_among_cmte
    itpas2.txt    contrib_cmte_2_cand
    oppexp.txt    operating_expenditure
    weballYY.txt  candidate_all 
    webkYY.txt    pac_party_summary

*/

-- -----------------------------------------------------
-- TABLE `candidate_all`
-- -----------------------------------------------------

SELECT COUNT(*) FROM candidate_all;
-- SELECT * FROM campaign_finance.candidate_all;
-- TRUNCATE campaign_finance.candidate_all;


-- COMPARE PRIMARY KEYS  (CAND_ID) in candidate_master and candidate_all
-- candidate_all is missing many candidate_master
-- candidate_master has a duplicate cand_id
SELECT cn.CAND_ID
, cn.num_candidate_master
, cn_all.CAND_ID
, cn_all.num_candidate_all
FROM 
    (SELECT CAND_ID, COUNT(CAND_ID) AS num_candidate_master
    FROM campaign_finance.candidate_master
    GROUP BY CAND_ID) cn
LEFT OUTER JOIN 
    (SELECT CAND_ID, COUNT(CAND_ID) AS num_candidate_all
    FROM campaign_finance.candidate_all
    GROUP BY CAND_ID
    )  cn_all
ON cn.CAND_ID = cn_all.CAND_ID
-- WHERE c_all.CAND_ID IS NOT NULL
  WHERE  num_candidate_master > 1
;
  

--  HUNTING FOR PRIMARY KEYS
SELECT CAND_ID, COUNT(*) AS COPIES FROM candidate_all
GROUP BY CAND_ID
HAVING COPIES > 1
ORDER BY COPIES DESC;


SELECT CAND_ID, CVG_END_DT, COUNT(*) AS COPIES FROM candidate_all
GROUP BY CAND_ID, CVG_END_DT
HAVING COPIES > 1
ORDER BY COPIES DESC;


-- -----------------------------------------------------
-- TABLE `candidate_master`
-- -----------------------------------------------------

SELECT COUNT(*) FROM candidate_master;
select * from candidate_master order by cand_id;
-- TRUNCATE campaign_finance.candidate_master;


-- JOIN CANDIDATE TO CAMPAIGN cn to cm
SELECT cn.CAND_NAME, cn.CAND_ID, COUNT(cm.CMTE_ID)
FROM candidate_master AS cn
LEFT OUTER JOIN committee_master AS cm ON cn.CAND_ID = cm.CAND_ID
GROUP BY cn.CAND_NAME, cn.CAND_ID
LIMIT 1000;


-- COMMITTEES WITH NO CANDIDATES cm to cn
SELECT cn.CAND_NAME, cn.CAND_ID, cn.CAND_PTY_AFFILIATION, cm.CMTE_ID, cm.CMTE_PTY_AFFILIATION
FROM candidate_master AS cn
RIGHT OUTER JOIN committee_master AS cm ON cn.CAND_ID = cm.CAND_ID
LIMIT 1000;


--  HUNTING FOR PRIMARY KEYS

SELECT CAND_ID, CAND_ELECTION_YR, CAND_OFFICE_ST, CAND_OFFICE, CAND_OFFICE_DISTRICT
FROM `campaign_finance`.`candidate_master`
WHERE CAND_ELECTION_YR IS NULL
OR CAND_OFFICE_ST IS NULL
OR CAND_OFFICE IS NULL
OR CAND_OFFICE_DISTRICT IS NULL;

SELECT COUNT(*) AS REPEATS, CAND_ID, CAND_ELECTION_YR, CAND_OFFICE_ST, CAND_OFFICE
FROM `campaign_finance`.`candidate_master`
GROUP BY CAND_ID, CAND_ELECTION_YR, CAND_OFFICE_ST, CAND_OFFICE
HAVING REPEATS > 1;


SELECT * FROM CANDIDATE_MASTER
WHERE CAND_ID IN (
    SELECT CAND_ID
    FROM `campaign_finance`.`candidate_master`
    GROUP BY CAND_ID, CAND_ELECTION_YR, CAND_OFFICE_ST, CAND_OFFICE
    HAVING COUNT(*) > 1
    )
ORDER BY candidate_master.CAND_ID
;


-- -----------------------------------------------------
-- TABLE `candidate_committee`
-- -----------------------------------------------------

SELECT COUNT(*) FROM candidate_committee;
SELECT * FROM candidate_committee;
-- EXPLAIN candidate_committee;
-- TRUNCATE campaign_finance.candidate_committee;


-- figuring out why I cannot create a foreign key
/*
ALTER TABLE `campaign_finance`.`candidate_committee` 
ADD CONSTRAINT `fk_candidate_committee_candidate_master1`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`),
ADD CONSTRAINT `fk_candidate_committee_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`);

Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`campaign_finance`.`#sql-5c07_e`, CONSTRAINT `fk_candidate_committee_candidate_master1` FOREIGN KEY (`CAND_ID`) REFERENCES `candidate_master` (`CAND_ID`))

This didn't work, either...
 
ALTER TABLE `campaign_finance`.`candidate_committee` 
ADD CONSTRAINT `fk_candidate_committee_HSCC_1`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`fed_current_campaign_summary` (`CAND_ID`)
;
*/

SELECT candidate_committee.cand_id
, candidate_committee.CAND_ELECTION_YR
, candidate_committee.cmte_id
, candidate_master.cand_id AS CM_cand_id
, candidate_all.cand_id AS CA_cand_id
, fed_current_campaign_summary.cand_id AS FS_cand_id
FROM candidate_committee
LEFT OUTER JOIN candidate_master
    ON candidate_committee.cand_id = candidate_master.cand_id
LEFT OUTER JOIN candidate_all
    ON candidate_committee.cand_id = candidate_all.cand_id
LEFT OUTER JOIN fed_current_campaign_summary
    ON candidate_committee.cand_id = fed_current_campaign_summary.cand_id
WHERE candidate_master.cand_id IS NULL
;


-- -----------------------------------------------------
-- TABLE `committee_master`
-- -----------------------------------------------------

SELECT COUNT(*) FROM committee_master;
EXPLAIN committee_master;
-- TRUNCATE campaign_finance.committee_master;

-- Another foreign key creation problem
/*
ALTER TABLE `campaign_finance`.`committee_master` 
ADD CONSTRAINT `fk_committee_master_candidate_master1`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`);

Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`campaign_finance`.`#sql-5c07_e`, CONSTRAINT `fk_committee_master_candidate_master1` FOREIGN KEY (`CAND_ID`) REFERENCES `candidate_master` (`CAND_ID`))
*/

SELECT committee_master.CMTE_ID
, committee_master.CMTE_NM
, committee_master.CAND_ID
, candidate_master.CAND_ID AS CANMAS_CAND_ID
, candidate_all.CAND_ID AS AC_ID
FROM committee_master
LEFT OUTER JOIN candidate_master
    ON committee_master.CAND_ID = candidate_master.CAND_ID
LEFT OUTER JOIN candidate_all
    ON committee_master.CAND_ID = candidate_all.CAND_ID
WHERE candidate_master.CAND_ID IS NULL
AND committee_master.CAND_ID IS NOT NULL;


-- Committee IDs are unique and an ID for a specific committee always remains the same. 
-- CAND_ID is often null

--  HUNTING FOR PRIMARY KEYS

SELECT  CMTE_ID,  CAND_ID, COUNT(*) AS COPIES
FROM committee_master
-- WHERE
GROUP BY CMTE_ID,  CAND_ID
HAVING COPIES > 1
ORDER BY COPIES, CMTE_ID DESC;


-- -----------------------------------------------------
-- TABLE `fed_current_campaign_summary`
-- -----------------------------------------------------

SELECT COUNT(*) FROM fed_current_campaign_summary;
-- TRUNCATE campaign_finance.fed_current_campaign_summary;


-- COMPARE PRIMARY KEY (CAND_ID) counts candidate_master and fed_current_campaign_summary
-- fed_current_campaign_summary is missing many candidates in master
SELECT cn.CAND_ID
, cn.num_candidate_master
, webl.CAND_ID
, webl.num_fed
FROM 
    (SELECT CAND_ID, COUNT(CAND_ID) AS num_candidate_master
    FROM campaign_finance.candidate_master
    GROUP BY CAND_ID) cn
LEFT OUTER JOIN 
-- RIGHT OUTER JOIN 
    (SELECT CAND_ID, COUNT(CAND_ID) AS num_fed
    FROM campaign_finance.fed_current_campaign_summary
    GROUP BY CAND_ID
    ) webl
ON cn.CAND_ID = webl.CAND_ID
WHERE  num_fed IS NULL
;
 
--  HUNTING FOR PRIMARY KEYS

SELECT CAND_ID, CVG_END_DT, COUNT(*) AS COPIES FROM  fed_current_campaign_summary
GROUP BY CAND_ID, CVG_END_DT
HAVING COPIES > 1
ORDER BY COPIES DESC;

-- -----------------------------------------------------
-- TABLE `contrib_cmte_2_cand`
-- -----------------------------------------------------

/*
  349776 2018/itpas2.txt
   36036 2020/itpas2.txt
  385812 total */
SELECT COUNT(*) FROM contrib_cmte_2_cand;
EXPLAIN contrib_cmte_2_cand;
-- TRUNCATE campaign_finance.contrib_cmte_2_cand;


--  HUNTING FOR PRIMARY KEYS
SELECT CMTE_ID, COUNT(*) AS COPIES
FROM contrib_cmte_2_cand
-- WHERE
GROUP BY CMTE_ID
HAVING COPIES > 1;

SELECT SUB_ID, COUNT(*) AS COPIES
FROM contrib_cmte_2_cand
-- WHERE
GROUP BY SUB_ID
HAVING COPIES > 1;


-- -----------------------------------------------------
-- TABLE `contrib_indiv_2_cmte`
-- -----------------------------------------------------

SELECT COUNT(*) FROM contrib_indiv_2_cmte;
-- TRUNCATE campaign_finance.contrib_indiv_2_cmte;


--  HUNTING FOR PRIMARY KEYS
SELECT SUB_ID, COUNT(*) AS COPIES
FROM contrib_indiv_2_cmte
-- WHERE
GROUP BY SUB_ID
HAVING COPIES > 1;


-- -----------------------------------------------------
-- TABLE `trans_among_cmte`
-- -----------------------------------------------------

/*
 1008343 2018/itoth.txt
  205639 2020/itoth.txt
 1213982 total */
SELECT COUNT(*) FROM trans_among_cmte;
EXPLAIN trans_among_cmte;
-- TRUNCATE campaign_finance.trans_among_cmte;


--  HUNTING FOR PRIMARY KEYS
SELECT SUB_ID, COUNT(*) AS COPIES
FROM  trans_among_cmte
-- WHERE
GROUP BY SUB_ID
HAVING COPIES > 1;


-- -----------------------------------------------------
-- TABLE `pac_party_summary`
-- -----------------------------------------------------

/*
   12389 2018/webk18.txt
    8461 2020/webk20.txt
   20850 total */
SELECT COUNT(*) FROM pac_party_summary;
EXPLAIN pac_party_summary;
-- TRUNCATE campaign_finance.pac_party_summary


--  HUNTING FOR PRIMARY KEYS
SELECT COUNT(*) AS CVG_NULL
FROM    pac_party_summary
WHERE   CVG_END_DT IS NULL
;

SELECT SUB_ID, COUNT(*) AS COPIES
FROM pac_party_summary
-- WHERE
GROUP BY SUB_ID
HAVING COPIES > 1;


-- -----------------------------------------------------
-- TABLE `operating_expenditure`
-- -----------------------------------------------------

 /*
 1802139 2018/oppexp.txt
  157377 2020/oppexp.txt
 1959516 total */
SELECT COUNT(*) FROM operating_expenditure;
-- TRUNCATE campaign_finance.operating_expenditure;


--  HUNTING FOR PRIMARY KEYS
-- dupes on sub_id. no candidate compound key
SELECT CMTE_ID, SUB_ID, TRAN_ID, COUNT(*) AS COPIES
FROM operating_expenditure
GROUP BY CMTE_ID, SUB_ID, TRAN_ID
HAVING  COPIES > 1
ORDER BY  COPIES DESC;

SELECT * FROM operating_expenditure
INNER JOIN
    (SELECT CMTE_ID, SUB_ID, TRAN_ID, COUNT(*) AS COPIES
    FROM operating_expenditure
    GROUP BY CMTE_ID, SUB_ID, TRAN_ID
    HAVING  COPIES > 1
    ) AS copies
ON operating_expenditure.CMTE_ID = copies.CMTE_ID
AND operating_expenditure.SUB_ID = copies.SUB_ID
AND operating_expenditure.TRAN_ID = copies.TRAN_ID
;
SELECT DISTINCT TRANSACTION_DT
FROM operating_expenditure;

SELECT CMTE_ID, SUB_ID, RPT_YR, TRAN_ID, COUNT(*) AS COPIES
FROM operating_expenditure
GROUP BY CMTE_ID, SUB_ID, RPT_YR, TRAN_ID
HAVING  COPIES > 1
ORDER BY  COPIES DESC;


/*
# rpt_yr, count(*)
2019, 157377
2018, 1171644
2017, 630495
*/

SELECT rpt_yr, COUNT(*)
FROM operating_expenditure
GROUP BY rpt_yr;


-- -----------------------------------------------------
-- TABLE `party;`
-- -----------------------------------------------------

SELECT COUNT(*) FROM party;
EXPLAIN party;

SELECT PTY_CD, CAND_PTY_AFFILIATION 
FROM fed_current_campaign_summary
WHERE PTY_CD !=3
GROUP BY PTY_CD, CAND_PTY_AFFILIATION;


-- -----------------------------------------------------
-- TABLE `ici_status;`
-- -----------------------------------------------------

SELECT COUNT(*) FROM ici_status;
EXPLAIN ici_status;




/*************************************************
    Potential view. Gives latest summary statement 
    on federal elections campaigns.
*************************************************/

SELECT fed_current_campaign_summary.CAND_NAME
    , candidate_master.CAND_ELECTION_YR AS ELECT_YR
    , fed_current_campaign_summary.PTY_CD
    , fed_current_campaign_summary.CAND_PTY_AFFILIATION AS PARTY
    , fed_current_campaign_summary.CAND_ICI
    -- GEN_ELECTION
    , fed_current_campaign_summary.CAND_OFFICE_ST AS STATE
    , fed_current_campaign_summary.CAND_OFFICE_DISTRICT AS DISTRICT
    , FORMAT(COH_BOP, 2) AS CASH_START
    , FORMAT(COH_COP, 2) AS CASH_END
    , FORMAT(DEBTS_OWED_BY, 2) AS DEBT
    -- INCOMING
    , FORMAT(TTL_RECEIPTS, 2) AS TOTAL_RCPTS
    , FORMAT(TTL_INDIV_CONTRIB, 2) AS TOTAL_INDIV_CONTR
    , FORMAT(CAND_CONTRIB, 2) AS SELF_CONTRIB
    , FORMAT(OTHER_POL_CMTE_CONTRIB, 2) AS CMTE_CONTRIB
    , FORMAT(POL_PTY_CONTRIB, 2) AS PARTY_CONTRIB
    , FORMAT(TRANS_FROM_AUTH, 2) AS TRANSFER_IN
    , FORMAT(CAND_LOANS, 2) AS SELF_LOAN
    , FORMAT(OTHER_LOANS, 2) AS LOANS
    -- OUTGOING
    , FORMAT(TTL_DISB, 2) AS TOTAL_DISB
    , FORMAT(TRANS_TO_AUTH, 2) AS TRANSFER_OUT
    , FORMAT(CAND_LOAN_REPAY, 2) AS REPAY_SELF
    , FORMAT(OTHER_LOAN_REPAY, 2) AS REPAY_LOAN
    , FORMAT(INDIV_REFUNDS, 2) AS INDIV_REF
    , FORMAT(CMTE_REFUNDS, 2) AS CMTE_REF
    , CVG_END_DT AS COVERAGE_END_DATE
    , CAND_STATUS
    , candidate_master.CAND_NAME
FROM fed_current_campaign_summary
LEFT OUTER JOIN candidate_master ON fed_current_campaign_summary.CAND_ID = candidate_master.CAND_ID
-- Just presidential campaigns
WHERE fed_current_campaign_summary.CAND_OFFICE_ST = '00' AND fed_current_campaign_summary.CAND_OFFICE_DISTRICT = '00'
-- Coverage ending on or after last day of previous quarter
-- 1st day of current year + Previous quarter - 2 Day
AND CVG_END_DT > MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER - INTERVAL 1 DAY
ORDER BY TTL_RECEIPTS DESC
;


SELECT DISTINCT PRIM_ELECTION FROM fed_current_campaign_summary;


/*************************************************
    Potential view. Presidential campaigns most recent summary
*************************************************/
SELECT fed_current_campaign_summary.CAND_NAME
, fed_current_campaign_summary.CAND_ICI
, party.PARTY_NAME
, fed_current_campaign_summary.TTL_RECEIPTS
, fed_current_campaign_summary.TTL_DISB
, fed_current_campaign_summary.COH_COP
, fed_current_campaign_summary.DEBTS_OWED_BY
, fed_current_campaign_summary. CVG_END_DT
FROM fed_current_campaign_summary
-- Just presidential campaigns
LEFT OUTER JOIN party ON fed_current_campaign_summary.CAND_PTY_AFFILIATION =  party.PTY_AFFILIATION
WHERE CAND_OFFICE_ST = '00' AND CAND_OFFICE_DISTRICT = '00'
-- Coverage ending on or after last day of previous quarter
-- 1st day of current year + Previous quarter - 2 Day
AND CVG_END_DT > MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER - INTERVAL 1 DAY
ORDER BY TTL_RECEIPTS DESC;


/*************************************************
    Potential view. Presidential campaign receipts
    by party, most recent summary
*************************************************/
SELECT party.PARTY_NAME
, FORMAT(SUM(fed_current_campaign_summary.TTL_RECEIPTS), 2) AS SUM_TTL_RECEIPTS
, FORMAT(SUM(fed_current_campaign_summary.TTL_DISB), 2) AS SUM_TTL_DISB
, FORMAT(SUM(fed_current_campaign_summary.COH_COP), 2) AS SUM_COH_COP
, FORMAT(SUM(fed_current_campaign_summary.DEBTS_OWED_BY), 2) AS SUM_DEBTS_OWED_BY
FROM fed_current_campaign_summary
LEFT OUTER JOIN party ON fed_current_campaign_summary.CAND_PTY_AFFILIATION =  party.PTY_AFFILIATION
WHERE CAND_OFFICE_ST = '00'
AND CAND_OFFICE_DISTRICT = '00'
-- Coverage ending on or after last day of previous quarter
-- 1st day of current year + Previous quarter - 2 Day
AND CVG_END_DT > MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER - INTERVAL 1 DAY
GROUP BY CAND_PTY_AFFILIATION
ORDER BY SUM(TTL_RECEIPTS) DESC;


/*************************************************
    Potential view. Campaings for a State. 
    Figure out how to make senate show up (district = '00'
*************************************************/

SELECT fed_current_campaign_summary.CAND_NAME
, CAND_OFFICE_ST AS STATE
, CAND_OFFICE_DISTRICT AS DISTRICT
, ici_status.STATUS AS ICI
, party.PARTY_NAME
, fed_current_campaign_summary.TTL_RECEIPTS
, fed_current_campaign_summary.TTL_DISB
, fed_current_campaign_summary.COH_COP
, fed_current_campaign_summary.DEBTS_OWED_BY
, fed_current_campaign_summary. CVG_END_DT
FROM fed_current_campaign_summary
-- Just presidential campaigns
LEFT OUTER JOIN party ON fed_current_campaign_summary.CAND_PTY_AFFILIATION =  party.PTY_AFFILIATION
LEFT OUTER JOIN ici_status ON fed_current_campaign_summary.CAND_ICI = ici_status.CAND_ICI
WHERE CAND_OFFICE_ST = 'CO'
-- Coverage ending on or after last day of previous quarter
-- 1st day of current year + Previous quarter - 2 Day
AND CVG_END_DT > MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER - INTERVAL 1 DAY
ORDER BY CAND_OFFICE_ST, CAND_OFFICE_DISTRICT, TTL_RECEIPTS DESC;


/*************************************************
    Incumbents being outraised [or outspent] by 
    their challenger

* I see Al Franken as an incumbent, so that's a problem
*
**************************************************/

-- incumbents
SELECT incumbent.CAND_ID
  , incumbent.CAND_NAME AS INCUMBENT_NAME
  , incumbent.CAND_OFFICE_ST AS STATE
  , incumbent.CAND_OFFICE_DISTRICT AS DISTRICT
  , incumbent.CVG_END_DT
  , ici_status.STATUS AS ICI
  , party.PARTY_NAME
  , incumbent.TTL_RECEIPTS AS INCUMBENT_RECEIPTS
  , challenger.TTL_RECEIPTS AS CHALLENGER_RECEIPTS
  , challenger.CAND_NAME AS CHALLENGER_NAME
  , challenger.STATE
  , challenger.DISTRICT
FROM fed_current_campaign_summary AS incumbent
LEFT OUTER JOIN party ON incumbent.CAND_PTY_AFFILIATION =  party.PTY_AFFILIATION
LEFT OUTER JOIN ici_status ON incumbent.CAND_ICI = ici_status.CAND_ICI
LEFT OUTER JOIN 
  (
    -- challengers
    SELECT TTL_RECEIPTS
      , CAND_NAME
      , CAND_OFFICE_ST AS STATE
      , CAND_OFFICE_DISTRICT AS DISTRICT
    FROM fed_current_campaign_summary
    -- Coverage ending on or after last day of previous quarter
    -- 1st day of current year + Previous quarter - 2 Day
    WHERE CVG_END_DT > MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER - INTERVAL 1 DAY
        AND CAND_ICI = 'C' 
  ) AS challenger
  ON incumbent.CAND_OFFICE_ST = challenger.STATE
  AND incumbent.CAND_OFFICE_DISTRICT = challenger.DISTRICT
WHERE CVG_END_DT > MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL QUARTER(CURDATE())-2 QUARTER - INTERVAL 1 DAY
    AND incumbent.CAND_ICI = 'I'
    AND challenger.TTL_RECEIPTS > incumbent.TTL_RECEIPTS
;

