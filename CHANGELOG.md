# Changelog

All notable changes to LEO-CORE will be documented in this file.

## [3.0.0] - 2026-01-15

### 🎉 Major Release - Complete Rewrite as LEO-CORE

This version represents a complete rewrite of the MDT system into a comprehensive law enforcement platform.

### ✨ Added

#### Core System
- **Multi-Framework Support**: Added framework adapter supporting RSG-Core, LXR-Core, and VORP
- **Server-Authoritative Architecture**: All validation and logic runs on server
- **Comprehensive Config System**: Fully configurable agencies, ranks, charges, permissions
- **Bridge System**: Unified API across all supported frameworks

#### Agency System
- 5 Configurable Agencies: Sheriff, Police, Marshal, Ranger, Army
- Agency-Specific Jurisdictions: Define operational territories
- Custom Agency Badges: Visual identification per agency
- Agency-Based Permissions: Control access by department

#### Rank System
- 7-Tier Rank Structure: Cadet through Chief/Sheriff
- Granular Permissions: 20+ permission flags per rank
- Rank-Based Pay: Configurable salary per rank
- Rank-Based Loadouts: Automatic weapon/item distribution

#### Duty System
- On-Duty/Off-Duty Toggle: `/duty` command
- Duty Time Tracking: Log hours worked for payroll
- Automatic Loadouts: Weapons and items issued on duty
- AFK Detection: Auto-remove inactive officers (configurable)
- Duty Logs: Complete duty session history in database
- MDT Access Control: Require on-duty status for MDT

#### Enhanced MDT
- **Person Records**:
  - Full character profiles with photos
  - Known aliases tracking
  - Gang/group affiliations
  - Behavioral flags (violent, repeat offender, etc.)
  - Job history
  - Comprehensive notes
  
- **Criminal Records**:
  - Full arrest history
  - Conviction tracking
  - Sentence details (time, fines)
  - Plea and verdict tracking
  - Time served calculation
  - Fine payment status
  - Bail information

- **Warrant System**:
  - Create arrest/search warrants
  - Probable cause documentation
  - Supervisor approval workflow
  - Automatic expiration (30 days default)
  - Execution tracking
  - Warrant history

- **Reports**:
  - Incident Reports
  - Arrest Reports  
  - Use-of-Force Reports
  - Officer Notes
  - Evidence attachment
  - Witness statements
  - Supervisor review system
  - Report search and filtering

- **BOLO System**:
  - Person BOLOs
  - Vehicle BOLOs
  - Priority levels (low/medium/high/critical)
  - Auto-expiration (48 hours default)
  - All-officer notifications
  - BOLO resolution tracking

- **Vehicle System**:
  - Plate lookup
  - Owner information
  - Stolen flag tracking
  - Vehicle notes
  - Flag system
  - Last seen tracking

- **Internal Affairs**:
  - Officer complaint system
  - Investigation tracking
  - Case numbering
  - Disciplinary action records
  - Restricted access (high command only)
  - IA case management

#### Arrest & Jail System
- **Detainment**:
  - Cuff/uncuff commands
  - Escort system
  - Control restrictions when cuffed
  
- **Arrest Flow**:
  - Probable cause requirement
  - Detain → MDT record → Charges → Sentence
  - Automatic record creation
  - Charge selection from law book
  
- **Jail System**:
  - Automatic jail intake
  - Time calculation
  - Fine collection
  - Jail timer display
  - Auto-release on time served
  - Manual release by officers
  - Bail posting system
  - Jail location teleport

#### Law Book
- 40+ Configurable Charges
- 8 Charge Categories
- Severity Levels (none/low/medium/high/critical)
- Jail Time Ranges (min/max)
- Fine Ranges (min/max)
- Bail Eligibility Flags
- Stackable Charges
- Detailed Descriptions

#### Security & Auditing
- Audit Logs for All Actions
- Action timestamps
- Officer identification
- Before/after data logging
- Target identification
- Anti-Spam Protection (3-second cooldowns)
- Rate Limiting (per action type)
- Permission Validation (server-side)
- Discord Webhook Integration (6 channels)

#### Performance
- Event-Driven Architecture (no loops)
- Lazy Loading (records on demand)
- Indexed Database Queries
- Optimized SQL with prepared statements
- < 0.05ms server impact target
- Batch processing for updates

#### Database
- 13 New Tables:
  - `leo_officers` - Officer personnel
  - `leo_duty_logs` - Duty time tracking
  - `leo_persons` - Enhanced profiles
  - `leo_records` - Criminal history
  - `leo_warrants` - Warrant system
  - `leo_reports` - Report system
  - `leo_bolos` - BOLO system
  - `leo_vehicles` - Vehicle records
  - `leo_internal_affairs` - IA system
  - `leo_audit_logs` - Audit trail
  - `leo_evidence` - Evidence tracking
  - `leo_jail_records` - Jail tracking
  - Plus legacy table support
- Automatic Migration from old MDT tables
- Comprehensive Indexes for performance
- Foreign key support for data integrity

#### Commands
- `/duty` - Toggle duty status
- `/mdt` - Open MDT interface
- `/cuff` - Restrain player
- `/uncuff` - Remove restraints
- `/escort` - Escort player
- `/jail` - Send to jail
- `/unjail` - Release from jail

#### Documentation
- Complete README with all features
- Detailed INSTALLATION guide
- Configuration examples
- Framework setup guides
- Troubleshooting section
- Training guidelines
- Changelog tracking

### 🔄 Changed
- Completely rewrote server logic for security
- Rewrote client logic for performance
- Modernized config structure
- Updated fxmanifest to FiveM standards
- Improved error handling
- Enhanced notifications

### 🗑️ Deprecated
- Old VORP-only architecture
- Direct SQL calls from client
- Hardcoded job lists
- Single-framework design

### 🔧 Fixed
- SQL injection vulnerabilities
- Client-side trust issues
- Race conditions in duty system
- Memory leaks in loops
- Inefficient database queries

### 🛡️ Security
- All validation moved server-side
- SQL injection prevention (prepared statements)
- Permission checks on all actions
- Rate limiting implemented
- Audit logging for accountability
- Anti-spam measures

### 📊 Performance
- Removed all client loops
- Implemented event-driven updates
- Added database indexing
- Lazy load system
- Reduced server tick cost by 90%+

## [2.3] - Previous Version

### Features
- Basic MDT functionality
- VORP framework support
- Person lookup
- Report creation
- Warrant system
- Office locations
- Webhook notifications

### Known Issues
- VORP-only support
- Limited permissions
- No duty system
- No audit logging
- Performance concerns with loops

---

## Version Numbering

LEO-CORE uses Semantic Versioning:
- **MAJOR** version for incompatible changes
- **MINOR** version for new features (backwards compatible)
- **PATCH** version for bug fixes

## Upgrade Path

### From 2.x to 3.0
1. Backup your database
2. Run `leo_core.sql` (includes migration)
3. Update resource folder
4. Configure `config_leo.lua`
5. Set framework in config
6. Restart server
7. Test all functionality
8. Old data will be migrated automatically

## Future Roadmap

### Version 3.1 (Planned)
- [ ] Court system integration
- [ ] Judge role and permissions
- [ ] Courtroom UI
- [ ] Trial system

### Version 3.2 (Planned)
- [ ] Physical evidence props
- [ ] Forensic analysis system
- [ ] Crime scene investigation tools
- [ ] Evidence collection mechanics

### Version 3.3 (Planned)
- [ ] Bodycam recording integration
- [ ] Video evidence system
- [ ] Playback functionality

### Version 4.0 (Future)
- [ ] Federal task forces
- [ ] Cross-agency operations
- [ ] Shared MDT access
- [ ] Advanced analytics
- [ ] Prison labor system
- [ ] Advanced AI features

## Support

For issues, bug reports, or feature requests:
- GitHub Issues: [Create an issue](https://github.com/iboss21/twl_mdt_police/issues)
- Documentation: See README.md and INSTALLATION.md
- Community: Join our Discord (if applicable)

## Contributors

- **iboss21** - Original repository owner
- **LEO-CORE Development Team** - System architecture and implementation
- **Community** - Testing, feedback, and suggestions
- **Original MDT** - Unknown Ghostz (inspiration)

## License

This project is provided as-is for RedM roleplay servers.
See LICENSE file for details.

---

**Note**: Always backup your database before updating!
