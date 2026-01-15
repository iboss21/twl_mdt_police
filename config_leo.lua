--[[============================================
    LEO-CORE Configuration
    RedM Law Enforcement System
    Framework: RSG-Core, LXR-Core, VORP
============================================]]--

Config = Config or {}

-- ============================================
-- FRAMEWORK SETTINGS
-- ============================================
Config.Framework = "rsg-core" -- Options: "rsg-core", "lxr-core", "vorp"

-- ============================================
-- COMMAND SETTINGS
-- ============================================
Config.Commands = {
    mdt = "mdt",           -- Open MDT
    duty = "duty",         -- Toggle duty status
    cuff = "cuff",         -- Cuff suspect
    uncuff = "uncuff",     -- Uncuff suspect
    escort = "escort",     -- Escort player
    jail = "jail",         -- Jail player
    unjail = "unjail",     -- Release from jail
}

-- ============================================
-- AGENCY CONFIGURATION
-- ============================================
Config.Agencies = {
    sheriff = {
        label = "Sheriff's Department",
        shortLabel = "Sheriff",
        jurisdiction = {"valentine", "strawberry", "rhodes", "armadillo", "tumbleweed"},
        allowedJobs = {"sheriff"},
        color = "#8B4513",
        badge = "ui/badges/sheriff.png"
    },
    police = {
        label = "Police Department",
        shortLabel = "Police",
        jurisdiction = {"saint_denis", "blackwater"},
        allowedJobs = {"police"},
        color = "#1E3A8A",
        badge = "ui/badges/police.png"
    },
    marshal = {
        label = "U.S. Marshal Service",
        shortLabel = "Marshal",
        jurisdiction = {"all"}, -- State-wide jurisdiction
        allowedJobs = {"marshal"},
        color = "#6B7280",
        badge = "ui/badges/marshal.png"
    },
    ranger = {
        label = "Park Rangers",
        shortLabel = "Ranger",
        jurisdiction = {"wilderness", "parks"},
        allowedJobs = {"ranger"},
        color = "#059669",
        badge = "ui/badges/ranger.png"
    },
    army = {
        label = "U.S. Army",
        shortLabel = "Army",
        jurisdiction = {"military_zones"},
        allowedJobs = {"army"},
        color = "#4B5563",
        badge = "ui/badges/army.png",
        restricted = true -- Requires special permission
    }
}

-- ============================================
-- RANK CONFIGURATION
-- ============================================
Config.Ranks = {
    -- Rank 0
    ["cadet"] = {
        label = "Cadet",
        grade = 0,
        pay = 10,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_own_reports = true,
            mdt_view_warrants = true,
            arrest = true,
            detain = true,
            search = false,
            supervise = false,
            approve_warrants = false,
            manage_officers = false,
            internal_affairs = false
        }
    },
    -- Rank 1
    ["deputy"] = {
        label = "Deputy / Officer",
        grade = 1,
        pay = 15,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_own_reports = true,
            mdt_view_warrants = true,
            mdt_create_warrants = true,
            arrest = true,
            detain = true,
            search = true,
            supervise = false,
            approve_warrants = false,
            manage_officers = false,
            internal_affairs = false
        }
    },
    -- Rank 2
    ["senior"] = {
        label = "Senior Officer",
        grade = 2,
        pay = 20,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_reports = true,
            mdt_view_warrants = true,
            mdt_create_warrants = true,
            mdt_edit_warrants = true,
            arrest = true,
            detain = true,
            search = true,
            supervise = true,
            approve_warrants = false,
            manage_officers = false,
            internal_affairs = false
        }
    },
    -- Rank 3
    ["sergeant"] = {
        label = "Sergeant",
        grade = 3,
        pay = 25,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_reports = true,
            mdt_delete_reports = true,
            mdt_view_warrants = true,
            mdt_create_warrants = true,
            mdt_edit_warrants = true,
            mdt_delete_warrants = true,
            arrest = true,
            detain = true,
            search = true,
            supervise = true,
            approve_warrants = true,
            manage_officers = false,
            internal_affairs = false
        }
    },
    -- Rank 4
    ["lieutenant"] = {
        label = "Lieutenant",
        grade = 4,
        pay = 30,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_reports = true,
            mdt_delete_reports = true,
            mdt_view_warrants = true,
            mdt_create_warrants = true,
            mdt_edit_warrants = true,
            mdt_delete_warrants = true,
            mdt_view_bolos = true,
            mdt_create_bolos = true,
            arrest = true,
            detain = true,
            search = true,
            supervise = true,
            approve_warrants = true,
            manage_officers = true,
            internal_affairs = false
        }
    },
    -- Rank 5
    ["captain"] = {
        label = "Captain",
        grade = 5,
        pay = 35,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_reports = true,
            mdt_delete_reports = true,
            mdt_view_warrants = true,
            mdt_create_warrants = true,
            mdt_edit_warrants = true,
            mdt_delete_warrants = true,
            mdt_view_bolos = true,
            mdt_create_bolos = true,
            mdt_edit_bolos = true,
            arrest = true,
            detain = true,
            search = true,
            supervise = true,
            approve_warrants = true,
            manage_officers = true,
            internal_affairs = true
        }
    },
    -- Rank 6
    ["chief"] = {
        label = "Chief / Sheriff",
        grade = 6,
        pay = 40,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            mdt_view_reports = true,
            mdt_edit_reports = true,
            mdt_delete_reports = true,
            mdt_view_warrants = true,
            mdt_create_warrants = true,
            mdt_edit_warrants = true,
            mdt_delete_warrants = true,
            mdt_view_bolos = true,
            mdt_create_bolos = true,
            mdt_edit_bolos = true,
            mdt_delete_bolos = true,
            arrest = true,
            detain = true,
            search = true,
            supervise = true,
            approve_warrants = true,
            manage_officers = true,
            internal_affairs = true,
            full_admin = true
        }
    }
}

-- ============================================
-- CHARGES & LAW BOOK
-- ============================================
Config.Charges = {
    -- Category 0: Capital Crimes
    {
        id = "murder",
        label = "Murder",
        category = 0,
        severity = "critical",
        jailTime = {min = 180, max = 300}, -- minutes
        fine = {min = 500, max = 1000},
        bailEligible = false,
        stackable = true,
        description = "Unlawful killing with malice aforethought"
    },
    {
        id = "attempted_murder",
        label = "Attempted Murder",
        category = 0,
        severity = "high",
        jailTime = {min = 120, max = 200},
        fine = {min = 400, max = 800},
        bailEligible = false,
        stackable = true,
        description = "Attempted unlawful killing"
    },
    {
        id = "manslaughter",
        label = "Manslaughter",
        category = 0,
        severity = "high",
        jailTime = {min = 100, max = 180},
        fine = {min = 300, max = 600},
        bailEligible = true,
        stackable = true,
        description = "Unlawful killing without malice"
    },
    {
        id = "assault_officer_deadly",
        label = "Assault on Peace Officer with Deadly Weapon",
        category = 0,
        severity = "critical",
        jailTime = {min = 120, max = 200},
        fine = {min = 400, max = 800},
        bailEligible = false,
        stackable = true,
        description = "Assault on law enforcement with deadly weapon"
    },
    
    -- Category 1: Violent Crimes
    {
        id = "assault_deadly",
        label = "Assault with Deadly Weapon",
        category = 1,
        severity = "high",
        jailTime = {min = 60, max = 120},
        fine = {min = 200, max = 400},
        bailEligible = true,
        stackable = true,
        description = "Assault causing bodily harm with weapon"
    },
    {
        id = "assault",
        label = "Assault & Battery",
        category = 1,
        severity = "medium",
        jailTime = {min = 30, max = 60},
        fine = {min = 100, max = 200},
        bailEligible = true,
        stackable = true,
        description = "Physical assault on another person"
    },
    {
        id = "kidnapping",
        label = "Kidnapping/Hostage Taking",
        category = 1,
        severity = "critical",
        jailTime = {min = 100, max = 180},
        fine = {min = 400, max = 800},
        bailEligible = false,
        stackable = true,
        description = "Unlawful detention of person against will"
    },
    
    -- Category 2: Property Crimes
    {
        id = "robbery",
        label = "Robbery",
        category = 2,
        severity = "high",
        jailTime = {min = 60, max = 120},
        fine = {min = 200, max = 500},
        bailEligible = true,
        stackable = true,
        description = "Taking property by force or threat"
    },
    {
        id = "burglary",
        label = "Burglary",
        category = 2,
        severity = "medium",
        jailTime = {min = 40, max = 80},
        fine = {min = 150, max = 300},
        bailEligible = true,
        stackable = true,
        description = "Unlawful entry with intent to commit crime"
    },
    {
        id = "grand_theft",
        label = "Grand Theft",
        category = 2,
        severity = "medium",
        jailTime = {min = 30, max = 60},
        fine = {min = 100, max = 250},
        bailEligible = true,
        stackable = true,
        description = "Theft of property exceeding $100 value"
    },
    {
        id = "petty_theft",
        label = "Petty Theft",
        category = 2,
        severity = "low",
        jailTime = {min = 10, max = 30},
        fine = {min = 50, max = 100},
        bailEligible = true,
        stackable = true,
        description = "Theft of property under $100 value"
    },
    {
        id = "horse_theft",
        label = "Horse Theft",
        category = 2,
        severity = "high",
        jailTime = {min = 50, max = 100},
        fine = {min = 200, max = 400},
        bailEligible = true,
        stackable = true,
        description = "Theft of horse or livestock"
    },
    
    -- Category 3: Public Order
    {
        id = "disturbing_peace",
        label = "Disturbing the Peace",
        category = 3,
        severity = "low",
        jailTime = {min = 5, max = 15},
        fine = {min = 20, max = 50},
        bailEligible = true,
        stackable = true,
        description = "Creating public disturbance"
    },
    {
        id = "public_intoxication",
        label = "Public Intoxication",
        category = 3,
        severity = "low",
        jailTime = {min = 5, max = 10},
        fine = {min = 15, max = 30},
        bailEligible = true,
        stackable = false,
        description = "Being intoxicated in public space"
    },
    {
        id = "trespassing",
        label = "Criminal Trespassing",
        category = 3,
        severity = "low",
        jailTime = {min = 10, max = 30},
        fine = {min = 30, max = 75},
        bailEligible = true,
        stackable = true,
        description = "Unlawful entry onto private property"
    },
    {
        id = "vandalism",
        label = "Vandalism",
        category = 3,
        severity = "low",
        jailTime = {min = 15, max = 40},
        fine = {min = 50, max = 150},
        bailEligible = true,
        stackable = true,
        description = "Willful destruction of property"
    },
    
    -- Category 4: Weapons Offenses
    {
        id = "illegal_discharge",
        label = "Illegal Discharge of Firearm",
        category = 4,
        severity = "medium",
        jailTime = {min = 20, max = 45},
        fine = {min = 75, max = 150},
        bailEligible = true,
        stackable = true,
        description = "Firing weapon within city limits"
    },
    {
        id = "brandishing",
        label = "Brandishing a Weapon",
        category = 4,
        severity = "low",
        jailTime = {min = 10, max = 30},
        fine = {min = 50, max = 100},
        bailEligible = true,
        stackable = true,
        description = "Displaying weapon in threatening manner"
    },
    
    -- Category 5: Drug/Contraband Offenses
    {
        id = "drug_trafficking",
        label = "Drug Trafficking",
        category = 5,
        severity = "high",
        jailTime = {min = 80, max = 150},
        fine = {min = 300, max = 600},
        bailEligible = true,
        stackable = true,
        description = "Sale or distribution of controlled substances"
    },
    {
        id = "drug_possession",
        label = "Drug Possession",
        category = 5,
        severity = "medium",
        jailTime = {min = 20, max = 50},
        fine = {min = 100, max = 200},
        bailEligible = true,
        stackable = true,
        description = "Possession of controlled substances"
    },
    {
        id = "drug_manufacturing",
        label = "Drug Manufacturing",
        category = 5,
        severity = "high",
        jailTime = {min = 60, max = 120},
        fine = {min = 200, max = 500},
        bailEligible = true,
        stackable = true,
        description = "Production of controlled substances"
    },
    
    -- Category 6: Interference with Law Enforcement
    {
        id = "evading",
        label = "Evading Arrest",
        category = 6,
        severity = "high",
        jailTime = {min = 40, max = 80},
        fine = {min = 150, max = 300},
        bailEligible = true,
        stackable = true,
        description = "Fleeing from law enforcement"
    },
    {
        id = "resisting",
        label = "Resisting Arrest",
        category = 6,
        severity = "medium",
        jailTime = {min = 30, max = 60},
        fine = {min = 100, max = 200},
        bailEligible = true,
        stackable = true,
        description = "Physical resistance to lawful arrest"
    },
    {
        id = "obstruction",
        label = "Obstruction of Justice",
        category = 6,
        severity = "medium",
        jailTime = {min = 25, max = 50},
        fine = {min = 75, max = 150},
        bailEligible = true,
        stackable = true,
        description = "Interfering with law enforcement duties"
    },
    {
        id = "false_report",
        label = "Filing False Report",
        category = 6,
        severity = "low",
        jailTime = {min = 15, max = 30},
        fine = {min = 50, max = 100},
        bailEligible = true,
        stackable = false,
        description = "Making false statement to law enforcement"
    },
    {
        id = "contempt",
        label = "Contempt of Court",
        category = 6,
        severity = "medium",
        jailTime = {min = 20, max = 40},
        fine = {min = 75, max = 150},
        bailEligible = false,
        stackable = true,
        description = "Disobedience or disrespect of court"
    },
    
    -- Category 7: Fraud & Corruption
    {
        id = "bribery",
        label = "Bribery",
        category = 7,
        severity = "high",
        jailTime = {min = 50, max = 100},
        fine = {min = 200, max = 500},
        bailEligible = true,
        stackable = true,
        description = "Offering payment to influence official"
    },
    {
        id = "fraud",
        label = "Fraud",
        category = 7,
        severity = "medium",
        jailTime = {min = 30, max = 60},
        fine = {min = 100, max = 300},
        bailEligible = true,
        stackable = true,
        description = "Deception for financial gain"
    },
    {
        id = "impersonation",
        label = "Impersonation of Officer",
        category = 7,
        severity = "high",
        jailTime = {min = 60, max = 120},
        fine = {min = 200, max = 400},
        bailEligible = true,
        stackable = false,
        description = "Falsely claiming to be law enforcement"
    },
    
    -- Category 8: Miscellaneous
    {
        id = "poaching",
        label = "Poaching",
        category = 8,
        severity = "low",
        jailTime = {min = 10, max = 30},
        fine = {min = 50, max = 150},
        bailEligible = true,
        stackable = true,
        description = "Illegal hunting or fishing"
    },
    {
        id = "animal_cruelty",
        label = "Animal Cruelty",
        category = 8,
        severity = "medium",
        jailTime = {min = 20, max = 50},
        fine = {min = 75, max = 200},
        bailEligible = true,
        stackable = true,
        description = "Mistreatment of animals"
    },
    {
        id = "loitering",
        label = "Loitering",
        category = 8,
        severity = "low",
        jailTime = {min = 0, max = 10},
        fine = {min = 10, max = 25},
        bailEligible = true,
        stackable = false,
        description = "Remaining in area without lawful purpose"
    },
    {
        id = "warning",
        label = "Verbal Warning",
        category = 8,
        severity = "none",
        jailTime = {min = 0, max = 0},
        fine = {min = 0, max = 0},
        bailEligible = true,
        stackable = false,
        description = "Official warning, no formal charge"
    }
}

-- ============================================
-- MDT SETTINGS
-- ============================================
Config.MDT = {
    enableOfficeLocations = true,
    enableVehicleAccess = true,
    enableTabletItem = false,
    requireDutyForAccess = true,
    
    -- Office terminal locations
    officeLocations = {
        {coords = vector3(-304.10, 829.9, 120.0), agency = "sheriff", label = "Valentine Sheriff"},
        {coords = vector3(-325.81, 819.8, 118.0), agency = "sheriff", label = "Valentine Jail"},
        {coords = vector3(2513.13, -1306.01, 48.95), agency = "police", label = "Saint Denis Police"},
        {coords = vector3(1362.83, -1301.26, 77.77), agency = "marshal", label = "Rhodes Marshal"},
        {coords = vector3(-1810.52, -347.94, 164.65), agency = "sheriff", label = "Strawberry Sheriff"},
    },
    
    -- Search settings
    searchDebounceMs = 500,
    maxSearchResults = 50,
    
    -- Pagination
    reportsPerPage = 25,
    warrantsPerPage = 25,
    recordsPerPage = 25,
}

-- ============================================
-- DUTY SYSTEM
-- ============================================
Config.DutySystem = {
    enableDutyToggle = true,
    requireUniform = false,
    trackDutyTime = true,
    payPerMinute = 0.5,
    
    -- AFK Detection
    afkCheckInterval = 300000, -- 5 minutes
    afkKickTime = 900000, -- 15 minutes
    afkWarningTime = 600000, -- 10 minutes
    
    -- Loadouts by rank
    loadouts = {
        cadet = {
            weapons = {"WEAPON_REVOLVER_CATTLEMAN"},
            items = {"handcuffs", "notebook"}
        },
        deputy = {
            weapons = {"WEAPON_REVOLVER_CATTLEMAN", "WEAPON_REPEATER_CARBINE"},
            items = {"handcuffs", "notebook", "rope"}
        },
        sergeant = {
            weapons = {"WEAPON_REVOLVER_SCHOFIELD", "WEAPON_REPEATER_CARBINE", "WEAPON_SHOTGUN_PUMP"},
            items = {"handcuffs", "notebook", "rope", "lockpick"}
        },
        lieutenant = {
            weapons = {"WEAPON_REVOLVER_SCHOFIELD", "WEAPON_REPEATER_CARBINE", "WEAPON_SHOTGUN_PUMP"},
            items = {"handcuffs", "notebook", "rope", "lockpick", "binoculars"}
        },
        captain = {
            weapons = {"WEAPON_REVOLVER_SCHOFIELD", "WEAPON_REPEATER_CARBINE", "WEAPON_SHOTGUN_PUMP"},
            items = {"handcuffs", "notebook", "rope", "lockpick", "binoculars"}
        },
        chief = {
            weapons = {"WEAPON_REVOLVER_SCHOFIELD", "WEAPON_REPEATER_CARBINE", "WEAPON_SHOTGUN_PUMP"},
            items = {"handcuffs", "notebook", "rope", "lockpick", "binoculars"}
        }
    }
}

-- ============================================
-- ARREST & JAIL SETTINGS
-- ============================================
Config.Jail = {
    jailLocation = vector3(-304.10, 829.9, 120.0), -- Valentine Jail
    releaseLocation = vector3(-275.0, 805.0, 119.0), -- Valentine Release
    
    -- Sentence calculation
    stackCharges = true,
    maxJailTime = 300, -- Maximum jail time in minutes
    minJailTime = 5, -- Minimum jail time in minutes
    
    -- Bail system
    bailEnabled = true,
    bailMultiplier = 2.0, -- Bail = fine * multiplier
    
    -- Early release
    earlyReleaseEnabled = false,
    earlyReleasePercent = 0.75, -- Must serve 75% of sentence
}

-- ============================================
-- BOLO SETTINGS
-- ============================================
Config.BOLO = {
    autoExpire = true,
    defaultExpirationHours = 48,
    notifyOnCreate = true,
    notifyRadius = 0, -- 0 = all officers
}

-- ============================================
-- WEBHOOK SETTINGS
-- ============================================
Config.Webhooks = {
    enabled = true,
    arrestLog = "",
    warrantsLog = "",
    reportsLog = "",
    dutyLog = "",
    iaLog = "",
    auditLog = "",
    color = 3447003, -- Blue
}

-- ============================================
-- NOTIFICATIONS
-- ============================================
Config.Notifications = {
    ["no_permission"] = "You don't have permission to do that.",
    ["not_on_duty"] = "You must be on duty to use this.",
    ["not_leo"] = "You are not a law enforcement officer.",
    ["duty_on"] = "You are now on duty.",
    ["duty_off"] = "You are now off duty.",
    ["mdt_opened"] = "MDT accessed.",
    ["arrested"] = "You have been arrested.",
    ["released"] = "You have been released from custody.",
    ["warrant_created"] = "Warrant has been created.",
    ["warrant_approved"] = "Warrant has been approved.",
    ["warrant_denied"] = "Warrant has been denied.",
    ["report_saved"] = "Report has been saved.",
    ["bolo_created"] = "BOLO has been created.",
    ["person_cuffed"] = "Person has been restrained.",
    ["person_uncuffed"] = "Restraints have been removed.",
}

-- ============================================
-- SECURITY SETTINGS
-- ============================================
Config.Security = {
    enableAuditLog = true,
    enableAntiSpam = true,
    spamCooldown = 3000, -- 3 seconds between actions
    
    -- Rate limits (actions per minute)
    rateLimits = {
        arrests = 5,
        warrants = 3,
        reports = 10,
        searches = 30,
    }
}

-- ============================================
-- DEBUG SETTINGS
-- ============================================
Config.Debug = false

-- Debug logging function (set Config.Debug = true to enable)
function DebugLog(...)
    if Config.Debug then
        local args = {...}
        local message = ""
        for i, v in ipairs(args) do
            message = message .. tostring(v) .. " "
        end
        print("^3[LEO-CORE DEBUG]^7 " .. message)
    end
end
