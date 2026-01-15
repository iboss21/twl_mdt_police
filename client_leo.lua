--[[============================================
    LEO-CORE Client
    Client-side logic for LEO system
============================================]]--

local isOnDuty = false
local isMDTOpen = false
local isCuffed = false
local isEscorted = false

-- ============================================
-- DUTY STATUS
-- ============================================

RegisterNetEvent('leo:client:dutyStatus')
AddEventHandler('leo:client:dutyStatus', function(status)
    isOnDuty = status
    
    -- Update UI
    SendNUIMessage({
        type = "dutyStatus",
        status = status
    })
end)

-- ============================================
-- MDT SYSTEM
-- ============================================

-- Open MDT
RegisterNetEvent('leo:client:openMDT')
AddEventHandler('leo:client:openMDT', function(data)
    if isMDTOpen then return end
    
    isMDTOpen = true
    SetNuiFocus(true, true)
    
    -- Play animation
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, GetHashKey("WORLD_HUMAN_WRITE_NOTEBOOK"), 0, true, false, false, false)
    
    SendNUIMessage({
        type = "openMDT",
        data = data
    })
end)

-- Close MDT
RegisterNUICallback('closeMDT', function(data, cb)
    isMDTOpen = false
    SetNuiFocus(false, false)
    
    -- Clear animation
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    
    cb('ok')
end)

-- MDT interactions
RegisterNUICallback('searchPersons', function(data, cb)
    TriggerServerEvent('leo:server:searchPersons', data.query)
    cb('ok')
end)

RegisterNUICallback('getPersonDetails', function(data, cb)
    TriggerServerEvent('leo:server:getPersonDetails', data.citizenid)
    cb('ok')
end)

RegisterNUICallback('savePersonNotes', function(data, cb)
    TriggerServerEvent('leo:server:savePersonNotes', data.citizenid, data.notes, data.mugshot, data.flags)
    cb('ok')
end)

RegisterNUICallback('createReport', function(data, cb)
    TriggerServerEvent('leo:server:createReport', data)
    cb('ok')
end)

RegisterNUICallback('getReportDetails', function(data, cb)
    TriggerServerEvent('leo:server:getReportDetails', data.reportId)
    cb('ok')
end)

RegisterNUICallback('updateReport', function(data, cb)
    TriggerServerEvent('leo:server:updateReport', data.reportId, data)
    cb('ok')
end)

RegisterNUICallback('deleteReport', function(data, cb)
    TriggerServerEvent('leo:server:deleteReport', data.reportId)
    cb('ok')
end)

RegisterNUICallback('createWarrant', function(data, cb)
    TriggerServerEvent('leo:server:createWarrant', data)
    cb('ok')
end)

RegisterNUICallback('reviewWarrant', function(data, cb)
    TriggerServerEvent('leo:server:reviewWarrant', data.warrantId, data.approved)
    cb('ok')
end)

RegisterNUICallback('executeWarrant', function(data, cb)
    TriggerServerEvent('leo:server:executeWarrant', data.warrantId)
    cb('ok')
end)

RegisterNUICallback('deleteWarrant', function(data, cb)
    TriggerServerEvent('leo:server:deleteWarrant', data.warrantId)
    cb('ok')
end)

RegisterNUICallback('createBOLO', function(data, cb)
    TriggerServerEvent('leo:server:createBOLO', data)
    cb('ok')
end)

-- Receive search results
RegisterNetEvent('leo:client:searchResults')
AddEventHandler('leo:client:searchResults', function(searchType, results)
    SendNUIMessage({
        type = "searchResults",
        searchType = searchType,
        results = results
    })
end)

-- Receive person details
RegisterNetEvent('leo:client:personDetails')
AddEventHandler('leo:client:personDetails', function(data)
    SendNUIMessage({
        type = "personDetails",
        data = data
    })
end)

-- Receive report details
RegisterNetEvent('leo:client:reportDetails')
AddEventHandler('leo:client:reportDetails', function(data)
    SendNUIMessage({
        type = "reportDetails",
        data = data
    })
end)

-- Report created
RegisterNetEvent('leo:client:reportCreated')
AddEventHandler('leo:client:reportCreated', function(reportId)
    SendNUIMessage({
        type = "reportCreated",
        reportId = reportId
    })
end)

-- Warrant created
RegisterNetEvent('leo:client:warrantCreated')
AddEventHandler('leo:client:warrantCreated', function(warrantId)
    SendNUIMessage({
        type = "warrantCreated",
        warrantId = warrantId
    })
end)

-- New BOLO notification
RegisterNetEvent('leo:client:newBOLO')
AddEventHandler('leo:client:newBOLO', function(data)
    SendNUIMessage({
        type = "newBOLO",
        data = data
    })
    
    -- Show notification (framework-agnostic via NUI)
    SendNUIMessage({
        type = "notification",
        message = string.format("NEW BOLO: %s", data.title),
        notifType = "warning",
        duration = 5000
    })
end)

-- ============================================
-- MDT OFFICE LOCATIONS
-- ============================================

if Config.MDT.enableOfficeLocations then
    CreateThread(function()
        while true do
            Wait(0)
            
            if not isMDTOpen and isOnDuty then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                
                for _, location in ipairs(Config.MDT.officeLocations) do
                    local distance = #(playerCoords - location.coords)
                    
                    if distance < 2.0 then
                        -- Draw prompt
                        DrawText3D(location.coords.x, location.coords.y, location.coords.z, 
                            "[E] Open " .. location.label)
                        
                        if IsControlJustPressed(0, 0x760A9C6F) then -- E key
                            ExecuteCommand(Config.Commands.mdt)
                        end
                    end
                end
            else
                Wait(500)
            end
        end
    end)
end

-- ============================================
-- ARREST & DETAINMENT
-- ============================================

-- Cuff player
RegisterCommand(Config.Commands.cuff, function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = GetClosestPlayer(playerCoords)
    
    if closestPlayer ~= -1 and closestDistance < 2.0 then
        TriggerServerEvent('leo:server:cuffPlayer', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('leo:client:getCuffed')
AddEventHandler('leo:client:getCuffed', function()
    local playerPed = PlayerPedId()
    isCuffed = true
    
    -- Apply handcuff animation
    RequestAnimDict("amb_rest@world_human_mobile@male_iphone@idle_d")
    while not HasAnimDictLoaded("amb_rest@world_human_mobile@male_iphone@idle_d") do
        Wait(10)
    end
    
    -- Disable controls
    CreateThread(function()
        while isCuffed do
            Wait(0)
            DisableControlAction(0, 0x07CE1E61, true) -- F/Enter
            DisableControlAction(0, 0xD9D0E1C0, true) -- Space
            DisableControlAction(0, 0x8FFC75D6, true) -- Shift
            DisableControlAction(0, 0x27D1C284, true) -- R
            DisableControlAction(0, 0x4CC0E2FE, true) -- B
            DisableControlAction(0, 0x8CC9CD42, true) -- X
        end
    end)
end)

RegisterNetEvent('leo:client:getUncuffed')
AddEventHandler('leo:client:getUncuffed', function()
    isCuffed = false
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
end)

-- Escort player
RegisterCommand(Config.Commands.escort, function()
    if isCuffed then return end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = GetClosestPlayer(playerCoords)
    
    if closestPlayer ~= -1 and closestDistance < 2.0 then
        TriggerServerEvent('leo:server:escortPlayer', GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('leo:client:getEscorted')
AddEventHandler('leo:client:getEscorted', function(officerId)
    isEscorted = not isEscorted
    
    if isEscorted then
        local playerPed = PlayerPedId()
        local officerPed = GetPlayerPed(GetPlayerFromServerId(officerId))
        
        CreateThread(function()
            while isEscorted do
                Wait(0)
                local officerCoords = GetEntityCoords(officerPed)
                SetEntityCoords(playerPed, officerCoords.x, officerCoords.y, officerCoords.z, false, false, false, false)
            end
        end)
    end
end)

-- ============================================
-- JAIL SYSTEM
-- ============================================

RegisterNetEvent('leo:client:sendToJail')
AddEventHandler('leo:client:sendToJail', function(jailTime, jailCoords)
    local playerPed = PlayerPedId()
    
    -- Teleport to jail
    SetEntityCoords(playerPed, jailCoords.x, jailCoords.y, jailCoords.z, false, false, false, false)
    
    -- Start jail timer
    local remainingTime = jailTime * 60 -- Convert to seconds
    
    CreateThread(function()
        while remainingTime > 0 do
            Wait(1000)
            remainingTime = remainingTime - 1
            
            -- Update UI
            SendNUIMessage({
                type = "jailTimer",
                time = remainingTime
            })
        end
        
        -- Auto-release when time is up
        TriggerServerEvent('leo:server:jailTimeServed')
    end)
end)

RegisterNetEvent('leo:client:releaseFromJail')
AddEventHandler('leo:client:releaseFromJail', function(releaseCoords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, releaseCoords.x, releaseCoords.y, releaseCoords.z, false, false, false, false)
    
    SendNUIMessage({
        type = "jailTimer",
        time = 0
    })
end)

-- ============================================
-- LOADOUT SYSTEM
-- ============================================

RegisterNetEvent('leo:client:giveWeapon')
AddEventHandler('leo:client:giveWeapon', function(weaponHash)
    local playerPed = PlayerPedId()
    GiveWeaponToPed(playerPed, GetHashKey(weaponHash), 100, true, false, 0, false, 0.5, 1.0, 752097756, false, 0.0, false)
end)

-- ============================================
-- ACTIVITY TRACKING
-- ============================================

CreateThread(function()
    while true do
        Wait(60000) -- Every minute
        
        if isOnDuty then
            TriggerServerEvent('leo:server:updateActivity')
        end
    end
end)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextCentre(1)
    DisplayText(str, _x, _y)
end

function GetClosestPlayer(coords)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    
    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function CreateVarString(p0, p1, variadic)
    return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong())
end

print("^2[LEO-CORE] Client initialized successfully^7")
