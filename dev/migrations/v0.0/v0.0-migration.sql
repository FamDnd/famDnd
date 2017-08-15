-- Set the @now variable to be the current date/time rounded down to the nearest hour
SET time_zone='America/Toronto';

CREATE TABLE `timeslots` (
    `TimeslotID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `TimeslotName` varchar(256) NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`TimeslotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `timeslots` (`TimeslotID`, `TimeslotName`) VALUES
    (1, 'Afternoon'),
    (2, 'Evening'),
    (3, 'Late Night');

CREATE TABLE `users` (
    `UserID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `GroupeMeUserID` varchar(128) NOT NULL,
    `MaximumSesstionsPerWeekCount` int(11) unsigned NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`UserID`),
    UNIQUE KEY `key-unique-groupMeUserId` (`GroupeMeUserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `userAvailablities` (
    `UserAvailabilityID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `UserID` int(11) unsigned NOT NULL,
    `UserAvailabilityDate` timestamp NOT NULL,
    `TimeslotID` int(11) unsigned NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`UserAvailabilityID`),
    KEY `key-userId` (`UserID`),
    KEY `key-timeslotId` (`TimeslotID`),
    CONSTRAINT `fk-userAvailablities-users-1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
    CONSTRAINT `fk-userAvailablities-timeslots-2` FOREIGN KEY (`TimeslotID`) REFERENCES `timeslots` (`TimeslotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `campaignRoles` (
    `CampaignRoleID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `CampaignRoleName` varchar(256) NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`CampaignRoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `campaignRoles` (`CampaignRoleID`, `CampaignRoleName`) VALUES
    (1, 'Dungeon Master'),
    (2, 'Player');

CREATE TABLE `campaigns` (
    `CampaignID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `CampaignName` varchar(256) NOT NULL,
    `Description` text NOT NULL DEFAULT '',
    `GroupeMeGroupID` varchar(128) DEFAULT NULL,
    `DateLastPlayed` timestamp DEFAULT '0000-00-00 00:00:00',
    `MaximumAllowedPlayerAbsensesCount` int(11) unsigned NOT NULL,
    `IsComplete` tinyint(1) unsigned NOT NULL DEFAULT '0',
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`CampaignID`),
    KEY `key-groupMeGroupId` (`GroupeMeGroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `userCampaignRoles` (
    `UserCampaignRoleID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `UserID` int(11) unsigned NOT NULL,
    `CampaignID` int(11) unsigned NOT NULL,
    `CampaignRoleID` int(11) unsigned NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`UserCampaignRoleID`),
    UNIQUE KEY `key-unique-userId-campaignId` (`UserID`,`CampaignID`),
    KEY `key-userId` (`UserID`),
    KEY `key-campaignId` (`CampaignID`),
    KEY `key-campaignRoleId` (`CampaignRoleID`),
    CONSTRAINT `fk-userCampaignRoles-users-1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
    CONSTRAINT `fk-userCampaignRoles-campaigns-1` FOREIGN KEY (`CampaignID`) REFERENCES `campaigns` (`CampaignID`),
    CONSTRAINT `fk-userCampaignRoles-campaignRoles-1` FOREIGN KEY (`CampaignRoleID`) REFERENCES `campaignRoles` (`CampaignRoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `campaignSessionStatuses` (
    `CampaignSessionStatusID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `CampaignSessionStatusName` varchar(256) NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`CampaignSessionStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `campaignSessionStatuses` (`CampaignSessionStatusID`, `CampaignSessionStatusName`) VALUES
    (1, 'Recommended'),
    (2, 'Scheduled'),
    (3, 'Complete');

CREATE TABLE `campaignSessions` (
    `CampaignSessionID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `CampaignID` int(11) unsigned NOT NULL,
    `CampaignSessionDate`  timestamp NOT NULL,
    `TimeslotID` int(11) unsigned NOT NULL,
    `CampaignSessionStatusID` int(11) unsigned NOT NULL,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`CampaignSessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*

CREATE TABLE `tableName` (
    `PrimaryKeyID` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`PrimaryKeyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

*/