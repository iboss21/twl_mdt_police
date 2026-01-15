# LEO-CORE - RedM Law Enforcement System

## 🚔 Overview

**LEO-CORE** is a comprehensive, server-authoritative law enforcement system for RedM that provides realistic police gameplay with a full-featured Mobile Data Terminal (MDT). Built for roleplay-first servers, it supports multiple frameworks and focuses on realism, performance, and abuse prevention.

## ✨ Key Features

### 🏛️ Multi-Agency Support
- **Configurable Agencies**: Sheriff, Police, Marshal, Ranger, Army
- **Jurisdiction Rules**: Each agency has defined territories
- **Agency-specific Badges**: Custom badges for each department

### 👮 Rank System
- **7 Rank Levels**: Cadet → Deputy/Officer → Senior → Sergeant → Lieutenant → Captain → Chief/Sheriff
- **Permission-based Access**: Each rank has specific capabilities
- **Configurable Permissions**: MDT access, arrest authority, warrant approval, etc.

### 📱 Comprehensive MDT System
- **Person Records**: Full character profiles with photos, aliases, affiliations
- **Criminal Records**: Complete arrest and conviction history
- **Warrants**: Search and arrest warrants with supervisor approval flow
- **Reports**: Incident, arrest, use-of-force, and officer notes
- **BOLO System**: Person and vehicle Be On the Lookout alerts
- **Vehicle Lookup**: Ownership, stolen flags, and notes
- **Internal Affairs**: Officer complaints and investigations (restricted)

### 🚨 Duty System
- **On-Duty/Off-Duty Toggle**: Track officer availability
- **Duty Time Tracking**: Record hours worked for payroll
- **Loadout Assignment**: Automatic weapons/items by rank
- **AFK Prevention**: Auto-remove inactive officers from duty
- **No MDT Access Off-Duty**: Prevent abuse

### ⚖️ Arrest & Detainment
- **Detainment Options**: Soft detain, hard cuffs, hogtie
- **Arrest Flow**: Probable cause → Detain → MDT record → Charges → Sentence
- **Charge Selection**: Configurable law book with stacking charges
- **Jail System**: Time calculation, fine tracking, early release options
- **Bail System**: Configurable bail eligibility and amounts

### 📊 Law Book & Charges
- **8 Categories**: Capital crimes, violent crimes, property crimes, public order, weapons, drugs, interference with LEO, fraud/corruption, miscellaneous
- **Configurable Sentencing**: Jail time ranges, fine ranges, bail eligibility
- **Stackable Charges**: Multiple charges increase sentence
- **Judicial Override**: Support for judge role integration

### 🔐 Security & Auditing
- **Server-Authoritative**: No client trust, all validation server-side
- **Audit Logs**: Every action logged (arrests, warrants, MDT edits, duty toggles)
- **Anti-Spam Protection**: Cooldowns and rate limits
- **Permission Checks**: Rank-gated actions with server validation
- **Discord Webhooks**: Optional logging to Discord

### 🎯 Performance Optimized
- **Event-Driven**: No constant loops
- **Lazy Loading**: Records loaded on demand
- **Indexed Database**: Optimized queries
- **< 0.05ms Impact**: Minimal server performance cost

## 📋 Framework Support

LEO-CORE includes a framework bridge system supporting:
- ✅ **RSG-Core** (Primary)
- ✅ **LXR-Core** (Secondary)
- ✅ **VORP** (Optional)

Switch frameworks by changing one line in `config_leo.lua`:
```lua
Config.Framework = "rsg-core" -- Options: "rsg-core", "lxr-core", "vorp"
```

## 🔧 Installation

### Step 1: Database Setup

Run the SQL file to create all necessary tables:
```sql
-- Execute leo_core.sql in your database
-- This creates all tables and migrates data from old MDT if present
```

### Step 2: Resource Installation

1. Download/clone the resource to your `resources` folder
2. Rename folder to `leo-core`
3. Add to `server.cfg`:
```
ensure leo-core
```

### Step 3: Configuration

Edit `config_leo.lua` to customize:
- **Framework**: Set your framework (RSG-Core, LXR-Core, VORP)
- **Agencies**: Add/remove agencies, set jurisdictions
- **Ranks**: Customize rank names and permissions
- **Charges**: Modify law book, sentences, and fines
- **Jail Locations**: Set jail and release coordinates
- **MDT Offices**: Add office terminal locations
- **Discord Webhooks**: Add webhook URLs for logging

### Step 4: Badge Images

Place agency badge images in `ui/badges/`:
- `sheriff.png`
- `police.png`
- `marshal.png`
- `ranger.png`
- `army.png`

### Step 5: Job Setup

Ensure your framework has the following jobs configured:
- `sheriff`
- `police`
- `marshal`
- `ranger`
- `army` (optional)

## 🎮 Commands

| Command | Description | Permission |
|---------|-------------|------------|
| `/duty` | Toggle on-duty status | LEO Job |
| `/mdt` | Open Mobile Data Terminal | LEO Job + On Duty |
| `/cuff` | Cuff/uncuff nearest player | LEO Job + On Duty |
| `/escort` | Escort cuffed player | LEO Job + On Duty |
| `/jail` | Send player to jail | Arrest Permission |
| `/unjail` | Release player from jail | Arrest Permission |

## 📱 MDT Usage

### Opening the MDT
1. Go on duty with `/duty`
2. Use `/mdt` command or visit an office terminal
3. MDT opens with recent reports, warrants, and BOLOs

### Person Lookup
1. Click "Person Search"
2. Enter name to search
3. Select person to view full record
4. View arrests, warrants, convictions
5. Add notes, mugshot, flags

### Creating Reports
1. Click "New Report"
2. Select report type (incident, arrest, use-of-force)
3. Fill in details, add involved persons
4. Select charges if applicable
5. Add evidence and witnesses
6. Submit for supervisor review

### Warrant System
1. Create warrant with probable cause
2. Supervisor reviews and approves/denies
3. Warrant becomes active when approved
4. Execute warrant during arrest
5. Warrant marked as executed

### BOLO System
1. Create person or vehicle BOLO
2. Set priority level
3. All on-duty officers notified
4. Auto-expires after configured time
5. Mark as resolved when cleared

## 🔒 Permissions

Permissions are set per rank in `config_leo.lua`. Example:

```lua
["sergeant"] = {
    permissions = {
        mdt_access = true,
        mdt_create_reports = true,
        mdt_edit_reports = true,
        mdt_delete_reports = true,
        mdt_create_warrants = true,
        mdt_edit_warrants = true,
        approve_warrants = true,
        arrest = true,
        detain = true,
        search = true,
        supervise = true,
    }
}
```

## 🚀 Advanced Configuration

### Custom Charges

Add charges in `config_leo.lua`:
```lua
{
    id = "custom_charge",
    label = "Custom Offense",
    category = 2,
    severity = "medium",
    jailTime = {min = 30, max = 60},
    fine = {min = 100, max = 200},
    bailEligible = true,
    stackable = true,
    description = "Description of the charge"
}
```

### Jurisdiction Rules

Set agency jurisdictions:
```lua
sheriff = {
    jurisdiction = {"valentine", "strawberry", "rhodes"},
    -- Officer can operate in these areas
}
```

### Duty Loadouts

Customize loadouts per rank:
```lua
loadouts = {
    deputy = {
        weapons = {"WEAPON_REVOLVER_CATTLEMAN", "WEAPON_REPEATER_CARBINE"},
        items = {"handcuffs", "notebook", "rope"}
    }
}
```

## 📊 Database Schema

Core tables:
- `leo_officers` - Officer personnel records
- `leo_duty_logs` - Duty time tracking
- `leo_persons` - Enhanced character profiles
- `leo_records` - Arrest and conviction history
- `leo_warrants` - Warrant system with approval flow
- `leo_reports` - Incident and arrest reports
- `leo_bolos` - BOLO system
- `leo_vehicles` - Vehicle records and notes
- `leo_internal_affairs` - IA investigations
- `leo_audit_logs` - Action logging
- `leo_evidence` - Evidence tracking
- `leo_jail_records` - Jail intake/release

## 🐛 Troubleshooting

### MDT Won't Open
- Ensure you're on duty (`/duty`)
- Check you have LEO job
- Verify `Config.MDT.requireDutyForAccess` setting
- Check console for errors

### Framework Not Detected
- Verify framework name in `config_leo.lua`
- Ensure framework is started before leo-core
- Check framework export is available

### Database Errors
- Ensure `leo_core.sql` was executed
- Check MySQL connection
- Verify oxmysql is installed

### Permissions Not Working
- Check rank configuration matches job grades
- Verify permission names are correct
- Check `Config.Ranks` for your rank

## 🔄 Migrating from Old MDT

The SQL file includes migration scripts that will:
1. Import person data from `user_mdt`
2. Import reports from `mdt_reports`
3. Import warrants from `mdt_warrants`
4. Preserve all existing data

After migration, you can keep both systems running or remove the old one.

## 📝 Changelog

### Version 3.0.0 (LEO-CORE)
- Complete rewrite with server-authoritative architecture
- Multi-framework support (RSG-Core, LXR-Core, VORP)
- Enhanced MDT with person records, BOLOs, vehicles
- Comprehensive duty system with tracking
- Warrant approval workflow
- Internal Affairs module
- Full audit logging
- Performance optimizations
- Security enhancements

### Version 2.3 (Legacy)
- Basic MDT functionality
- VORP framework only
- Reports and warrants
- Person lookup

## 🤝 Support

For issues, feature requests, or questions:
- Open an issue on GitHub
- Check documentation
- Review configuration examples

## 📜 License

This resource is provided as-is for RedM roleplay servers.

## 🎯 Future Roadmap

Planned features:
- [ ] Court system integration
- [ ] Judge role and courtroom UI
- [ ] Physical evidence props
- [ ] Forensic system
- [ ] Bodycam integration
- [ ] Prison labor system
- [ ] Federal task forces
- [ ] Cross-agency MDT sharing
- [ ] Advanced analytics dashboard

## 👏 Credits

- Original MDT concept by Unknown Ghostz
- Enhanced and rewritten for LEO-CORE
- Framework bridge system
- Community feedback and testing

---

**Note**: This is a complete law enforcement system designed for serious roleplay servers. Configure appropriately for your server's needs and train officers on proper usage.
