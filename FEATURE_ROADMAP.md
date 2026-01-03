# Area51 - Complete Feature Roadmap

> Bachelor Mess Manager | Flutter 3.35+ | Bangladesh

---

## 📊 Feature Categories

### 🟢 Core (MVP)
- [x] Meals, Bazar, Balance ✅ Implemented
- [x] Members, Roles (7 roles) ✅ Implemented
- [x] Money Give/Take ✅ Implemented
- [x] Vacation Mode ✅ Implemented
- [x] Login/Signup + Mess Selection ✅ Implemented

### 🟡 Phase 2 (Essential)
- [x] Unified Entry System ✅ Implemented (NLP auto-detect)
- [x] Guest Meals ✅ Implemented (UI + model)
- [x] Temporary Members ✅ Implemented (date fields)
- [x] Ramadan Module ✅ Implemented (full screen with sehri/iftar tracking)
- [x] Settlement Workflow ✅ Implemented (who-owes-whom, PDF export)
- [x] Push Notifications with options ✅ Implemented (settings UI)

### 🔵 Phase 3 (Advanced)
- [x] Reports & Export (Charts) ✅ Implemented
- [x] NLP Categorization ✅ Implemented
- [x] Voice Entry ✅ Implemented (simulated speech-to-text)
- [x] DESCO Meter API ✅ Implemented (smart caching)
- [x] Duty Rotation System ✅ Implemented (schedules, assignments, weekly generation)
- [x] Home Screen Widget ✅ Implemented (data provider ready)

### 🟣 Phase 4 (Future)
- [ ] Receipt OCR Scanner
- [ ] bKash/Nagad (if free)

---

## 🍽️ Meal System

### Core Features
| Feature | Description |
|---------|-------------|
| **Count Logic** | Default 2 = lunch + dinner. >2 = guest meal |
| **Quick Entry** | 1-tap meal add per member |
| **Bulk Entry** | ✅ Add 2-3 days or 1 week at once |
| **Cancel Advance** | Cancel future meals before deadline |
| **Time Lock** | Admin sets: 12pm lunch, 7pm dinner cutoff |
| **Food Preferences** | Member dietary notes visible |

### Guest Meals
> **Members declare guest meals BEFORE the meal is prepared** via notification response.

```
Guest Meal Flow:
├─ Notification: "Today you have lunch. Bringing guests?"
├─ Member responds: Yes/No + guest count
├─ Optional: Guest name (auto-suggest frequent)
├─ Optional: Split cost with members
└─ Meal manager sees total (members + guests)
```

### Guest History & Tracking
- Track who brings guests often
- "Siam brought 15 guests this year"
- VIP guest list (auto-add frequent names)

### Time Restrictions (Admin Configurable)
| Meal | Add/Edit Deadline | Cancel Deadline |
|------|-------------------|-----------------|
| Breakfast | 8:00 AM | 7:00 AM |
| Lunch | 12:00 PM | 11:00 AM |
| Dinner | 7:00 PM | 6:00 PM |

> Only admins can edit after deadlines

---

## 🛒 Unified Entry System (Bazar + Monthly)

> **One entry point, NLP auto-detects type.** User can override.

### How It Works
```
User enters: "Soap 45 tk" or just "500"
    ↓
NLP auto-detects:
├─ "Soap, Tissue, Toothpaste" → Monthly
├─ "Rice, Oil, Fish, Vegetables" → Meal Bazar
├─ "Rent, Wifi, Electricity" → Fixed/Monthly
└─ Ambiguous → Ask user
    ↓
User can override selection before saving
```

### Splitting Logic
| Type | Split Method |
|------|--------------|
| **Meal Bazar** | Divided by **meal ratio** (who ate how much) |
| **Monthly** | Divided **equally** among all members |
| **Fixed Bills** | Divided **equally** (Rent, WiFi, Maid, etc.) |

### Monthly Entry Types (from your Excel)
| Category | Examples |
|----------|----------|
| **Rent** | House rent |
| **Utilities** | Electricity, Gas, Wifi |
| **Amenities** | Soap, Tissue, Toothpaste, Wheel, Coil |
| **Services** | Maid/Bua, Garbage Collector |
| **Others** | Filter, Water Pot, etc. |

### Entry Modes
| Mode | UX | When to Use |
|------|-----|-------------|
| **Quick** (Default) | Amount + Auto-detect → Done | Most users |
| **Detailed** | Items + Receipt photo | Optional itemized |
| **Bulk** | Rice 500, Oil 200... | Power users |

> **Minimal clicks**: Just enter "500" → NLP detects → Done!

### Photo & Receipts
- 📸 Bazar photos (multiple, optional)
- 🧾 Receipts section (optional)
- 📍 Location auto-opens Bazar mode (future)
- 🖼️ Gallery Mode: View all receipts as images

### Smart Features
- **NLP Auto-Categorization**: Learns from history
- **Templates**: Save "Weekly groceries"
- **Suggestions**: "You usually buy rice on Fridays"
- **Price Trends**: Category price history charts
- **Expense Timer**: Days since last bazar
- **Expense Watchlist**: Alert when item exceeds usual

### Shared Bazar List
- Central list anyone can add to
- Claim "I'll buy this"
- Auto-clear when purchased

---


## 🌙 Ramadan Module

### Structure
```
Ramadan Season (spans 2 months, e.g., mid-March to mid-April):
├─ Opt-in members only
├─ Separate bazar pool
├─ Separate meal tracking (Sehri/Iftar)
├─ Temporary Ramadan members allowed
├─ Pro-rate: Join mid-Ramadan OK
└─ Regular meals can run parallel
```

### Calculations
- Isolated from regular mess
- Own meal rate calculation
- Export separately

---

## 👥 Member System

### Roles & Permissions
| Role | Permissions |
|------|-------------|
| **Super Admin** | **Everything** + transfer ownership + change any setting |
| **Admin** | Edit past, bypass time lock, approve, view all charts |
| **Meal Manager** | Bulk meal ops only |
| **Maintenance** | Fixed expenses only |
| **Member** | Own entries, add guest meals |
| **Temp Member** | Member + active dates |
| **Guest** | View only |

### Temporary Members
- Active date range (Jan 15 - Feb 28)
- Month-to-month additions
- Auto-suggest removal when inactive
- Seamless → Permanent transition

### Member Lifecycle
```
signup → select mess (Area51) → pending → admin approves → active
```

---

## 💰 Money & Settlement

### Give/Take System
- Transaction requires **receiver confirmation**
- Optional photo proof (admin verifiable)
- Negative = receiving back
- Separate pools: Meals vs Monthly

### Balance Breakdown ("Why Am I in Debt?")
```
Your Balance: -৳1,250 (DEBT)
─────────────────────────────
🍽️ MEALS: 45 × ৳52.30 = ৳2,354
🛒 YOUR BAZAR: ৳1,200
  ├─ Jan 5: Rice ৳500
  ├─ Jan 12: Fish ৳400
  └─ Jan 20: Vegetables ৳300
💡 Why: Ate more than contributed
```

### Settlement Workflow
1. End of month → Calculate final balances
2. System shows who owes whom
3. Record payments with proof
4. Clear balances for new month

### Late Payment Penalty (Optional)
- Admin enables
- X% after Y days overdue
- Configurable or disable

### Carry Forward
- ৳500 extra → Deduct next month
- Tracked in balance

### Split Calculator
- Quick split any amount by N people

---

## 🏖️ Vacation Mode

### Features
```
Mark vacation:
├─ Start: Date + Last meal (lunch/dinner)
├─ End: Date + First meal back
├─ Auto meal-off for range
├─ Others notified
└─ Fixed expenses STILL apply (rent, wifi, bua)
```

### Fixed Expenses During Vacation
| Type | Applies During Vacation |
|------|------------------------|
| Rent | ✅ Yes |
| WiFi | ✅ Yes |
| Bua | ✅ Yes |
| Emergency bills | ✅ Yes |
| Meals | ❌ No |

---

## 🔔 Notifications (with options)

| Trigger | Notification |
|---------|-------------|
| Missing today's meal | "Log your meal yet?" |
| Bazar overdue | "X days since bazar" |
| Bill due | "Rent due in 3 days" |
| Price spike | "Rice up 15% this month" |
| Bazar roster | "Your turn this week" |
| Low DESCO | "Meter balance low" |
| Guest prompt | "Add guest meals?" |
| New entry | "Tanmoy added bazar" |

---

## 📊 Reports & Export

### Export Formats
| Format | Description |
|--------|-------------|
| XLSX | Excel with sheets |
| CSV | ✅ Simple spreadsheet |
| PDF | ✅ Printable report |
| JSON | Developer format |
| SQLite/DB | Full database backup |
| Google Sheets | Direct export |

### Analytics & Monthly Insights
- Monthly charts
- Category breakdowns
- Member comparison (anonymous)
- Contribution streaks ("3 months on-time!")
- "You ate 12% more meals than average"
- "Bazar spending trending up"
- Import from Excel for historical trends

### 📈 Visualizations

#### For All Members (Important)
| Chart | Description |
|-------|-------------|
| **Balance Donut** | Visual credit/debt status |
| **Monthly Meal Bar** | Your meals vs average |
| **Spending Trend Line** | Last 6 months spending |
| **Category Pie** | Bazar breakdown (Rice, Fish, etc.) |
| **Contribution Progress** | How much you've contributed |

#### For Admin/Super Admin (All Charts)
| Chart | Description |
|-------|-------------|
| **Total Bazar Line** | Monthly bazar totals over time |
| **Meal Rate Trend** | Meal rate per month |
| **Member Heatmap** | Who ate most/least each day |
| **Guest Frequency Bar** | Who brings most guests |
| **Expense Category Stack** | Fixed vs Variable expenses |
| **Settlement Flow** | Who owes whom (Sankey diagram) |
| **Payment Timeline** | When payments happen |
| **Price Trend Multi-Line** | Rice, Oil, Fish prices over time |
| **Contribution Ranking** | Anonymous or named |
| **Vacation Calendar** | Who's away when |
| **Duty Completion** | Who completed duties |
| **Budget vs Actual** | Target vs real spending |


---

## 🏠 Important Info Page ✅

### Contacts
- Landlord, Bua (maid), Watchman
- Garbage collector, Emergency numbers

### House Info
- Address + Google Maps link
- WiFi password, FTP server details
- House rules (official 11 rules)
- Utility account numbers

---

## 🔧 Special Features

### Party/Occasion Splitter ✅
- Outside food, Duck Party, etc.
- Split only, no meal entry OR partial meal entry

### DESCO Prepaid Meter
- Balance check via API
- Low balance warning, Recharge reminder

### Generator Fuel
- Fuel cost splitting
- Per-usage or equal share

### Auto Month Close
- Automatically close month on 5th
- Generate final balances

---

## ⚖️ Dispute System

```
Entry flagged → Admin reviews → Resolution logged
```

### Edit Proof Requirements (Admin Only)
| Amount Changed | Required Proof |
|---------------|----------------|
| < ৳200 | Statement only |
| ৳200-500 | Photo OR statement |
| > ৳500 | Photo AND statement |

---

## 🔄 Duty Rotation System

### Types
| Type | Scope | Rotation |
|------|-------|----------|
| Room Cleaning | Room-based | Among roommates |
| Dining Cleanup | Global | All members |
| Bazar Duty | Global | Weekly roster |

### Features
- Photo proof after completion
- Courtesy tracking (if one did multiple times → other owes)
- Auto-rotate weekly

---

## 🏗️ Edge Cases

### Member Lifecycle
| Scenario | Solution |
|----------|----------|
| Temp → Permanent | Seamless transition |
| Inactive months | Auto-suggest removal |
| Conflicting edits | Last-write-wins + notify |
| Offline entries | Queue + merge with timestamp |
| Crash during save | Auto-draft save |
| High expense | Require admin/member approval |

### Ramadan/Seasonal
| Scenario | Solution |
|----------|----------|
| Spans 2 months | Single Ramadan season |
| Join late | Pro-rate from opt-in date |
| Regular + Ramadan | Both can be active |

### Mess Lifecycle
| Scenario | Solution |
|----------|----------|
| Mess disbands | Final settle + archive + export |
| Super Admin leaves | Auto-assign to next senior member (by join date) |
| Admin leaves | Role removed, no auto-assign |
| All leave | Inactive after 30 days |

---

## 🎨 UI/UX Libraries (2025-2026)

### Animation & Effects
```yaml
flutter_animate: ^4.5.0      # Chainable animations
lottie: ^3.2.0               # After Effects
rive: ^0.13.0                # Interactive vectors
spring_button: ^2.0.0        # Springy effects
confetti_blast: ^1.0.0       # Celebrations
shimmer: ^3.0.0              # Skeleton loading
haptic_feedback: ^0.5.0      # Vibration
```

### Lists, Forms & Charts
```yaml
flutter_slidable: ^3.1.0     # Swipe actions
flutter_form_builder: ^9.0.0
flutter_typeahead: ^5.0.0    # Autocomplete
fl_chart: ^0.70.0            # Beautiful charts
```

### Modern UI
```yaml
flex_color_scheme: ^8.0.0    # Theming
glassmorphism_ui: ^0.3.0     # Glass effects
animated_text_kit: ^4.2.0    # Text animations
```

---

## 📱 Platform Features

### Android/iOS
- **Home Widget**: Balance at glance
- **Quick Actions**: 3D Touch / long-press shortcuts
- **Offline Mode**: Queue + sync
- **Sync Indicator**: Show if data synced or pending

### Voice & Location
```yaml
speech_to_text: ^7.0.0       # "Add 500 taka bazar for rice"
geolocator: ^13.0.0          # Auto Bazar mode near market
google_ml_kit: ^0.18.0       # Receipt OCR (future)
```

---

## 🔐 Privacy & Security

| Feature | Description |
|---------|-------------|
| Privacy Mode | Hide balance from screen |
| Biometric Lock | Fingerprint/Face |
| Quick Share | Share balance as image |
| Themes | Dark mode, custom colors |

---

## 💡 Smart Features

- **NLP Categorization**: Auto-detect bazar vs monthly
- **Budget Goals**: "Keep bazar under ৳15,000"
- **Search Everything**: Global search + pin entries
- **Food Preferences**: Member dietary notes

---

## 📋 Personal Features

- **Separate Loan Section**: Personal give/take (not mess)
- **Shared Bazar List**: Central list, claim items

---

## 🚀 Future Ideas

| Feature | Priority |
|---------|----------|
| Receipt OCR (Shwapno/Agora) | Medium |
| bKash/Nagad Integration | Low (cost) |
| Auto Month Close (5th) | High |
| Gallery Mode (all receipts) | Medium |
| Import from Excel | High |

---

## 📁 Project Structure

```
lib/
├── core/           # Models, Providers, Services, Router, Theme
├── features/
│   ├── auth/       # Login, Signup
│   ├── dashboard/  # Home
│   ├── meals/      # Meal tracking
│   ├── bazar/      # Bazar + List
│   ├── balance/    # Balance view
│   ├── members/    # Member mgmt
│   ├── money/      # Give/Take
│   ├── vacation/   # Leave mode
│   ├── ramadan/    # Ramadan module
│   ├── analytics/  # Reports
│   ├── duties/     # Rotation
│   ├── expenses/   # Fixed bills
│   ├── contacts/   # Important info
│   ├── personal/   # Personal loans
│   └── settings/   # Preferences
└── shared/widgets/ # Reusable UI
```

---

*Last updated: January 3, 2026*
