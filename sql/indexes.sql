-- INDEXES NOT RELATED TO FOREIGN KEYS

-- -----------------------------------------------------
-- Table candidate_all
-- -----------------------------------------------------

-- Duplicates on cand_id across cycles.
-- Use coverage end date in PK
ALTER TABLE `campaign_finance`.`candidate_all` 
ADD PRIMARY KEY (`CAND_ID`, `CVG_END_DT`)
;


-- -----------------------------------------------------
-- Table candidate_master
-- -----------------------------------------------------

-- cand_id remains the same across election cycles as 
-- long as the candidate is running for the same office.
-- When loading, REPLACE (overwrite) records with duplicate keys.
-- Cannot include CAND_OFFICE_DISTRICT because it has nulls.
ALTER TABLE `campaign_finance`.`candidate_master`
ADD PRIMARY KEY(CAND_ID, CAND_ELECTION_YR, CAND_OFFICE_ST, CAND_OFFICE);
;

-- -----------------------------------------------------
-- Table fed_current_campaign_summary
-- -----------------------------------------------------
-- Duplicates on cand_id across cycles.
-- Use coverage end date in PK
ALTER TABLE `campaign_finance`.`fed_current_campaign_summary` 
ADD PRIMARY KEY (`CAND_ID`, `CVG_END_DT`)
;


-- -----------------------------------------------------
-- Table committee_master
-- -----------------------------------------------------

-- duplicates on cmte_id
-- Committee IDs are unique and an ID for a specific 
-- committee always remains the same. 
ALTER TABLE `campaign_finance`.`committee_master`
ADD PRIMARY KEY(CMTE_ID)
;

-- -----------------------------------------------------
-- Table candidate_committee
-- -----------------------------------------------------
-- LINKAGE_ID is designated by FEC to be unique.
ALTER TABLE `campaign_finance`.`candidate_committee` 
ADD PRIMARY KEY (`LINKAGE_ID`);
;


-- -----------------------------------------------------
-- Table contrib_cmte_2_cand
-- -----------------------------------------------------
ALTER TABLE `campaign_finance`.`contrib_cmte_2_cand` 
ADD PRIMARY KEY (`SUB_ID`);
;

-- -----------------------------------------------------
-- Table trans_among_cmte
-- -----------------------------------------------------
ALTER TABLE `campaign_finance`.`trans_among_cmte` 
ADD PRIMARY KEY (`SUB_ID`);
;


-- -----------------------------------------------------
-- Table pac_party_summary
-- -----------------------------------------------------

-- Duplicates on CMTE_ID across cycles.
-- Use CMTE_ID as PK anyway and write over old copies.
-- CVG_END_DT contains nulls, so we cannot use in primary key
ALTER TABLE `campaign_finance`.`pac_party_summary` 
ADD PRIMARY KEY (`CMTE_ID`);
/*
    ALTER TABLE `campaign_finance`.`pac_party_summary` 
    ADD PRIMARY KEY (`CMTE_ID`, `CVG_END_DT`);
*/

-- -----------------------------------------------------
-- Table contrib_indiv_2_cmte
-- -----------------------------------------------------
ALTER TABLE `campaign_finance`.`contrib_indiv_2_cmte` 
ADD PRIMARY KEY (`SUB_ID`);
;
    
-- -----------------------------------------------------
-- Table operating_expenditure
-- -----------------------------------------------------

-- Duplicates (multitudes) on sub_id
-- Trying the combination key CMTE_ID, SUB_ID, TRAN_ID 
-- yielded nearly 200 dupes across two cycles, but these were
-- clearly different transactions (vendors, amounts, etc.)

