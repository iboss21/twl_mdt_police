--[[============================================
    LEO-CORE Configuration Examples
    Common customization scenarios
============================================]]--

-- This file provides examples for common configuration tasks.
-- Copy snippets to your config_leo.lua as needed.

--[[============================================
    EXAMPLE 1: Single Agency Server
    If you only want one LEO agency
============================================]]--

Config.Agencies = {
    police = {
        label = "Police Department",
        shortLabel = "PD",
        jurisdiction = {"all"}, -- Entire map
        allowedJobs = {"police"},
        color = "#1E3A8A",
        badge = "ui/badges/police.png"
    }
}

--[[============================================
    EXAMPLE 2: Custom Rank Structure
    Creating your own rank names
============================================]]--

Config.Ranks = {
    ["probation"] = {
        label = "Probationary Officer",
        grade = 0,
        pay = 8,
        permissions = {
            mdt_access = true,
            mdt_create_reports = true,
            arrest = false, -- Cannot arrest
            -- ... other permissions
        }
    },
    ["patrolman"] = {
        label = "Patrolman",
        grade = 1,
        pay = 12,
        permissions = {
            mdt_access = true,
            arrest = true,
            -- ... other permissions
        }
    },
    -- Add more ranks...
}

--[[============================================
    EXAMPLE 3: Custom Charges
    Adding server-specific crimes
============================================]]--

-- Add to Config.Charges table:
{
    id = "train_robbery",
    label = "Train Robbery",
    category = 2, -- Property crimes
    severity = "critical",
    jailTime = {min = 120, max = 180},
    fine = {min = 500, max = 1000},
    bailEligible = false,
    stackable = true,
    description = "Robbery of a train"
},
{
    id = "moonshining",
    label = "Illegal Moonshining",
    category = 5, -- Drug/contraband
    severity = "medium",
    jailTime = {min = 30, max = 60},
    fine = {min = 100, max = 300},
    bailEligible = true,
    stackable = true,
    description = "Production of illegal alcohol"
},

--[[============================================
    EXAMPLE 4: Strict Permissions
    Limiting lower ranks significantly
============================================]]--

["cadet"] = {
    permissions = {
        mdt_access = true,
        mdt_view_reports = true, -- Can only VIEW
        mdt_create_reports = false, -- Cannot create
        arrest = false, -- Cannot arrest
        detain = true, -- Can only detain for senior
    }
},

--[[============================================
    EXAMPLE 5: Lenient Jail Times
    Shorter sentences for casual servers
============================================]]--

Config.Jail = {
    maxJailTime = 60, -- Max 1 hour
    minJailTime = 1, -- Min 1 minute
    bailEnabled = true,
    bailMultiplier = 1.5, -- Lower bail
}

-- Adjust charge times:
{
    id = "murder",
    jailTime = {min = 30, max = 60}, -- Reduced from 180-300
    -- ...
},

--[[============================================
    EXAMPLE 6: Strict Jail Times
    Longer sentences for serious RP servers
============================================]]--

Config.Jail = {
    maxJailTime = 600, -- Max 10 hours!
    minJailTime = 15, -- Min 15 minutes
    bailEnabled = false, -- No bail for anyone
}

-- Adjust charge times:
{
    id = "murder",
    jailTime = {min = 300, max = 600}, -- Increased
    -- ...
},

--[[============================================
    EXAMPLE 7: Multiple Jail Locations
    Different jails for different areas
============================================]]--

Config.Jails = {
    valentine = {
        jailLocation = vector3(-304.10, 829.9, 120.0),
        releaseLocation = vector3(-275.0, 805.0, 119.0),
        agencies = {"sheriff"}
    },
    saint_denis = {
        jailLocation = vector3(2513.13, -1306.01, 48.95),
        releaseLocation = vector3(2500.0, -1300.0, 48.0),
        agencies = {"police"}
    },
    -- Add more jails...
}

--[[============================================
    EXAMPLE 8: Custom Loadouts
    Specific weapons for your server
============================================]]--

Config.DutySystem.loadouts = {
    deputy = {
        weapons = {
            "WEAPON_REVOLVER_CATTLEMAN",
            "WEAPON_MELEE_KNIFE",
        },
        items = {
            "handcuffs",
            "notebook",
            "rope",
            "whistle" -- Your custom item
        }
    },
    sergeant = {
        weapons = {
            "WEAPON_REVOLVER_SCHOFIELD",
            "WEAPON_REPEATER_CARBINE",
            "WEAPON_SHOTGUN_PUMP",
            "WEAPON_LASSO" -- For captures
        },
        items = {
            "handcuffs",
            "notebook",
            "rope",
            "binoculars",
            "medkit"
        }
    },
}

--[[============================================
    EXAMPLE 9: Discord Webhook Setup
    Organized logging channels
============================================]]--

Config.Webhooks = {
    enabled = true,
    -- Separate webhooks for organization
    arrestLog = "https://discord.com/api/webhooks/xxx/arrests",
    warrantsLog = "https://discord.com/api/webhooks/xxx/warrants",
    reportsLog = "https://discord.com/api/webhooks/xxx/reports",
    dutyLog = "https://discord.com/api/webhooks/xxx/duty",
    iaLog = "https://discord.com/api/webhooks/xxx/ia", -- High command only
    auditLog = "https://discord.com/api/webhooks/xxx/audit",
    color = 3447003, -- Blue
}

--[[============================================
    EXAMPLE 10: Disable Features
    If you don't want certain modules
============================================]]--

Config.MDT = {
    enableOfficeLocations = false, -- No terminals, command only
    enableVehicleAccess = false, -- No vehicle MDT
    enableTabletItem = false, -- No tablet item
    requireDutyForAccess = true, -- Keep security
}

Config.BOLO = {
    autoExpire = false, -- BOLOs never expire
    notifyOnCreate = false, -- No auto-notifications
}

--[[============================================
    EXAMPLE 11: AFK Settings
    Adjust for your server activity
============================================]]--

-- For active servers (stricter):
Config.DutySystem = {
    afkCheckInterval = 180000, -- Check every 3 minutes
    afkKickTime = 600000, -- Kick after 10 minutes
    afkWarningTime = 300000, -- Warn at 5 minutes
}

-- For casual servers (lenient):
Config.DutySystem = {
    afkCheckInterval = 600000, -- Check every 10 minutes
    afkKickTime = 1800000, -- Kick after 30 minutes
    afkWarningTime = 1200000, -- Warn at 20 minutes
}

-- Disable AFK system entirely:
Config.DutySystem = {
    afkCheckInterval = 0, -- Disabled
}

--[[============================================
    EXAMPLE 12: Custom Commands
    Change command names
============================================]]--

Config.Commands = {
    mdt = "computer", -- Use /computer instead
    duty = "clockin", -- Use /clockin
    cuff = "restrain",
    uncuff = "release",
    escort = "grab",
    jail = "imprison",
    unjail = "free",
}

--[[============================================
    EXAMPLE 13: Jurisdiction System
    Define territories precisely
============================================]]--

Config.Agencies = {
    sheriff = {
        jurisdiction = {
            "valentine",
            "strawberry",
            "rhodes",
            "armadillo",
            "tumbleweed",
            "wilderness" -- Rural areas
        },
    },
    police = {
        jurisdiction = {
            "saint_denis",
            "blackwater",
            -- Only cities
        },
    },
    marshal = {
        jurisdiction = {"all"}, -- State-wide
    },
}

--[[============================================
    EXAMPLE 14: Pay Structure
    Automatic duty pay
============================================]]--

Config.DutySystem = {
    trackDutyTime = true,
    payPerMinute = 1.0, -- $1 per minute = $60/hour
}

-- Adjust rank pay:
["deputy"] = {
    pay = 20, -- Base pay affects loadout value
}

--[[============================================
    EXAMPLE 15: Fine Structure
    Adjust fine amounts globally
============================================]]--

-- Multiply all fines by 2 (more expensive):
for _, charge in ipairs(Config.Charges) do
    if charge.fine then
        charge.fine.min = charge.fine.min * 2
        charge.fine.max = charge.fine.max * 2
    end
end

-- Or set custom fine range:
{
    id = "speeding",
    fine = {min = 5, max = 25}, -- Very cheap
},
{
    id = "murder",
    fine = {min = 2000, max = 5000}, -- Very expensive
},

--[[============================================
    EXAMPLE 16: Report Requirements
    Supervisor review for certain reports
============================================]]--

Config.Reports = {
    requireSupervisorReview = {
        "use_of_force", -- Always requires review
        "officer_involved_shooting",
        "pursuit",
    },
    autoApprove = {
        "incident", -- Auto-approved
        "officer_notes",
    }
}

--[[============================================
    EXAMPLE 17: Warrant Expiration
    Custom warrant lifespans
============================================]]--

Config.Warrants = {
    expirationDays = {
        arrest = 60, -- 60 days for arrest warrants
        search = 7, -- 7 days for search warrants
    }
}

--[[============================================
    EXAMPLE 18: Security Settings
    Adjust anti-abuse measures
============================================]]--

-- Stricter security:
Config.Security = {
    enableAuditLog = true,
    enableAntiSpam = true,
    spamCooldown = 5000, -- 5 seconds between actions
    rateLimits = {
        arrests = 3, -- Max 3 arrests per minute
        warrants = 2,
        reports = 5,
        searches = 20,
    }
}

-- More lenient:
Config.Security = {
    spamCooldown = 1000, -- 1 second
    rateLimits = {
        arrests = 10,
        warrants = 10,
        reports = 20,
        searches = 60,
    }
}

--[[============================================
    EXAMPLE 19: Notification Customization
    Change message text
============================================]]--

Config.Notifications = {
    ["no_permission"] = "Access Denied - Insufficient Rank",
    ["not_on_duty"] = "You must clock in before using this.",
    ["duty_on"] = "Welcome to duty, Officer.",
    ["duty_off"] = "You are now off duty. Stay safe.",
    ["arrested"] = "You have been taken into custody.",
    -- ... customize all notifications
}

--[[============================================
    EXAMPLE 20: MDT Search Settings
    Adjust search behavior
============================================]]--

Config.MDT = {
    searchDebounceMs = 300, -- Faster search (was 500)
    maxSearchResults = 100, -- More results (was 50)
    reportsPerPage = 50, -- More per page (was 25)
}

--[[============================================
    USAGE NOTES
============================================]]--

-- 1. Copy desired examples to config_leo.lua
-- 2. Adjust values to match your server
-- 3. Restart resource to apply changes
-- 4. Test thoroughly
-- 5. Document your changes

-- For more help, see:
-- - README.md (full documentation)
-- - INSTALLATION.md (setup guide)
-- - QUICKSTART.md (quick reference)

-- Remember: Always backup before making changes!
