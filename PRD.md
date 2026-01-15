## The Land of Wolves - Police System + MDT (leo-core)

Brand: The Land of Wolves | Owner: iBoss | Website: www.wolves.land

### 1. Product Overview
- **Platform:** RedM (RDR2)
- **Framework Compatibility:** Primary: RSG-Core; Secondary: LXR-Core; Optional adapters/extensions for VORP
- **Target Users:** Sheriff Departments, Police Departments, Rangers/Marshals, optional Army/Federal units
- **Core Goal:** Realistic, performant, abuse-resistant LEO system with law-enforcement gameplay loops, roleplay-first interactions, centralized MDT with persistent data, clear authority separation, no arcade elements, full logging.

### 2. Core Design Principles
- Server-authoritative logic (no client trust)
- MDT as the single source of truth
- Audit logs for everything
- RP realism over convenience
- Extensible by config, not rewrites
- Low tick cost / event-driven

### 3. Agencies & Roles
**Agencies:** Configurable Sheriff, Police, Ranger, Marshal, Army (optional, restricted) with jurisdiction rules, rank ladder, allowed actions, MDT access scope.

**Ranks (example, configurable):** Cadet; Deputy/Officer; Senior Officer; Sergeant; Lieutenant; Captain; Chief/Sheriff. Ranks control MDT permissions, arrest authority, warrant approval, weapon access, admin actions.

### 4. Player State & Duty System
- On-duty / Off-duty toggle
- Uniform enforcement per rank
- Loadout assignment per role
- Duty time tracking (logs & payroll)
- AFK + abuse prevention
- Hard rules: No MDT access off-duty; no arrest powers off-duty; no weapon spawning without duty.

### 5. MDT (Mobile Data Terminal)
Heart of system.

**Access:** Keybind + vehicle dash access; station terminals; tablet item (optional).

**Modules:**
1. Person Records: profile, photo/mugshot, aliases, job history, affiliations, flags.
2. Criminal Records: arrests, charges, convictions, sentences, warrants, fines.
3. Warrants: create (probable cause), supervisor approval, active/expired/executed, search vs arrest warrants.
4. Vehicles: ownership lookup, stolen flag, plate search, vehicle notes.
5. Reports: incident, arrest, use-of-force, officer notes, evidence attachments (text-based).
6. BOLO System: person/vehicle BOLO, priority levels, auto-expiration.
7. Jail & Fines: sentence calculation, intake, time served, fine issuance, payment status.
8. Internal Affairs: complaints, investigation notes, disciplinary actions; restricted to high command.

### 6. Arrest & Detainment System
- Soft detain (escort); hard cuffs; hogtie (contextual/configurable)
- Arrest flow: probable cause → detain → MDT arrest record → select charges → sentence/fine calculation → jail or release; no instant teleport unless configured.

### 7. Charges & Law Book
Centralized law config including severity, jail time range, fine range, bail eligibility; supports stacking, judicial override, judge role integration (future).

### 8. Evidence System (Phase 1 – Logical)
Evidence as records, not props. Types: weapon used, witness statement, officer testimony, chain of custody logs. (Physical props = Phase 2).

### 9. Permissions & Security
- Rank-gated MDT actions
- Server-side validation for arrests, warrants, fines
- Anti-spam & cooldowns
- Full action logging
- Admins can audit without interfering.

### 10. Database Design (High-Level)
Core tables: `leo_officers`, `leo_duty_logs`, `leo_persons`, `leo_records`, `leo_warrants`, `leo_reports`, `leo_bolos`, `leo_vehicles`, `leo_internal_affairs`. Indexes on `character_id`, `citizenid`, `plate`, `warrant_status`. Single shared DB.

### 11. UI / UX Requirements
- Clean MDT UI (desktop + tablet)
- Fast search (debounced)
- No heavy animations
- Keyboard-first workflow
- Minimal clicks for arrests
- Dark mode mandatory.

### 12. Performance Requirements
- Zero constant loops; event-driven MDT updates
- Lazy-load records; server callbacks batched; no client SQL calls
- Target (aggressive/aspirational): ideal-case benchmark of <0.1–0.2ms average server impact for core event handler overhead (in-handler logic before any DB/HTTP/file I/O) when profiled via resmon; adjust to what your hardware realistically supports.
- Baseline target (production): keep average handler overhead under ~1ms with occasional spikes up to ~2ms.
- Database-driven flows measured separately; 0.5–1ms+ budgets are acceptable under load for DB-backed handlers.
- Measurement guidance: profile with resmon (default ~1s samples) or txAdmin profiler (set Performance Monitor sampling interval to ~1000ms in settings) over ≥5 minutes of representative duty scenarios (routine patrols, warrant work, 5–10 active officers and 20–30 total players) under typical player load; consider spikes acceptable if <5% of samples exceed the baseline target.
- Practical guidance: treat the aspirational target as best-case and tune thresholds to maintain stability in production.
- Target (MDT load): <300ms against local DB.

### 13. Configurability
Everything adjustable via config: agencies, ranks, charges, sentencing rules, MDT permissions, jurisdiction rules; no hardcoded logic.

### 14. Logging & Auditing
Log arrests, warrants, MDT edits, duty toggles, use-of-force flags. Logs readable in-game + DB.

### 15. Out of Scope (Explicitly)
- Courtroom UI (future)
- Physical evidence props (future)
- Bodycam video (future)
- AI judges (future)

### 16. Success Metrics
- Zero exploit paths for arrest/fines
- Clear RP authority hierarchy
- Players understand consequences
- Admins can audit without admin abuse
- LEO gameplay loop feels meaningful, not grindy

### 17. Future Phases (Roadmap)
- Judge & Court System
- Prison labor integration
- Evidence props + forensic system
- Federal task forces
- Cross-agency task force MDT sharing

### Next Logical Steps
- DB schema (exact SQL)
- MDT UI wireframe
- Config.lua skeleton
- Event map (server/client flow)
