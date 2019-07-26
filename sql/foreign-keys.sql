-- MySQL Workbench Synchronization
-- Generated: 2019-07-14 14:50
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Kevin F Cullen

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';



-- ADD FOREIGN KEYS AND RELEVANT INDEXES

-- -----------------------------------------------------
-- TABLE `candidate_all`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`candidate_all` 
ADD CONSTRAINT `fk_candidate_all_candidate_master_idx`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`);
ALTER TABLE `campaign_finance`.`candidate_all` 
ADD INDEX `fk_candidate_all_candidate_master_idx_idx` (`CAND_ID` ASC) VISIBLE;
;

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`candidate_all` 
    DROP FOREIGN KEY `fk_candidate_all_candidate_master_idx`;




-- -----------------------------------------------------
-- TABLE `committee_master`
-- -----------------------------------------------------
-- Add foreign keys

  ALTER TABLE `campaign_finance`.`committee_master` 
ADD CONSTRAINT `fk_committee_master_candidate_master1`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`);

-- Some committee_master.CAND_ID values are not in candidate_master
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`campaign_finance`.`#sql-5c07_e`, CONSTRAINT `fk_committee_master_candidate_master1` FOREIGN KEY (`CAND_ID`) REFERENCES `candidate_master` (`CAND_ID`))

ALTER TABLE `campaign_finance`.`committee_master` 
-- CHANGE COLUMN `CMTE_ST1` `CMTE_ST1` VARCHAR(34) NULL DEFAULT NULL,
-- CHANGE COLUMN `CMTE_ZIP` `CMTE_ZIP` VARCHAR(9) NULL DEFAULT NULL,
ADD INDEX `fk_committee_master_candidate_master_idx` (`CAND_ID` ASC) VISIBLE
;


-- Drop foreign keys
ALTER TABLE `campaign_finance`.`committee_master` 
    DROP FOREIGN KEY `fk_committee_master_candidate_master1`;



-- -----------------------------------------------------
-- TABLE `candidate_committee`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`candidate_committee` 
/*
Some candidate_committee.CAND_ID values are not in candidate_master

ADD CONSTRAINT `fk_candidate_committee_candidate_master1`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`),
  
Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`campaign_finance`.`#sql-5c07_e`, CONSTRAINT `fk_candidate_committee_candidate_master1` FOREIGN KEY (`CAND_ID`) REFERENCES `candidate_master` (`CAND_ID`))


*/
ADD CONSTRAINT `fk_candidate_committee_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`);
/*
This didn't work, either...
ALTER TABLE `campaign_finance`.`candidate_committee` 
ADD CONSTRAINT `fk_candidate_committee_HSCC_1`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`fed_current_campaign_summary` (`CAND_ID`);
*/
ALTER TABLE `campaign_finance`.`candidate_committee` 
/* MODIFY COLUMN `CAND_ELECTION_YR` SMALLINT(6) NOT NULL,
MODIFY COLUMN `FEC_ELECTION_YR` SMALLINT(6) NOT NULL, */
ADD INDEX `fk_candidate_committee_candidate_master1_idx` (`CAND_ID` ASC) VISIBLE,
ADD INDEX `fk_candidate_committee_committee_master1_idx` (`CMTE_ID` ASC) VISIBLE;
;


-- Drop foreign keys
ALTER TABLE `campaign_finance`.`candidate_committee` 
    DROP FOREIGN KEY `fk_candidate_committee_committee_master1`,
    DROP FOREIGN KEY `fk_candidate_committee_candidate_master1`;

-- -----------------------------------------------------
-- TABLE `contrib_cmte_2_cand`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`contrib_cmte_2_cand` 
ADD CONSTRAINT `fk_contrib_cmte_2_cand_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`);

-- Fails because some contrib_cmte_2_can.CAND_ID values are missing from candidate_master;
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`campaign_finance`.`#sql-1471b_17`, CONSTRAINT `fk_contrib_cmte_2_cand_candidate_master1` FOREIGN KEY (`CAND_ID`) REFERENCES `candidate_master` (`CAND_ID`))
/*
    ALTER TABLE `campaign_finance`.`contrib_cmte_2_cand` 
    ADD CONSTRAINT `fk_contrib_cmte_2_cand_candidate_master1`
      FOREIGN KEY (`CAND_ID`)
      REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`);
*/

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`contrib_cmte_2_cand` 
    DROP FOREIGN KEY `fk_contrib_cmte_2_cand_committee_master1`;

-- -----------------------------------------------------
-- TABLE `trans_among_cmte`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`trans_among_cmte` 
ADD CONSTRAINT `fk_trans_among_cmte_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`);
ALTER TABLE `campaign_finance`.`trans_among_cmte` 
ADD INDEX `fk_trans_among_cmte_committee_master1_idx` (`CMTE_ID` ASC) VISIBLE;
;

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`trans_among_cmte` 
    DROP FOREIGN KEY `fk_trans_among_cmte_committee_master1`;    
    
-- -----------------------------------------------------
-- TABLE `fed_current_campaign_summary`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`fed_current_campaign_summary` 
ADD CONSTRAINT `fk_fed_current_campaign_summary_candidate_master1_idx`
  FOREIGN KEY (`CAND_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`);
ALTER TABLE `campaign_finance`.`fed_current_campaign_summary` 
ADD INDEX `fk_fed_current_campaign_summary_candidate_master1_idx_idx` (`CAND_ID` ASC) VISIBLE;
;

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`fed_current_campaign_summary` 
    DROP FOREIGN KEY `fk_fed_current_campaign_summary_candidate_master1_idx`;


-- -----------------------------------------------------
-- TABLE `contrib_indiv_2_cmte`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`contrib_indiv_2_cmte` 
ADD CONSTRAINT `fk_contrib_indiv_2_cmte_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`)
/* , ADD CONSTRAINT `fk_contrib_indiv_2_cmte_candidate_master1`
  FOREIGN KEY (`OTHER_ID`)
  REFERENCES `campaign_finance`.`candidate_master` (`CAND_ID`)
  */
  ;
ALTER TABLE `campaign_finance`.`contrib_indiv_2_cmte` 
ADD INDEX `fk_contrib_indiv_2_cmte_committee_master1_idx` (`CMTE_ID` ASC) VISIBLE
-- , ADD INDEX `fk_contrib_indiv_2_cmte_candidate_master1_idx` (`OTHER_ID` ASC) VISIBLE;
;

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`contrib_indiv_2_cmte` 
    DROP FOREIGN KEY `fk_contrib_indiv_2_cmte_committee_master1`,
    DROP FOREIGN KEY `fk_contrib_indiv_2_cmte_candidate_master1`;

-- -----------------------------------------------------
-- TABLE `operating_expenditure`
-- -----------------------------------------------------
-- Add foreign keys

ALTER TABLE `campaign_finance`.`operating_expenditure` 
ADD CONSTRAINT `fk_operating_expenditure_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
ALTER TABLE `campaign_finance`.`operating_expenditures` 
ADD INDEX `fk_operating_expenditures_committee_master1_idx` (`CMTE_ID` ASC) VISIBLE;
;

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`operating_expenditure` 
    DROP FOREIGN KEY `fk_operating_expenditure_committee_master1`;

-- -----------------------------------------------------
-- TABLE `pac_party_summary`
-- -----------------------------------------------------
-- Add foreign keys
ALTER TABLE `campaign_finance`.`pac_party_summary` 
ADD CONSTRAINT `fk_pac_party_summary_committee_master1`
  FOREIGN KEY (`CMTE_ID`)
  REFERENCES `campaign_finance`.`committee_master` (`CMTE_ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
ALTER TABLE `campaign_finance`.`pac_party_summary` 
ADD INDEX `fk_pac_party_summary_committee_master1_idx` (`CMTE_ID` ASC) VISIBLE;
;

-- Drop foreign keys
ALTER TABLE `campaign_finance`.`pac_party_summary` 
    DROP FOREIGN KEY `fk_pac_party_summary_committee_master1`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
