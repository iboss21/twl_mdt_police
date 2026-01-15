--[[============================================
    LEO-CORE Framework Bridge
    Supports: RSG-Core, LXR-Core, VORP
============================================]]--

FrameworkBridge = {}
FrameworkBridge.Framework = nil
FrameworkBridge.FrameworkName = Config.Framework or "rsg-core"

-- ============================================
-- INITIALIZE FRAMEWORK
-- ============================================
function FrameworkBridge.Init()
    if FrameworkBridge.FrameworkName == "rsg-core" then
        FrameworkBridge.InitRSGCore()
    elseif FrameworkBridge.FrameworkName == "lxr-core" then
        FrameworkBridge.InitLXRCore()
    elseif FrameworkBridge.FrameworkName == "vorp" then
        FrameworkBridge.InitVORP()
    else
        print("^1[LEO-CORE] ERROR: Unknown framework: " .. FrameworkBridge.FrameworkName .. "^7")
    end
end

-- ============================================
-- RSG-CORE INITIALIZATION
-- ============================================
function FrameworkBridge.InitRSGCore()
    FrameworkBridge.Framework = exports['rsg-core']:GetCoreObject()
    print("^2[LEO-CORE] Initialized with RSG-Core^7")
end

-- ============================================
-- LXR-CORE INITIALIZATION
-- ============================================
function FrameworkBridge.InitLXRCore()
    FrameworkBridge.Framework = exports['lxr-core']:GetCoreObject()
    print("^2[LEO-CORE] Initialized with LXR-Core^7")
end

-- ============================================
-- VORP INITIALIZATION
-- ============================================
function FrameworkBridge.InitVORP()
    TriggerEvent("getCore", function(core)
        FrameworkBridge.Framework = core
    end)
    print("^2[LEO-CORE] Initialized with VORP^7")
end

-- ============================================
-- GET PLAYER DATA
-- ============================================
function FrameworkBridge.GetPlayer(source)
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return FrameworkBridge.Framework.Functions.GetPlayer(source)
    elseif FrameworkBridge.FrameworkName == "vorp" then
        return FrameworkBridge.Framework.getUser(source)
    end
end

-- ============================================
-- GET PLAYER IDENTIFIER
-- ============================================
function FrameworkBridge.GetIdentifier(source)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return nil end
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return Player.PlayerData.citizenid
    elseif FrameworkBridge.FrameworkName == "vorp" then
        return Player.getIdentifier()
    end
end

-- ============================================
-- GET CHARACTER DATA
-- ============================================
function FrameworkBridge.GetCharacter(source)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return nil end
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return Player.PlayerData
    elseif FrameworkBridge.FrameworkName == "vorp" then
        return Player.getUsedCharacter
    end
end

-- ============================================
-- GET CHARACTER NAME
-- ============================================
function FrameworkBridge.GetCharacterName(source)
    local Character = FrameworkBridge.GetCharacter(source)
    if not Character then return "Unknown" end
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return Character.charinfo.firstname .. " " .. Character.charinfo.lastname
    elseif FrameworkBridge.FrameworkName == "vorp" then
        return Character.firstname .. " " .. Character.lastname
    end
end

-- ============================================
-- GET JOB
-- ============================================
function FrameworkBridge.GetJob(source)
    local Character = FrameworkBridge.GetCharacter(source)
    if not Character then return nil, nil end
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return Character.job.name, Character.job.grade.level
    elseif FrameworkBridge.FrameworkName == "vorp" then
        return Character.job, Character.jobGrade
    end
end

-- ============================================
-- CHECK IF PLAYER IS LEO
-- ============================================
function FrameworkBridge.IsLEO(source)
    local job, grade = FrameworkBridge.GetJob(source)
    
    for agencyName, agencyData in pairs(Config.Agencies) do
        for _, allowedJob in ipairs(agencyData.allowedJobs) do
            if job == allowedJob then
                return true, agencyName, job, grade
            end
        end
    end
    
    return false, nil, nil, nil
end

-- ============================================
-- GET AGENCY FOR JOB
-- ============================================
function FrameworkBridge.GetAgency(job)
    for agencyName, agencyData in pairs(Config.Agencies) do
        for _, allowedJob in ipairs(agencyData.allowedJobs) do
            if job == allowedJob then
                return agencyName
            end
        end
    end
    return nil
end

-- ============================================
-- SEND NOTIFICATION
-- ============================================
function FrameworkBridge.Notify(source, message, type)
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        TriggerClientEvent('RSGCore:Notify', source, message, type or 'primary')
    elseif FrameworkBridge.FrameworkName == "vorp" then
        TriggerClientEvent("vorp:TipRight", source, message, 3000)
    end
end

-- ============================================
-- ADD MONEY
-- ============================================
function FrameworkBridge.AddMoney(source, amount, moneyType)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return false end
    
    moneyType = moneyType or "cash"
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        Player.Functions.AddMoney(moneyType, amount)
        return true
    elseif FrameworkBridge.FrameworkName == "vorp" then
        local Character = Player.getUsedCharacter
        Character.addCurrency(0, amount) -- 0 = cash
        return true
    end
    
    return false
end

-- ============================================
-- REMOVE MONEY
-- ============================================
function FrameworkBridge.RemoveMoney(source, amount, moneyType)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return false end
    
    moneyType = moneyType or "cash"
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        Player.Functions.RemoveMoney(moneyType, amount)
        return true
    elseif FrameworkBridge.FrameworkName == "vorp" then
        local Character = Player.getUsedCharacter
        Character.removeCurrency(0, amount) -- 0 = cash
        return true
    end
    
    return false
end

-- ============================================
-- GET MONEY
-- ============================================
function FrameworkBridge.GetMoney(source, moneyType)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return 0 end
    
    moneyType = moneyType or "cash"
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return Player.PlayerData.money[moneyType] or 0
    elseif FrameworkBridge.FrameworkName == "vorp" then
        local Character = Player.getUsedCharacter
        return Character.money or 0
    end
    
    return 0
end

-- ============================================
-- ADD ITEM
-- ============================================
function FrameworkBridge.AddItem(source, item, amount)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return false end
    
    amount = amount or 1
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        Player.Functions.AddItem(item, amount)
        return true
    elseif FrameworkBridge.FrameworkName == "vorp" then
        local Character = Player.getUsedCharacter
        exports.vorp_inventory:addItem(source, item, amount)
        return true
    end
    
    return false
end

-- ============================================
-- REMOVE ITEM
-- ============================================
function FrameworkBridge.RemoveItem(source, item, amount)
    local Player = FrameworkBridge.GetPlayer(source)
    if not Player then return false end
    
    amount = amount or 1
    
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        Player.Functions.RemoveItem(item, amount)
        return true
    elseif FrameworkBridge.FrameworkName == "vorp" then
        exports.vorp_inventory:subItem(source, item, amount)
        return true
    end
    
    return false
end

-- ============================================
-- GET RANK DATA
-- ============================================
function FrameworkBridge.GetRankData(rankName)
    return Config.Ranks[rankName] or Config.Ranks["cadet"]
end

-- ============================================
-- CHECK PERMISSION
-- ============================================
function FrameworkBridge.HasPermission(source, permission)
    local isLEO, agency, job, grade = FrameworkBridge.IsLEO(source)
    if not isLEO then return false end
    
    -- Get rank name from grade (this is simplified, should map grade to rank)
    local rankName = "cadet"
    for rank, rankData in pairs(Config.Ranks) do
        if rankData.grade == grade then
            rankName = rank
            break
        end
    end
    
    local rankData = FrameworkBridge.GetRankData(rankName)
    return rankData.permissions[permission] or false
end

-- ============================================
-- GET ALL PLAYERS
-- ============================================
function FrameworkBridge.GetPlayers()
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        return FrameworkBridge.Framework.Functions.GetPlayers()
    elseif FrameworkBridge.FrameworkName == "vorp" then
        return FrameworkBridge.Framework.getUsers()
    end
    return {}
end

-- ============================================
-- SEARCH CHARACTERS
-- ============================================
function FrameworkBridge.SearchCharacters(query, callback)
    if FrameworkBridge.FrameworkName == "rsg-core" or FrameworkBridge.FrameworkName == "lxr-core" then
        local paramQuery = string.lower('%' .. query .. '%')
        MySQL.Async.fetchAll([[
            SELECT charinfo, citizenid, cid 
            FROM players 
            WHERE LOWER(JSON_EXTRACT(charinfo, '$.firstname')) LIKE @query 
            OR LOWER(JSON_EXTRACT(charinfo, '$.lastname')) LIKE @query
            LIMIT 50
        ]], {
            ['@query'] = paramQuery
        }, function(result)
            local matches = {}
            for _, data in ipairs(result) do
                local charinfo = json.decode(data.charinfo)
                table.insert(matches, {
                    citizenid = data.citizenid,
                    charidentifier = data.cid,
                    firstname = charinfo.firstname,
                    lastname = charinfo.lastname,
                    dob = charinfo.birthdate or charinfo.dob,
                    gender = charinfo.gender
                })
            end
            callback(matches)
        end)
    elseif FrameworkBridge.FrameworkName == "vorp" then
        MySQL.Async.fetchAll([[
            SELECT * FROM characters 
            WHERE LOWER(firstname) LIKE @query 
            OR LOWER(lastname) LIKE @query 
            OR CONCAT(LOWER(firstname), ' ', LOWER(lastname)) LIKE @query
            LIMIT 50
        ]], {
            ['@query'] = string.lower('%' .. query .. '%')
        }, function(result)
            callback(result)
        end)
    end
end

return FrameworkBridge
