-- ============================================
-- LEO-CORE Database Schema for RedM
-- Framework: RSG-Core, LXR-Core, VORP
-- ============================================

-- Officers Table - Stores LEO personnel data
CREATE TABLE IF NOT EXISTS `leo_officers` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `charidentifier` INT(11) DEFAULT NULL,
    `firstname` VARCHAR(100) DEFAULT NULL,
    `lastname` VARCHAR(100) DEFAULT NULL,
    `agency` VARCHAR(50) NOT NULL DEFAULT 'sheriff',
    `rank` VARCHAR(50) NOT NULL DEFAULT 'cadet',
    `badge_number` VARCHAR(20) DEFAULT NULL,
    `callsign` VARCHAR(20) DEFAULT NULL,
    `hire_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('active', 'suspended', 'terminated', 'retired') DEFAULT 'active',
    `notes` TEXT DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `badge_number` (`badge_number`),
    KEY `citizenid` (`citizenid`),
    KEY `charidentifier` (`charidentifier`),
    KEY `agency` (`agency`),
    KEY `rank` (`rank`),
    KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Duty Logs - Tracks duty time and activity
CREATE TABLE IF NOT EXISTS `leo_duty_logs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_id` INT(11) NOT NULL,
    `citizenid` VARCHAR(50) NOT NULL,
    `agency` VARCHAR(50) NOT NULL,
    `rank` VARCHAR(50) NOT NULL,
    `duty_start` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `duty_end` TIMESTAMP NULL DEFAULT NULL,
    `total_minutes` INT(11) DEFAULT 0,
    `afk_time` INT(11) DEFAULT 0,
    `actions_taken` INT(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `officer_id` (`officer_id`),
    KEY `citizenid` (`citizenid`),
    KEY `duty_start` (`duty_start`),
    KEY `duty_end` (`duty_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Person Records - Enhanced character profiles
CREATE TABLE IF NOT EXISTS `leo_persons` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) DEFAULT NULL,
    `charidentifier` INT(11) DEFAULT NULL,
    `firstname` VARCHAR(100) DEFAULT NULL,
    `lastname` VARCHAR(100) DEFAULT NULL,
    `dob` VARCHAR(20) DEFAULT NULL,
    `gender` VARCHAR(10) DEFAULT NULL,
    `mugshot_url` VARCHAR(255) DEFAULT NULL,
    `aliases` TEXT DEFAULT NULL,
    `known_affiliations` TEXT DEFAULT NULL,
    `flags` TEXT DEFAULT NULL,
    `notes` TEXT DEFAULT NULL,
    `job_history` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizenid` (`citizenid`),
    KEY `charidentifier` (`charidentifier`),
    KEY `firstname` (`firstname`),
    KEY `lastname` (`lastname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Criminal Records - Full arrest and conviction history
CREATE TABLE IF NOT EXISTS `leo_records` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `person_id` INT(11) NOT NULL,
    `citizenid` VARCHAR(50) NOT NULL,
    `record_type` ENUM('arrest', 'citation', 'warning', 'conviction') NOT NULL,
    `incident_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `charges` TEXT NOT NULL,
    `charges_json` LONGTEXT DEFAULT NULL,
    `arresting_officer` VARCHAR(100) DEFAULT NULL,
    `officer_id` INT(11) DEFAULT NULL,
    `plea` ENUM('guilty', 'not_guilty', 'no_contest', 'pending') DEFAULT 'pending',
    `verdict` ENUM('guilty', 'not_guilty', 'dismissed', 'pending') DEFAULT 'pending',
    `sentence_time` INT(11) DEFAULT 0,
    `sentence_fine` DECIMAL(10,2) DEFAULT 0.00,
    `time_served` INT(11) DEFAULT 0,
    `fine_paid` DECIMAL(10,2) DEFAULT 0.00,
    `bail_amount` DECIMAL(10,2) DEFAULT 0.00,
    `bail_posted` TINYINT(1) DEFAULT 0,
    `notes` TEXT DEFAULT NULL,
    `status` ENUM('active', 'served', 'dismissed') DEFAULT 'active',
    PRIMARY KEY (`id`),
    KEY `person_id` (`person_id`),
    KEY `citizenid` (`citizenid`),
    KEY `record_type` (`record_type`),
    KEY `incident_date` (`incident_date`),
    KEY `officer_id` (`officer_id`),
    KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Warrants - Search and arrest warrants with approval flow
CREATE TABLE IF NOT EXISTS `leo_warrants` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `person_id` INT(11) DEFAULT NULL,
    `citizenid` VARCHAR(50) DEFAULT NULL,
    `charidentifier` INT(11) DEFAULT NULL,
    `name` VARCHAR(200) NOT NULL,
    `warrant_type` ENUM('arrest', 'search') NOT NULL DEFAULT 'arrest',
    `charges` TEXT NOT NULL,
    `charges_json` LONGTEXT DEFAULT NULL,
    `probable_cause` TEXT NOT NULL,
    `issued_by` VARCHAR(100) NOT NULL,
    `issued_by_id` INT(11) DEFAULT NULL,
    `approved_by` VARCHAR(100) DEFAULT NULL,
    `approved_by_id` INT(11) DEFAULT NULL,
    `approval_status` ENUM('pending', 'approved', 'denied') DEFAULT 'pending',
    `issue_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `approval_date` TIMESTAMP NULL DEFAULT NULL,
    `expiration_date` TIMESTAMP NULL DEFAULT NULL,
    `execution_date` TIMESTAMP NULL DEFAULT NULL,
    `executed_by` VARCHAR(100) DEFAULT NULL,
    `executed_by_id` INT(11) DEFAULT NULL,
    `status` ENUM('active', 'executed', 'expired', 'cancelled') DEFAULT 'active',
    `notes` TEXT DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `person_id` (`person_id`),
    KEY `citizenid` (`citizenid`),
    KEY `charidentifier` (`charidentifier`),
    KEY `warrant_type` (`warrant_type`),
    KEY `approval_status` (`approval_status`),
    KEY `status` (`status`),
    KEY `issue_date` (`issue_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Reports - Incident, arrest, and use-of-force reports
CREATE TABLE IF NOT EXISTS `leo_reports` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `report_type` ENUM('incident', 'arrest', 'use_of_force', 'officer_notes') NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `incident_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `report_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `location` VARCHAR(255) DEFAULT NULL,
    `narrative` LONGTEXT NOT NULL,
    `author` VARCHAR(100) NOT NULL,
    `author_id` INT(11) DEFAULT NULL,
    `involved_persons` TEXT DEFAULT NULL,
    `involved_officers` TEXT DEFAULT NULL,
    `charges_filed` TEXT DEFAULT NULL,
    `evidence` TEXT DEFAULT NULL,
    `witnesses` TEXT DEFAULT NULL,
    `use_of_force_level` ENUM('none', 'verbal', 'physical', 'less_lethal', 'lethal') DEFAULT 'none',
    `injuries` TEXT DEFAULT NULL,
    `supervisor_review` TINYINT(1) DEFAULT 0,
    `supervisor_id` INT(11) DEFAULT NULL,
    `reviewed_date` TIMESTAMP NULL DEFAULT NULL,
    `status` ENUM('draft', 'submitted', 'reviewed', 'archived') DEFAULT 'draft',
    PRIMARY KEY (`id`),
    KEY `report_type` (`report_type`),
    KEY `incident_date` (`incident_date`),
    KEY `author_id` (`author_id`),
    KEY `status` (`status`),
    FULLTEXT KEY `search_idx` (`title`, `narrative`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- BOLOs - Be On the Lookout system
CREATE TABLE IF NOT EXISTS `leo_bolos` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `bolo_type` ENUM('person', 'vehicle') NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `person_name` VARCHAR(200) DEFAULT NULL,
    `person_citizenid` VARCHAR(50) DEFAULT NULL,
    `vehicle_plate` VARCHAR(20) DEFAULT NULL,
    `vehicle_model` VARCHAR(100) DEFAULT NULL,
    `priority` ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    `issued_by` VARCHAR(100) NOT NULL,
    `issued_by_id` INT(11) DEFAULT NULL,
    `issue_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expiration_date` TIMESTAMP NULL DEFAULT NULL,
    `status` ENUM('active', 'resolved', 'expired', 'cancelled') DEFAULT 'active',
    `notes` TEXT DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `bolo_type` (`bolo_type`),
    KEY `priority` (`priority`),
    KEY `status` (`status`),
    KEY `vehicle_plate` (`vehicle_plate`),
    KEY `person_citizenid` (`person_citizenid`),
    KEY `expiration_date` (`expiration_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Vehicles - Vehicle records and notes
CREATE TABLE IF NOT EXISTS `leo_vehicles` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `plate` VARCHAR(20) NOT NULL,
    `owner_citizenid` VARCHAR(50) DEFAULT NULL,
    `owner_name` VARCHAR(200) DEFAULT NULL,
    `model` VARCHAR(100) DEFAULT NULL,
    `color` VARCHAR(50) DEFAULT NULL,
    `stolen` TINYINT(1) DEFAULT 0,
    `stolen_date` TIMESTAMP NULL DEFAULT NULL,
    `flags` TEXT DEFAULT NULL,
    `notes` TEXT DEFAULT NULL,
    `last_seen` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`),
    KEY `owner_citizenid` (`owner_citizenid`),
    KEY `stolen` (`stolen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Internal Affairs - Officer complaints and investigations
CREATE TABLE IF NOT EXISTS `leo_internal_affairs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `case_number` VARCHAR(50) NOT NULL,
    `case_type` ENUM('complaint', 'investigation', 'disciplinary') NOT NULL,
    `subject_officer_id` INT(11) NOT NULL,
    `subject_officer_name` VARCHAR(100) NOT NULL,
    `complainant_name` VARCHAR(200) DEFAULT NULL,
    `complainant_citizenid` VARCHAR(50) DEFAULT NULL,
    `allegation` TEXT NOT NULL,
    `incident_date` TIMESTAMP NULL DEFAULT NULL,
    `filed_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `investigating_officer` VARCHAR(100) DEFAULT NULL,
    `investigating_officer_id` INT(11) DEFAULT NULL,
    `findings` TEXT DEFAULT NULL,
    `action_taken` TEXT DEFAULT NULL,
    `status` ENUM('pending', 'investigating', 'sustained', 'not_sustained', 'unfounded', 'closed') DEFAULT 'pending',
    `closed_date` TIMESTAMP NULL DEFAULT NULL,
    `restricted` TINYINT(1) DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `case_number` (`case_number`),
    KEY `subject_officer_id` (`subject_officer_id`),
    KEY `case_type` (`case_type`),
    KEY `status` (`status`),
    KEY `filed_date` (`filed_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Audit Logs - Comprehensive action logging
CREATE TABLE IF NOT EXISTS `leo_audit_logs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_id` INT(11) DEFAULT NULL,
    `citizenid` VARCHAR(50) DEFAULT NULL,
    `action_type` VARCHAR(50) NOT NULL,
    `action_description` TEXT NOT NULL,
    `target_type` VARCHAR(50) DEFAULT NULL,
    `target_id` INT(11) DEFAULT NULL,
    `data_before` LONGTEXT DEFAULT NULL,
    `data_after` LONGTEXT DEFAULT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `officer_id` (`officer_id`),
    KEY `citizenid` (`citizenid`),
    KEY `action_type` (`action_type`),
    KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Evidence Records - Chain of custody and evidence tracking
CREATE TABLE IF NOT EXISTS `leo_evidence` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `report_id` INT(11) DEFAULT NULL,
    `case_number` VARCHAR(50) DEFAULT NULL,
    `evidence_type` ENUM('weapon', 'witness_statement', 'officer_testimony', 'physical', 'document', 'other') NOT NULL,
    `description` TEXT NOT NULL,
    `collected_by` VARCHAR(100) NOT NULL,
    `collected_by_id` INT(11) DEFAULT NULL,
    `collection_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `location_collected` VARCHAR(255) DEFAULT NULL,
    `chain_of_custody` LONGTEXT DEFAULT NULL,
    `status` ENUM('collected', 'processing', 'stored', 'released', 'destroyed') DEFAULT 'collected',
    `notes` TEXT DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `report_id` (`report_id`),
    KEY `case_number` (`case_number`),
    KEY `evidence_type` (`evidence_type`),
    KEY `collected_by_id` (`collected_by_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Jail Records - Intake and release tracking
CREATE TABLE IF NOT EXISTS `leo_jail_records` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `person_id` INT(11) DEFAULT NULL,
    `record_id` INT(11) DEFAULT NULL,
    `intake_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `release_date` TIMESTAMP NULL DEFAULT NULL,
    `sentence_time` INT(11) NOT NULL,
    `time_served` INT(11) DEFAULT 0,
    `fine_amount` DECIMAL(10,2) DEFAULT 0.00,
    `fine_paid` DECIMAL(10,2) DEFAULT 0.00,
    `charges` TEXT NOT NULL,
    `intake_officer` VARCHAR(100) NOT NULL,
    `intake_officer_id` INT(11) DEFAULT NULL,
    `release_officer` VARCHAR(100) DEFAULT NULL,
    `release_officer_id` INT(11) DEFAULT NULL,
    `release_reason` ENUM('time_served', 'bail_posted', 'pardoned', 'released') DEFAULT NULL,
    `status` ENUM('incarcerated', 'released') DEFAULT 'incarcerated',
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `person_id` (`person_id`),
    KEY `record_id` (`record_id`),
    KEY `intake_date` (`intake_date`),
    KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Migrate existing data from old tables (if they exist)
-- This allows for backward compatibility during transition

-- Note: Using INSERT IGNORE to handle potential duplicates during migration
-- If you need to update existing records instead, use:
-- INSERT INTO ... ON DUPLICATE KEY UPDATE ...

-- Migrate person records
INSERT IGNORE INTO `leo_persons` (`charidentifier`, `mugshot_url`, `notes`)
SELECT `char_id`, `mugshot_url`, `notes` FROM `user_mdt` WHERE EXISTS (SELECT 1 FROM `user_mdt`);

-- Migrate reports to records
INSERT IGNORE INTO `leo_records` (
    `citizenid`, 
    `record_type`, 
    `charges`, 
    `arresting_officer`, 
    `incident_date`, 
    `notes`
)
SELECT 
    COALESCE(c.identifier, r.char_id),
    'arrest',
    r.charges,
    r.author,
    STR_TO_DATE(r.date, '%m-%d-%Y %H:%i:%s'),
    r.incident
FROM `mdt_reports` r
LEFT JOIN `characters` c ON c.charidentifier = r.char_id
WHERE EXISTS (SELECT 1 FROM `mdt_reports`);

-- Migrate warrants
INSERT IGNORE INTO `leo_warrants` (
    `charidentifier`,
    `citizenid`,
    `name`,
    `warrant_type`,
    `charges`,
    `probable_cause`,
    `issued_by`,
    `issue_date`,
    `expiration_date`,
    `status`,
    `notes`
)
SELECT 
    w.char_id,
    COALESCE(c.identifier, w.char_id),
    w.name,
    'arrest',
    w.charges,
    COALESCE(w.notes, 'Imported from legacy system'),
    w.author,
    STR_TO_DATE(w.date, '%m-%d-%Y %H:%i:%s'),
    IF(w.expire != '' AND w.expire IS NOT NULL, 
       STR_TO_DATE(w.expire, '%m-%d-%Y %H:%i:%s'), 
       DATE_ADD(STR_TO_DATE(w.date, '%m-%d-%Y %H:%i:%s'), INTERVAL 30 DAY)
    ),
    'active',
    w.notes
FROM `mdt_warrants` w
LEFT JOIN `characters` c ON c.charidentifier = w.char_id
WHERE EXISTS (SELECT 1 FROM `mdt_warrants`);

-- ============================================
-- PERFORMANCE OPTIMIZATION NOTES
-- ============================================
-- For RSG-Core/LXR-Core with large player tables:
-- Consider adding computed columns for frequently searched fields:
-- 
-- ALTER TABLE players 
-- ADD COLUMN firstname VARCHAR(100) 
-- GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname'))) STORED,
-- ADD COLUMN lastname VARCHAR(100) 
-- GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) STORED,
-- ADD INDEX idx_firstname (firstname),
-- ADD INDEX idx_lastname (lastname);
--
-- This improves search performance by avoiding JSON_EXTRACT in WHERE clauses.
