# LEO-CORE Quick Start Guide

Get up and running with LEO-CORE in 10 minutes!

## 🚀 Quick Installation (TL;DR)

```bash
# 1. Copy resource to your server
cd resources/
git clone https://github.com/iboss21/twl_mdt_police.git leo-core

# 2. Import database
mysql -u username -p database_name < leo-core/leo_core.sql

# 3. Configure framework in config_leo.lua
Config.Framework = "rsg-core"  # or "lxr-core" or "vorp"

# 4. Add to server.cfg
ensure oxmysql
ensure [your-framework]
ensure leo-core

# 5. Restart server
restart leo-core
```

## 📋 Essential Configuration

### Set Your Framework
Edit `config_leo.lua` line 8:
```lua
Config.Framework = "rsg-core"  -- Change to your framework
```

### Add Jobs to Framework
Make sure your framework has these jobs: `sheriff`, `police`, `marshal`, `ranger`

### Set Jail Location
Edit `config_leo.lua`:
```lua
Config.Jail = {
    jailLocation = vector3(-304.10, 829.9, 120.0),  -- Your jail coords
    releaseLocation = vector3(-275.0, 805.0, 119.0), -- Release coords
}
```

## 🎮 First Time Use

### 1. Get LEO Job
```
/setjob [yourname] sheriff
```

### 2. Go On Duty
```
/duty
```
You should see: "You are now on duty."

### 3. Open MDT
```
/mdt
```
The MDT interface opens with recent reports and warrants.

### 4. Test Person Search
1. Click "Person Search" in MDT
2. Type a character name
3. Click on result to view profile
4. Add notes or mugshot
5. Save changes

### 5. Create First Report
1. Click "New Report" in MDT
2. Select report type (Incident/Arrest)
3. Fill in title and narrative
4. Add involved persons
5. Select charges if arrest
6. Submit report

### 6. Test Arrest
1. Stand near another player
2. `/cuff` to restrain them
3. `/escort` to move them
4. `/jail [minutes]` to jail them
5. Player is sent to jail automatically

## 🔑 Essential Commands

| Command | What It Does |
|---------|--------------|
| `/duty` | Go on/off duty (required for MDT) |
| `/mdt` | Open MDT interface |
| `/cuff` | Cuff nearest player |
| `/escort` | Escort cuffed player |
| `/jail` | Send player to jail |

## 📱 MDT Quick Guide

### Person Search
1. Click "Person Search" tab
2. Type first or last name
3. Click person to view
4. Add notes, mugshot, flags
5. Click "Save"

### Create Report
1. Click "Reports" tab
2. Click "New Report"
3. Choose type: Incident/Arrest/Use-of-Force
4. Fill in details
5. Add involved persons
6. Select charges (if arrest)
7. Submit

### Create Warrant
1. Click "Warrants" tab
2. Click "New Warrant"
3. Search for person
4. Select warrant type (Arrest/Search)
5. Enter probable cause
6. Select charges
7. Submit (requires supervisor approval)

### Create BOLO
1. Click "BOLO" tab
2. Click "New BOLO"
3. Choose type: Person/Vehicle
4. Enter description
5. Set priority
6. Submit (all officers notified)

## ⚖️ Arrest Procedure

1. **Detain**: Use `/cuff` on suspect
2. **Escort**: Use `/escort` to move them
3. **Open MDT**: Use `/mdt`
4. **Create Report**: Document the arrest
5. **Select Charges**: Choose from law book
6. **Review Sentence**: Check jail time + fine
7. **Execute**: Click "Arrest & Jail"
8. **Confirm**: Player sent to jail automatically

## 🔧 Common Issues

### "Not a law enforcement officer"
- Check you have LEO job (sheriff, police, etc.)
- Job name must match `Config.Agencies.allowedJobs`

### "Must be on duty"
- Use `/duty` command first
- Check you see "You are now on duty" message

### "No permission"
- Check your rank in job
- Verify rank permissions in `config_leo.lua`
- Some actions require sergeant+ rank

### MDT won't open
- Must be on duty first (`/duty`)
- Check console for errors
- Verify resource is started

### Commands not working
- Check spelling (case sensitive)
- Ensure you're on duty
- Check permissions for your rank

## 📊 Rank Permissions

| Rank | Can Do |
|------|--------|
| **Cadet** | Basic MDT, Create reports, Arrest |
| **Deputy/Officer** | + Create warrants, Search |
| **Senior Officer** | + Edit reports, Supervise |
| **Sergeant** | + Approve warrants, Delete reports |
| **Lieutenant** | + Create BOLOs, Manage officers |
| **Captain** | + Internal Affairs, Full MDT |
| **Chief/Sheriff** | Full admin access |

## 🎓 Training Your Officers

### New Officer Checklist
- [ ] Explain `/duty` command (must use before MDT)
- [ ] Show how to open MDT (`/mdt` or at terminals)
- [ ] Teach person lookup
- [ ] Practice creating reports
- [ ] Demonstrate arrest procedure
- [ ] Show warrant system
- [ ] Explain BOLO creation
- [ ] Cover proper documentation

### Best Practices
- Always go on duty before patrol
- Document everything in reports
- Use proper charge categories
- Get supervisor approval for warrants
- Update person records with current info
- Use BOLOs for active searches
- Log off duty when done

## 🔐 Security Notes

- All MDT actions are logged
- Supervisors can review your activity
- False reports = IA investigation
- Abuse = disciplinary action
- Follow your server's SOP

## 📍 Finding MDT Terminals

Default locations (can be changed in config):
- **Valentine**: Sheriff's Office (-304, 829, 120)
- **Valentine**: Jail Building (-325, 819, 118)
- **Saint Denis**: Police Station (2513, -1306, 48)
- **Rhodes**: Marshal Office (1362, -1301, 77)
- **Strawberry**: Sheriff's Office (-1810, -347, 164)

Walk near terminal and press **E** to open MDT.

## 💡 Pro Tips

1. **Hotkeys**: Some servers allow binding `/duty` and `/mdt` to keys
2. **Terminals**: Using MDT at terminals is more immersive than command
3. **Reports**: Write clear narratives - others need to understand
4. **Warrants**: Always include detailed probable cause
5. **BOLOs**: Set appropriate priority (not everything is critical)
6. **Notes**: Add useful info to person records (not just "criminal")
7. **Evidence**: Document everything - helps in court RP
8. **Charges**: Stack multiple charges appropriately
9. **Supervisor**: Ask questions if unsure about procedure
10. **RP First**: System supports roleplay, not replaces it

## 🚨 Emergency Quick Reference

### Suspect is fleeing
```
/cuff (when caught)
/mdt → Create Report → Charges: Evading Arrest
```

### Active warrant
```
/mdt → Search person → Check "Active Warrants"
Execute warrant during arrest
```

### Vehicle stop
```
/mdt → Vehicle Search → Enter plate
Check for stolen flag or notes
```

### Backup needed
Create BOLO for suspect or create officer-down report

## 📞 Getting Help

1. **Read the docs**: README.md, INSTALLATION.md
2. **Check config**: Most issues are configuration
3. **Console logs**: Press F8 to see errors
4. **Ask supervisor**: Train with experienced officers
5. **GitHub Issues**: Report bugs or request features

## 🎯 Next Steps

After you're comfortable with basics:
1. Learn the full warrant system
2. Practice use-of-force reports
3. Understand IA procedures
4. Study your server's law book
5. Master the BOLO system
6. Train new cadets

## 📚 Full Documentation

For detailed information:
- **README.md** - Complete feature list
- **INSTALLATION.md** - Detailed setup guide
- **CHANGELOG.md** - Version history
- **config_leo.lua** - All configuration options

---

**You're ready to start!** Remember: LEO-CORE is a tool to enhance RP, not replace it. Focus on quality roleplay and proper documentation.

Questions? Check the full README or create a GitHub issue.
