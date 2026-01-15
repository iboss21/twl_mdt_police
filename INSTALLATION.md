# LEO-CORE Installation Guide

## 📋 Prerequisites

Before installing LEO-CORE, ensure you have:
- ✅ RedM Server running
- ✅ One of the supported frameworks:
  - RSG-Core (recommended)
  - LXR-Core
  - VORP
- ✅ MySQL Database (MariaDB 10.3+ or MySQL 5.7+)
- ✅ oxmysql resource installed and configured

## 🔧 Step-by-Step Installation

### Step 1: Download the Resource

1. Download or clone the LEO-CORE resource
2. Extract to your server's `resources` folder
3. Rename the folder to `leo-core` (all lowercase, with hyphen)

```
resources/
  └── leo-core/
      ├── bridge.lua
      ├── client_leo.lua
      ├── cl_mdt.lua
      ├── config.lua
      ├── config_leo.lua
      ├── fxmanifest.lua
      ├── leo_core.sql
      ├── server_leo.lua
      ├── sv_mdt.lua
      ├── README.md
      └── ui/
```

### Step 2: Database Setup

Execute the SQL file to create all necessary tables:

**Option A: Using phpMyAdmin or similar**
1. Open phpMyAdmin
2. Select your RedM database
3. Click "Import" tab
4. Choose `leo_core.sql`
5. Click "Go"

**Option B: Using MySQL Command Line**
```bash
mysql -u username -p database_name < leo_core.sql
```

**Option C: Using HeidiSQL**
1. Connect to your database
2. Click "File" → "Load SQL file"
3. Select `leo_core.sql`
4. Click "Execute"

This will:
- Create 13 new tables for the LEO system
- Migrate data from old MDT tables (if they exist)
- Set up indexes for optimal performance

### Step 3: Framework Configuration

Edit `config_leo.lua` and set your framework:

```lua
-- Line 8
Config.Framework = "rsg-core" -- Options: "rsg-core", "lxr-core", "vorp"
```

**For RSG-Core:**
```lua
Config.Framework = "rsg-core"
```

**For LXR-Core:**
```lua
Config.Framework = "lxr-core"
```

**For VORP:**
```lua
Config.Framework = "vorp"
```

### Step 4: Server Configuration

Add to your `server.cfg`:

```cfg
# LEO-CORE - Law Enforcement System
ensure oxmysql          # Required - must be before leo-core
ensure [framework]      # Your framework (rsg-core, lxr-core, or vorp)
ensure leo-core
```

**Important:** LEO-CORE must load after your framework and oxmysql!

### Step 5: Job Configuration

Ensure your framework has LEO jobs configured:

**For RSG-Core (`shared/jobs.lua`):**
```lua
['sheriff'] = {
    label = "Sheriff's Department",
    grades = {
        ['0'] = {name = 'Cadet', payment = 10},
        ['1'] = {name = 'Deputy', payment = 15},
        ['2'] = {name = 'Senior Officer', payment = 20},
        ['3'] = {name = 'Sergeant', payment = 25},
        ['4'] = {name = 'Lieutenant', payment = 30},
        ['5'] = {name = 'Captain', payment = 35},
        ['6'] = {name = 'Sheriff', payment = 40},
    },
},
['police'] = {
    label = "Police Department",
    grades = {
        ['0'] = {name = 'Cadet', payment = 10},
        ['1'] = {name = 'Officer', payment = 15},
        ['2'] = {name = 'Senior Officer', payment = 20},
        ['3'] = {name = 'Sergeant', payment = 25},
        ['4'] = {name = 'Lieutenant', payment = 30},
        ['5'] = {name = 'Captain', payment = 35},
        ['6'] = {name = 'Chief', payment = 40},
    },
},
['marshal'] = {
    label = "U.S. Marshal Service",
    grades = {
        ['0'] = {name = 'Cadet', payment = 10},
        ['1'] = {name = 'Deputy Marshal', payment = 15},
        ['2'] = {name = 'Senior Marshal', payment = 20},
        ['3'] = {name = 'Sergeant', payment = 25},
        ['4'] = {name = 'Lieutenant', payment = 30},
        ['5'] = {name = 'Captain', payment = 35},
        ['6'] = {name = 'Chief Marshal', payment = 40},
    },
},
['ranger'] = {
    label = "Park Rangers",
    grades = {
        ['0'] = {name = 'Cadet', payment = 10},
        ['1'] = {name = 'Ranger', payment = 15},
        ['2'] = {name = 'Senior Ranger', payment = 20},
        ['3'] = {name = 'Sergeant', payment = 25},
        ['4'] = {name = 'Lieutenant', payment = 30},
        ['5'] = {name = 'Captain', payment = 35},
        ['6'] = {name = 'Chief Ranger', payment = 40},
    },
},
```

### Step 6: Agency Configuration

Edit `config_leo.lua` to configure your agencies:

```lua
Config.Agencies = {
    sheriff = {
        label = "Sheriff's Department",
        shortLabel = "Sheriff",
        jurisdiction = {"valentine", "strawberry", "rhodes", "armadillo", "tumbleweed"},
        allowedJobs = {"sheriff"},
        color = "#8B4513",
        badge = "ui/badges/sheriff.png"
    },
    -- Add more agencies as needed
}
```

### Step 7: MDT Office Locations

Configure MDT terminal locations:

```lua
Config.MDT = {
    officeLocations = {
        {coords = vector3(-304.10, 829.9, 120.0), agency = "sheriff", label = "Valentine Sheriff"},
        {coords = vector3(-325.81, 819.8, 118.0), agency = "sheriff", label = "Valentine Jail"},
        {coords = vector3(2513.13, -1306.01, 48.95), agency = "police", label = "Saint Denis Police"},
        -- Add your custom locations
    },
}
```

To find coordinates:
1. Go in-game to desired location
2. Use `/coords` or similar command
3. Add coordinates to config

### Step 8: Badge Images

Place badge images in `ui/badges/` folder:
- `sheriff.png` (512x512 recommended)
- `police.png`
- `marshal.png`
- `ranger.png`
- `army.png`

If you don't have custom badges, the system will work without them.

### Step 9: Discord Webhooks (Optional)

For Discord logging, add webhook URLs in `config_leo.lua`:

```lua
Config.Webhooks = {
    enabled = true,
    arrestLog = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
    warrantsLog = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
    reportsLog = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
    dutyLog = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
    iaLog = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
    auditLog = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE",
}
```

To create webhooks:
1. Go to Discord Server Settings
2. Click "Integrations" → "Webhooks"
3. Click "New Webhook"
4. Copy webhook URL
5. Paste into config

### Step 10: Test Installation

1. Start your server
2. Check console for errors
3. Look for: `[LEO-CORE] Server initialized successfully`
4. Join server with LEO job
5. Test commands:
   - `/duty` - Toggle duty
   - `/mdt` - Open MDT
6. Check database tables have data

## ⚙️ Advanced Configuration

### Customizing Charges

Edit `config_leo.lua` to add/modify charges:

```lua
{
    id = "your_charge_id",
    label = "Charge Name",
    category = 2, -- 0-8
    severity = "medium", -- low, medium, high, critical
    jailTime = {min = 30, max = 60}, -- minutes
    fine = {min = 100, max = 200}, -- dollars
    bailEligible = true,
    stackable = true,
    description = "Detailed description"
}
```

### Customizing Rank Permissions

Modify rank permissions in `config_leo.lua`:

```lua
["sergeant"] = {
    label = "Sergeant",
    grade = 3,
    pay = 25,
    permissions = {
        mdt_access = true,
        mdt_create_reports = true,
        mdt_edit_reports = true,
        mdt_delete_reports = true,
        approve_warrants = true,
        -- Add/remove permissions as needed
    }
}
```

### Jail Configuration

Set jail locations:

```lua
Config.Jail = {
    jailLocation = vector3(-304.10, 829.9, 120.0), -- Where prisoners spawn
    releaseLocation = vector3(-275.0, 805.0, 119.0), -- Where they're released
    maxJailTime = 300, -- Maximum minutes
    minJailTime = 5, -- Minimum minutes
    bailEnabled = true,
    bailMultiplier = 2.0, -- Bail = fine * multiplier
}
```

### Duty System Configuration

Configure duty behavior:

```lua
Config.DutySystem = {
    enableDutyToggle = true,
    requireUniform = false, -- Require specific clothes
    trackDutyTime = true, -- Log hours worked
    payPerMinute = 0.5, -- Automatic pay
    
    -- AFK settings
    afkCheckInterval = 300000, -- 5 minutes
    afkKickTime = 900000, -- 15 minutes before kick
    afkWarningTime = 600000, -- 10 minutes warning
}
```

## 🔍 Verification Checklist

After installation, verify:
- [ ] Server starts without errors
- [ ] Console shows "LEO-CORE initialized"
- [ ] All 13 database tables created
- [ ] `/duty` command works
- [ ] `/mdt` command opens interface
- [ ] Can search for characters
- [ ] Can create reports
- [ ] Can create warrants
- [ ] Arrest system works
- [ ] Jail system works

## 🐛 Common Issues

### Issue: "Framework not detected"
**Solution:** 
- Check framework name in config matches exactly
- Ensure framework loads before leo-core
- Verify framework export exists

### Issue: "MySQL connection failed"
**Solution:**
- Check oxmysql is installed and running
- Verify database credentials
- Test database connection

### Issue: "Table doesn't exist"
**Solution:**
- Run `leo_core.sql` again
- Check which table is missing
- Verify database name is correct

### Issue: "No permission to access MDT"
**Solution:**
- Verify player has LEO job
- Check job name matches config
- Ensure rank permissions are set correctly

### Issue: "Commands not working"
**Solution:**
- Check command names in config
- Ensure resource is started
- Check console for errors

## 📞 Getting Help

If you need assistance:
1. Check this installation guide
2. Review the main README.md
3. Check console for error messages
4. Verify configuration files
5. Check database tables exist
6. Open a GitHub issue with:
   - Error messages
   - Server console output
   - Configuration (without webhooks)
   - Steps to reproduce

## 🔄 Updating from Old MDT

If you have the old bucky_mdt/westerntheme-mdt:

1. **Backup your database** first!
2. Run `leo_core.sql` - it includes migration scripts
3. Old data will be imported automatically:
   - Person records from `user_mdt`
   - Reports from `mdt_reports`
   - Warrants from `mdt_warrants`
4. Test LEO-CORE works correctly
5. You can remove old MDT resource
6. Old tables can be kept or removed (your choice)

**Migration Notes:**
- Character identifiers are mapped automatically
- JSON fields are converted properly
- Dates are reformatted
- Some fields may be empty (e.g., agencies, ranks)
- You may need to update person records to add new fields

## 🎓 Training Officers

After installation, train your officers on:
1. Using `/duty` to go on/off duty
2. Opening MDT with `/mdt` or at terminals
3. Proper person lookup procedure
4. Creating detailed reports
5. Warrant system and approval process
6. BOLO creation and management
7. Arrest procedure and charge selection
8. Using restraints properly
9. Escort and jail commands
10. Maintaining proper records

## ✅ Next Steps

After successful installation:
1. Configure custom charges for your server
2. Add agency badges
3. Set up Discord webhooks
4. Train your LEO department
5. Create standard operating procedures
6. Test all features thoroughly
7. Adjust permissions as needed
8. Customize for your roleplay style

## 📚 Additional Resources

- Main README: Full feature documentation
- Config Examples: See `config_leo.lua` comments
- Database Schema: See `leo_core.sql` for table structures
- Framework Docs: Check your framework's documentation

---

**Installation complete!** Your LEO-CORE system is ready to use. Remember to restart your server after any configuration changes.
