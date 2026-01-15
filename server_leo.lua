--[[============================================
    LEO-CORE Server
    Main server-side logic for LEO system
============================================]]--

-- Initialize framework bridge
local Bridge = nil

CreateThread(function()
    local success, err = pcall(function()
        Bridge = require('bridge')
        Bridge.Init()
    end)
    
    if not success then
        print("^1[LEO-CORE] CRITICAL ERROR: Failed to initialize framework bridge^7")
        print("^1[LEO-CORE] Error: " .. tostring(err) .. "^7")
        print("^1[LEO-CORE] Please check your Config.Framework setting in config_leo.lua^7")
    end
end)

-- ============================================
-- DUTY MANAGEMENT
-- ============================================
local OnDutyOfficers = {}
local DutyStartTimes = {}
local LastActivity = {}

-- Toggle duty status
RegisterCommand(Config.Commands.duty, function(source, args)
    local isLEO, agency, job, grade = Bridge.IsLEO(source)
    
    if not isLEO then
        Bridge.Notify(source, Config.Notifications["not_leo"], "error")
        return
    end
    
    local citizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    
    if OnDutyOfficers[source] then
        -- Going off duty
        OnDutyOfficers[source] = nil
        
        -- Calculate duty time
        local startTime = DutyStartTimes[source]
        if startTime then
            local totalMinutes = math.floor((os.time() - startTime) / 60)
            DutyStartTimes[source] = nil
            
            -- Log duty session
            MySQL.Async.execute([[
                UPDATE leo_duty_logs 
                SET duty_end = NOW(), total_minutes = ? 
                WHERE citizenid = ? AND duty_end IS NULL
            ]], {totalMinutes, citizenid})
            
            -- Send webhook
            if Config.Webhooks.enabled and Config.Webhooks.dutyLog ~= "" then
                SendDiscordLog(Config.Webhooks.dutyLog, "Officer Off Duty", 
                    string.format("%s went off duty\nAgency: %s\nDuty Time: %d minutes", 
                        officerName, agency, totalMinutes), 15158332)
            end
        end
        
        Bridge.Notify(source, Config.Notifications["duty_off"], "success")
        TriggerClientEvent('leo:client:dutyStatus', source, false)
    else
        -- Going on duty
        OnDutyOfficers[source] = {
            citizenid = citizenid,
            name = officerName,
            agency = agency,
            job = job,
            grade = grade
        }
        DutyStartTimes[source] = os.time()
        LastActivity[source] = os.time()
        
        -- Log duty start
        MySQL.Async.insert([[
            INSERT INTO leo_duty_logs (citizenid, agency, rank, duty_start) 
            VALUES (?, ?, ?, NOW())
        ]], {citizenid, agency, job})
        
        -- Give loadout
        GiveLoadout(source, job)
        
        -- Send webhook
        if Config.Webhooks.enabled and Config.Webhooks.dutyLog ~= "" then
            SendDiscordLog(Config.Webhooks.dutyLog, "Officer On Duty", 
                string.format("%s went on duty\nAgency: %s\nRank: %s", 
                    officerName, agency, job), 3066993)
        end
        
        Bridge.Notify(source, Config.Notifications["duty_on"], "success")
        TriggerClientEvent('leo:client:dutyStatus', source, true)
    end
end)

-- Give loadout based on rank
function GiveLoadout(source, rank)
    local loadout = Config.DutySystem.loadouts[rank]
    if not loadout then return end
    
    for _, weapon in ipairs(loadout.weapons or {}) do
        TriggerClientEvent('leo:client:giveWeapon', source, weapon)
    end
    
    for _, item in ipairs(loadout.items or {}) do
        Bridge.AddItem(source, item, 1)
    end
end

-- Check if officer is on duty
function IsOnDuty(source)
    return OnDutyOfficers[source] ~= nil
end

-- AFK Detection
if Config.DutySystem.afkCheckInterval > 0 then
    CreateThread(function()
        while true do
            Wait(Config.DutySystem.afkCheckInterval)
            
            local currentTime = os.time()
            for source, data in pairs(OnDutyOfficers) do
                local lastActivity = LastActivity[source] or currentTime
                local afkTime = currentTime - lastActivity
                
                if afkTime > Config.DutySystem.afkKickTime then
                    -- Kick from duty
                    OnDutyOfficers[source] = nil
                    Bridge.Notify(source, "You have been removed from duty due to inactivity.", "error")
                    TriggerClientEvent('leo:client:dutyStatus', source, false)
                elseif afkTime > Config.DutySystem.afkWarningTime then
                    Bridge.Notify(source, "Warning: You will be removed from duty if inactive.", "warning")
                end
            end
        end
    end)
end

-- Update activity on movement
RegisterNetEvent('leo:server:updateActivity')
AddEventHandler('leo:server:updateActivity', function()
    local source = source
    LastActivity[source] = os.time()
end)

-- ============================================
-- MDT SYSTEM
-- ============================================

-- Open MDT
RegisterCommand(Config.Commands.mdt, function(source, args)
    if not Config.MDT.requireDutyForAccess or IsOnDuty(source) then
        local isLEO, agency, job, grade = Bridge.IsLEO(source)
        
        if not isLEO then
            Bridge.Notify(source, Config.Notifications["not_leo"], "error")
            return
        end
        
        if not Bridge.HasPermission(source, 'mdt_access') then
            Bridge.Notify(source, Config.Notifications["no_permission"], "error")
            return
        end
        
        -- Get recent data
        MySQL.Async.fetchAll('SELECT * FROM leo_reports ORDER BY id DESC LIMIT 10', {}, function(reports)
            MySQL.Async.fetchAll('SELECT * FROM leo_warrants WHERE status = ? ORDER BY id DESC LIMIT 10', {'active'}, function(warrants)
                MySQL.Async.fetchAll('SELECT * FROM leo_bolos WHERE status = ? ORDER BY id DESC LIMIT 10', {'active'}, function(bolos)
                    
                    local officerName = Bridge.GetCharacterName(source)
                    local citizenid = Bridge.GetIdentifier(source)
                    
                    -- Parse JSON fields
                    for _, report in ipairs(reports) do
                        if report.involved_persons then
                            report.involved_persons = json.decode(report.involved_persons)
                        end
                        if report.charges_filed then
                            report.charges_filed = json.decode(report.charges_filed)
                        end
                    end
                    
                    for _, warrant in ipairs(warrants) do
                        if warrant.charges_json then
                            warrant.charges_json = json.decode(warrant.charges_json)
                        end
                    end
                    
                    TriggerClientEvent('leo:client:openMDT', source, {
                        officer = {
                            name = officerName,
                            citizenid = citizenid,
                            agency = agency,
                            rank = job,
                            grade = grade
                        },
                        reports = reports,
                        warrants = warrants,
                        bolos = bolos,
                        charges = Config.Charges
                    })
                    
                    Bridge.Notify(source, Config.Notifications["mdt_opened"], "success")
                end)
            end)
        end)
    else
        Bridge.Notify(source, Config.Notifications["not_on_duty"], "error")
    end
end)

-- Search persons
RegisterServerEvent('leo:server:searchPersons')
AddEventHandler('leo:server:searchPersons', function(query)
    local source = source
    
    if not IsOnDuty(source) and Config.MDT.requireDutyForAccess then
        return
    end
    
    Bridge.SearchCharacters(query, function(matches)
        -- Get additional data for each match using proper callback chaining
        local processed = 0
        local totalMatches = #matches
        
        if totalMatches == 0 then
            TriggerClientEvent('leo:client:searchResults', source, 'persons', matches)
            return
        end
        
        for i, match in ipairs(matches) do
            MySQL.Async.fetchScalar('SELECT COUNT(*) FROM leo_records WHERE citizenid = ?', 
                {match.citizenid or match.identifier}, function(recordCount)
                match.recordCount = recordCount or 0
                
                MySQL.Async.fetchScalar('SELECT COUNT(*) FROM leo_warrants WHERE citizenid = ? AND status = ?', 
                    {match.citizenid or match.identifier, 'active'}, function(warrantCount)
                    match.hasWarrant = warrantCount and warrantCount > 0
                    
                    processed = processed + 1
                    if processed >= totalMatches then
                        TriggerClientEvent('leo:client:searchResults', source, 'persons', matches)
                    end
                end)
            end)
        end
    end)
end)

-- Get person details
RegisterServerEvent('leo:server:getPersonDetails')
AddEventHandler('leo:server:getPersonDetails', function(citizenid)
    local source = source
    
    if not IsOnDuty(source) and Config.MDT.requireDutyForAccess then
        return
    end
    
    -- Get person record
    MySQL.Async.fetchAll('SELECT * FROM leo_persons WHERE citizenid = ?', {citizenid}, function(personResult)
        local person = personResult[1] or {}
        
        -- Get criminal records
        MySQL.Async.fetchAll('SELECT * FROM leo_records WHERE citizenid = ? ORDER BY incident_date DESC', 
            {citizenid}, function(records)
            
            -- Get active warrants
            MySQL.Async.fetchAll('SELECT * FROM leo_warrants WHERE citizenid = ? AND status = ?', 
                {citizenid, 'active'}, function(warrants)
                
                -- Parse JSON fields
                for _, record in ipairs(records) do
                    if record.charges_json then
                        record.charges = json.decode(record.charges_json)
                    end
                end
                
                for _, warrant in ipairs(warrants) do
                    if warrant.charges_json then
                        warrant.charges = json.decode(warrant.charges_json)
                    end
                end
                
                if person.aliases then
                    person.aliases = json.decode(person.aliases)
                end
                if person.known_affiliations then
                    person.known_affiliations = json.decode(person.known_affiliations)
                end
                if person.flags then
                    person.flags = json.decode(person.flags)
                end
                
                TriggerClientEvent('leo:client:personDetails', source, {
                    person = person,
                    records = records,
                    warrants = warrants
                })
            end)
        end)
    end)
end)

-- Save person notes
RegisterServerEvent('leo:server:savePersonNotes')
AddEventHandler('leo:server:savePersonNotes', function(citizenid, notes, mugshot, flags)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_access') then
        return
    end
    
    -- Check if person exists
    MySQL.Async.fetchScalar('SELECT id FROM leo_persons WHERE citizenid = ?', {citizenid}, function(personId)
        if personId then
            MySQL.Async.execute([[
                UPDATE leo_persons 
                SET notes = ?, mugshot_url = ?, flags = ?, updated_at = NOW() 
                WHERE citizenid = ?
            ]], {notes, mugshot, json.encode(flags or {}), citizenid})
        else
            -- Create person record
            MySQL.Async.insert([[
                INSERT INTO leo_persons (citizenid, notes, mugshot_url, flags) 
                VALUES (?, ?, ?, ?)
            ]], {citizenid, notes, mugshot, json.encode(flags or {})})
        end
        
        Bridge.Notify(source, "Person record updated.", "success")
        
        -- Audit log
        LogAudit(source, 'person_update', 'Updated person record', 'person', citizenid)
    end)
end)

-- ============================================
-- REPORT SYSTEM
-- ============================================

-- Create report
RegisterServerEvent('leo:server:createReport')
AddEventHandler('leo:server:createReport', function(data)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_create_reports') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    local citizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    
    MySQL.Async.insert([[
        INSERT INTO leo_reports 
        (report_type, title, narrative, author, author_id, involved_persons, charges_filed, evidence, status) 
        VALUES (?, ?, ?, ?, (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1), ?, ?, ?, ?)
    ]], {
        data.reportType or 'incident',
        data.title,
        data.narrative,
        officerName,
        citizenid,
        json.encode(data.involvedPersons or {}),
        json.encode(data.chargesFiled or {}),
        json.encode(data.evidence or {}),
        data.status or 'submitted'
    }, function(reportId)
        Bridge.Notify(source, Config.Notifications["report_saved"], "success")
        
        -- Send webhook
        if Config.Webhooks.enabled and Config.Webhooks.reportsLog ~= "" then
            SendDiscordLog(Config.Webhooks.reportsLog, "New Report Created", 
                string.format("Report #%d\nTitle: %s\nOfficer: %s", reportId, data.title, officerName), 3447003)
        end
        
        -- Audit log
        LogAudit(source, 'report_created', 'Created report: ' .. data.title, 'report', reportId)
        
        TriggerClientEvent('leo:client:reportCreated', source, reportId)
    end)
end)

-- Get report details
RegisterServerEvent('leo:server:getReportDetails')
AddEventHandler('leo:server:getReportDetails', function(reportId)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_view_reports') then
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM leo_reports WHERE id = ?', {reportId}, function(result)
        if result[1] then
            local report = result[1]
            
            -- Parse JSON fields
            if report.involved_persons then report.involved_persons = json.decode(report.involved_persons) end
            if report.charges_filed then report.charges_filed = json.decode(report.charges_filed) end
            if report.evidence then report.evidence = json.decode(report.evidence) end
            if report.witnesses then report.witnesses = json.decode(report.witnesses) end
            
            TriggerClientEvent('leo:client:reportDetails', source, report)
        end
    end)
end)

-- Update report
RegisterServerEvent('leo:server:updateReport')
AddEventHandler('leo:server:updateReport', function(reportId, data)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_edit_reports') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    MySQL.Async.execute([[
        UPDATE leo_reports 
        SET title = ?, narrative = ?, involved_persons = ?, charges_filed = ?, evidence = ?
        WHERE id = ?
    ]], {
        data.title,
        data.narrative,
        json.encode(data.involvedPersons or {}),
        json.encode(data.chargesFiled or {}),
        json.encode(data.evidence or {}),
        reportId
    }, function(affectedRows)
        if affectedRows > 0 then
            Bridge.Notify(source, Config.Notifications["report_saved"], "success")
            LogAudit(source, 'report_updated', 'Updated report #' .. reportId, 'report', reportId)
        end
    end)
end)

-- Delete report
RegisterServerEvent('leo:server:deleteReport')
AddEventHandler('leo:server:deleteReport', function(reportId)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_delete_reports') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    MySQL.Async.execute('DELETE FROM leo_reports WHERE id = ?', {reportId}, function(affectedRows)
        if affectedRows > 0 then
            Bridge.Notify(source, "Report deleted.", "success")
            LogAudit(source, 'report_deleted', 'Deleted report #' .. reportId, 'report', reportId)
        end
    end)
end)

-- ============================================
-- WARRANT SYSTEM
-- ============================================

-- Create warrant
RegisterServerEvent('leo:server:createWarrant')
AddEventHandler('leo:server:createWarrant', function(data)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_create_warrants') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    local citizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    
    local approvalStatus = 'pending'
    if Bridge.HasPermission(source, 'approve_warrants') then
        approvalStatus = 'approved'
    end
    
    MySQL.Async.insert([[
        INSERT INTO leo_warrants 
        (citizenid, name, warrant_type, charges, charges_json, probable_cause, issued_by, issued_by_id, approval_status, expiration_date, notes) 
        VALUES (?, ?, ?, ?, ?, ?, ?, (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1), ?, DATE_ADD(NOW(), INTERVAL 30 DAY), ?)
    ]], {
        data.targetCitizenid,
        data.targetName,
        data.warrantType or 'arrest',
        data.chargesText or '',
        json.encode(data.charges or {}),
        data.probableCause,
        officerName,
        citizenid,
        approvalStatus,
        data.notes or ''
    }, function(warrantId)
        Bridge.Notify(source, Config.Notifications["warrant_created"], "success")
        
        -- Send webhook
        if Config.Webhooks.enabled and Config.Webhooks.warrantsLog ~= "" then
            SendDiscordLog(Config.Webhooks.warrantsLog, "Warrant Created", 
                string.format("Warrant #%d\nSubject: %s\nIssued by: %s\nStatus: %s", 
                    warrantId, data.targetName, officerName, approvalStatus), 15105570)
        end
        
        LogAudit(source, 'warrant_created', 'Created warrant for ' .. data.targetName, 'warrant', warrantId)
        TriggerClientEvent('leo:client:warrantCreated', source, warrantId)
    end)
end)

-- Approve/Deny warrant
RegisterServerEvent('leo:server:reviewWarrant')
AddEventHandler('leo:server:reviewWarrant', function(warrantId, approved)
    local source = source
    
    if not Bridge.HasPermission(source, 'approve_warrants') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    local citizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    local status = approved and 'approved' or 'denied'
    
    MySQL.Async.execute([[
        UPDATE leo_warrants 
        SET approval_status = ?, approved_by = ?, approved_by_id = (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1), approval_date = NOW()
        WHERE id = ?
    ]], {status, officerName, citizenid, warrantId}, function(affectedRows)
        if affectedRows > 0 then
            local notif = approved and Config.Notifications["warrant_approved"] or Config.Notifications["warrant_denied"]
            Bridge.Notify(source, notif, "success")
            LogAudit(source, 'warrant_reviewed', status .. ' warrant #' .. warrantId, 'warrant', warrantId)
        end
    end)
end)

-- Execute warrant
RegisterServerEvent('leo:server:executeWarrant')
AddEventHandler('leo:server:executeWarrant', function(warrantId)
    local source = source
    
    if not Bridge.HasPermission(source, 'arrest') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    local citizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    
    MySQL.Async.execute([[
        UPDATE leo_warrants 
        SET status = ?, execution_date = NOW(), executed_by = ?, executed_by_id = (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1)
        WHERE id = ?
    ]], {'executed', officerName, citizenid, warrantId}, function(affectedRows)
        if affectedRows > 0 then
            Bridge.Notify(source, "Warrant executed.", "success")
            LogAudit(source, 'warrant_executed', 'Executed warrant #' .. warrantId, 'warrant', warrantId)
        end
    end)
end)

-- Delete warrant
RegisterServerEvent('leo:server:deleteWarrant')
AddEventHandler('leo:server:deleteWarrant', function(warrantId)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_delete_warrants') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    MySQL.Async.execute('UPDATE leo_warrants SET status = ? WHERE id = ?', {'cancelled', warrantId}, function(affectedRows)
        if affectedRows > 0 then
            Bridge.Notify(source, "Warrant cancelled.", "success")
            LogAudit(source, 'warrant_cancelled', 'Cancelled warrant #' .. warrantId, 'warrant', warrantId)
        end
    end)
end)

-- ============================================
-- BOLO SYSTEM
-- ============================================

-- Create BOLO
RegisterServerEvent('leo:server:createBOLO')
AddEventHandler('leo:server:createBOLO', function(data)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_create_bolos') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    local citizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    
    local expirationDate = nil
    if Config.BOLO.autoExpire then
        expirationDate = os.date("%Y-%m-%d %H:%M:%S", os.time() + (Config.BOLO.defaultExpirationHours * 3600))
    end
    
    MySQL.Async.insert([[
        INSERT INTO leo_bolos 
        (bolo_type, title, description, person_name, person_citizenid, vehicle_plate, vehicle_model, priority, issued_by, issued_by_id, expiration_date) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1), ?)
    ]], {
        data.boloType,
        data.title,
        data.description,
        data.personName,
        data.personCitizenid,
        data.vehiclePlate,
        data.vehicleModel,
        data.priority or 'medium',
        officerName,
        citizenid,
        expirationDate
    }, function(boloId)
        Bridge.Notify(source, Config.Notifications["bolo_created"], "success")
        
        -- Notify all on-duty officers
        if Config.BOLO.notifyOnCreate then
            for officerSource, _ in pairs(OnDutyOfficers) do
                TriggerClientEvent('leo:client:newBOLO', officerSource, {
                    id = boloId,
                    type = data.boloType,
                    title = data.title,
                    priority = data.priority
                })
            end
        end
        
        LogAudit(source, 'bolo_created', 'Created BOLO: ' .. data.title, 'bolo', boloId)
    end)
end)

-- ============================================
-- ARREST SYSTEM
-- ============================================

-- Arrest player
RegisterServerEvent('leo:server:arrestPlayer')
AddEventHandler('leo:server:arrestPlayer', function(targetId, charges, jailTime, fine)
    local source = source
    
    if not Bridge.HasPermission(source, 'arrest') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    if not IsOnDuty(source) then
        Bridge.Notify(source, Config.Notifications["not_on_duty"], "error")
        return
    end
    
    local officerCitizenid = Bridge.GetIdentifier(source)
    local officerName = Bridge.GetCharacterName(source)
    local targetCitizenid = Bridge.GetIdentifier(targetId)
    local targetName = Bridge.GetCharacterName(targetId)
    
    -- Calculate totals
    local totalJailTime = math.min(jailTime or 0, Config.Jail.maxJailTime)
    local totalFine = fine or 0
    
    -- Create arrest record
    MySQL.Async.insert([[
        INSERT INTO leo_records 
        (citizenid, record_type, charges, charges_json, arresting_officer, officer_id, sentence_time, sentence_fine) 
        VALUES (?, 'arrest', ?, ?, ?, (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1), ?, ?)
    ]], {
        targetCitizenid,
        json.encode(charges),
        json.encode(charges),
        officerName,
        officerCitizenid,
        totalJailTime,
        totalFine
    }, function(recordId)
        
        -- Create jail record if jail time
        if totalJailTime > 0 then
            MySQL.Async.insert([[
                INSERT INTO leo_jail_records 
                (citizenid, record_id, sentence_time, fine_amount, charges, intake_officer, intake_officer_id) 
                VALUES (?, ?, ?, ?, ?, ?, (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1))
            ]], {
                targetCitizenid,
                recordId,
                totalJailTime,
                totalFine,
                json.encode(charges),
                officerName,
                officerCitizenid
            })
            
            -- Send player to jail
            TriggerClientEvent('leo:client:sendToJail', targetId, totalJailTime, Config.Jail.jailLocation)
        end
        
        -- Remove money for fine
        if totalFine > 0 then
            Bridge.RemoveMoney(targetId, totalFine, 'cash')
        end
        
        Bridge.Notify(source, string.format("Arrested %s. Jail: %d min, Fine: $%d", targetName, totalJailTime, totalFine), "success")
        Bridge.Notify(targetId, Config.Notifications["arrested"], "error")
        
        -- Send webhook
        if Config.Webhooks.enabled and Config.Webhooks.arrestLog ~= "" then
            SendDiscordLog(Config.Webhooks.arrestLog, "Player Arrested", 
                string.format("Suspect: %s\nOfficer: %s\nJail: %d min\nFine: $%d\nCharges: %s", 
                    targetName, officerName, totalJailTime, totalFine, json.encode(charges)), 15158332)
        end
        
        LogAudit(source, 'arrest', 'Arrested ' .. targetName, 'record', recordId)
    end)
end)

-- Release from jail
RegisterServerEvent('leo:server:releaseFromJail')
AddEventHandler('leo:server:releaseFromJail', function(targetId)
    local source = source
    
    if not Bridge.HasPermission(source, 'arrest') then
        return
    end
    
    local targetCitizenid = Bridge.GetIdentifier(targetId)
    local officerName = Bridge.GetCharacterName(source)
    local officerCitizenid = Bridge.GetIdentifier(source)
    
    MySQL.Async.execute([[
        UPDATE leo_jail_records 
        SET status = 'released', release_date = NOW(), release_officer = ?, release_officer_id = (SELECT id FROM leo_officers WHERE citizenid = ? LIMIT 1), release_reason = 'released' 
        WHERE citizenid = ? AND status = 'incarcerated'
    ]], {officerName, officerCitizenid, targetCitizenid}, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('leo:client:releaseFromJail', targetId, Config.Jail.releaseLocation)
            Bridge.Notify(source, "Player released from custody.", "success")
            Bridge.Notify(targetId, Config.Notifications["released"], "success")
        end
    end)
end)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Audit logging
function LogAudit(source, actionType, description, targetType, targetId)
    if not Config.Security.enableAuditLog then return end
    
    local citizenid = Bridge.GetIdentifier(source)
    
    MySQL.Async.insert([[
        INSERT INTO leo_audit_logs (citizenid, action_type, action_description, target_type, target_id) 
        VALUES (?, ?, ?, ?, ?)
    ]], {citizenid, actionType, description, targetType, targetId})
end

-- Discord webhook
function SendDiscordLog(webhook, title, description, color)
    if webhook == "" then return end
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {{
            title = title,
            description = description,
            color = color or Config.Webhooks.color,
            footer = {
                text = "LEO-CORE | " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }), {['Content-Type'] = 'application/json'})
end

-- Cuff player
RegisterServerEvent('leo:server:cuffPlayer')
AddEventHandler('leo:server:cuffPlayer', function(targetId)
    local source = source
    
    if not IsOnDuty(source) then
        Bridge.Notify(source, Config.Notifications["not_on_duty"], "error")
        return
    end
    
    local isLEO = Bridge.IsLEO(source)
    if not isLEO then
        return
    end
    
    TriggerClientEvent('leo:client:getCuffed', targetId)
    Bridge.Notify(source, Config.Notifications["person_cuffed"], "success")
    LogAudit(source, 'cuff', 'Cuffed player', 'player', targetId)
end)

-- Uncuff player
RegisterServerEvent('leo:server:uncuffPlayer')
AddEventHandler('leo:server:uncuffPlayer', function(targetId)
    local source = source
    
    if not IsOnDuty(source) then
        return
    end
    
    TriggerClientEvent('leo:client:getUncuffed', targetId)
    Bridge.Notify(source, Config.Notifications["person_uncuffed"], "success")
    LogAudit(source, 'uncuff', 'Uncuffed player', 'player', targetId)
end)

-- Escort player
RegisterServerEvent('leo:server:escortPlayer')
AddEventHandler('leo:server:escortPlayer', function(targetId)
    local source = source
    
    if not IsOnDuty(source) then
        return
    end
    
    TriggerClientEvent('leo:client:getEscorted', targetId, source)
    LogAudit(source, 'escort', 'Escorting player', 'player', targetId)
end)

-- Jail time served (auto-release)
RegisterServerEvent('leo:server:jailTimeServed')
AddEventHandler('leo:server:jailTimeServed', function()
    local source = source
    local citizenid = Bridge.GetIdentifier(source)
    
    MySQL.Async.execute([[
        UPDATE leo_jail_records 
        SET status = 'released', release_date = NOW(), release_reason = 'time_served' 
        WHERE citizenid = ? AND status = 'incarcerated'
    ]], {citizenid}, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('leo:client:releaseFromJail', source, Config.Jail.releaseLocation)
            Bridge.Notify(source, Config.Notifications["released"], "success")
        end
    end)
end)

-- Search vehicles
RegisterServerEvent('leo:server:searchVehicles')
AddEventHandler('leo:server:searchVehicles', function(plate)
    local source = source
    
    if not IsOnDuty(source) and Config.MDT.requireDutyForAccess then
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM leo_vehicles WHERE plate LIKE ?', {'%' .. plate .. '%'}, function(results)
        TriggerClientEvent('leo:client:searchResults', source, 'vehicles', results)
    end)
end)

-- Get vehicle details
RegisterServerEvent('leo:server:getVehicleDetails')
AddEventHandler('leo:server:getVehicleDetails', function(plate)
    local source = source
    
    if not IsOnDuty(source) and Config.MDT.requireDutyForAccess then
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM leo_vehicles WHERE plate = ?', {plate}, function(results)
        if results[1] then
            local vehicle = results[1]
            if vehicle.flags then
                vehicle.flags = json.decode(vehicle.flags)
            end
            TriggerClientEvent('leo:client:vehicleDetails', source, vehicle)
        end
    end)
end)

-- Update vehicle flags
RegisterServerEvent('leo:server:updateVehicleFlags')
AddEventHandler('leo:server:updateVehicleFlags', function(plate, stolen, notes, flags)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_access') then
        return
    end
    
    MySQL.Async.fetchScalar('SELECT id FROM leo_vehicles WHERE plate = ?', {plate}, function(vehicleId)
        if vehicleId then
            MySQL.Async.execute([[
                UPDATE leo_vehicles 
                SET stolen = ?, notes = ?, flags = ?, updated_at = NOW() 
                WHERE plate = ?
            ]], {stolen and 1 or 0, notes, json.encode(flags or {}), plate})
        else
            MySQL.Async.insert([[
                INSERT INTO leo_vehicles (plate, stolen, notes, flags) 
                VALUES (?, ?, ?, ?)
            ]], {plate, stolen and 1 or 0, notes, json.encode(flags or {})})
        end
        
        Bridge.Notify(source, "Vehicle record updated.", "success")
        LogAudit(source, 'vehicle_update', 'Updated vehicle: ' .. plate, 'vehicle', plate)
    end)
end)

-- Get BOLOs
RegisterServerEvent('leo:server:getBOLOs')
AddEventHandler('leo:server:getBOLOs', function()
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_view_bolos') then
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM leo_bolos WHERE status = ? ORDER BY priority DESC, issue_date DESC', 
        {'active'}, function(bolos)
        TriggerClientEvent('leo:client:boloList', source, bolos)
    end)
end)

-- Update BOLO status
RegisterServerEvent('leo:server:updateBOLO')
AddEventHandler('leo:server:updateBOLO', function(boloId, status)
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_edit_bolos') then
        Bridge.Notify(source, Config.Notifications["no_permission"], "error")
        return
    end
    
    MySQL.Async.execute('UPDATE leo_bolos SET status = ? WHERE id = ?', {status, boloId}, function(affectedRows)
        if affectedRows > 0 then
            Bridge.Notify(source, "BOLO updated.", "success")
            LogAudit(source, 'bolo_updated', 'Updated BOLO #' .. boloId, 'bolo', boloId)
        end
    end)
end)

-- Get officer list
RegisterServerEvent('leo:server:getOfficerList')
AddEventHandler('leo:server:getOfficerList', function()
    local source = source
    
    if not Bridge.HasPermission(source, 'mdt_access') then
        return
    end
    
    local onDutyList = {}
    for src, data in pairs(OnDutyOfficers) do
        table.insert(onDutyList, {
            source = src,
            name = data.name,
            agency = data.agency,
            rank = data.job,
            dutyTime = math.floor((os.time() - (DutyStartTimes[src] or os.time())) / 60)
        })
    end
    
    TriggerClientEvent('leo:client:officerList', source, onDutyList)
end)

-- Player disconnect - end duty session
AddEventHandler('playerDropped', function(reason)
    local source = source
    
    if OnDutyOfficers[source] then
        local startTime = DutyStartTimes[source]
        if startTime then
            local totalMinutes = math.floor((os.time() - startTime) / 60)
            local citizenid = Bridge.GetIdentifier(source)
            
            MySQL.Async.execute([[
                UPDATE leo_duty_logs 
                SET duty_end = NOW(), total_minutes = ? 
                WHERE citizenid = ? AND duty_end IS NULL
            ]], {totalMinutes, citizenid})
        end
        
        OnDutyOfficers[source] = nil
        DutyStartTimes[source] = nil
        LastActivity[source] = nil
    end
end)

print("^2[LEO-CORE] Server initialized successfully^7")
