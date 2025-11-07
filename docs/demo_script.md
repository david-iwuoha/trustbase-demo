TrustBase Demo Script
Step-by-step demonstration guide for the TrustBase Nigerian consent and data-transparency platform.

Pre-Demo Setup
Start Backend Server

cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --reload
Start Flutter App

cd frontend
flutter pub get
flutter run
Verify Demo Data

Visit http://localhost:8000/health to confirm backend is running
Ensure demo audio files are in frontend/assets/demo_audio/
Demo Flow (15-20 minutes)
1. App Launch & Authentication (3 minutes)
Step 1.1: Splash Screen

Launch the app
Show: Animated TrustBase logo with glassmorphism effect
Highlight: Smooth 1.5-second animation with brand colors
Transition: Automatic slide-up to login screen
Step 1.2: Login Screen

Show: Modern glassmorphism login card
Highlight: Google sign-in button (design-only) and email/password form
Demo Login: Use any email (e.g., demo@trustbase.ng) and password (demo123)
Expected: Smooth transition to dashboard after successful login
Step 1.3: Session Persistence

Close and reopen app
Show: App automatically navigates to dashboard (bypassing login)
Highlight: Seamless user experience with session management
2. Dashboard Overview (4 minutes)
Step 2.1: Dashboard Entry

Show: Staggered animation of dashboard elements
Wait: 2-3 seconds for profile setup popup to appear
Popup Content: “Adaora, finish setting up your profile.”
Demo: Click “Cancel” to dismiss (or “Proceed” to show design-only message)
Step 2.2: Dashboard Components

Summary Cards: Point out glassmorphism effect on:
Active Consents: 3
Revoked: 1
Recent Access: 12
Organization List: Show 4 demo organizations:
First Bank Nigeria (Trust Score: 8.5, Active)
MTN Nigeria (Trust Score: 7.8, Active)
Jumia (Trust Score: 7.2, Revoked)
Paystack (Trust Score: 9.1, Active)
Step 2.3: Language & Navigation

Language Selector: Tap language icon, show 4 Nigerian languages
Hamburger Menu: Show navigation options (Timeline, Settings, Logout)
User Avatar: Tap to navigate to settings
3. Consent Management (4 minutes)
Step 3.1: Organization Details

Tap: First Bank Nigeria card
Show: Consent detail screen with:
Organization info and trust score
Consent status (Active)
Data types shared: Personal Info, Financial Data, Transaction History
Consent history with timestamps
Step 3.2: Consent Revocation

Tap: “Revoke Consent” button
Show: Confirmation dialog
Confirm: Revoke consent
Expected: Status changes to “Revoked”, timeline entry created
Navigate: Back to dashboard to see updated summary
Step 3.3: Consent Toggle

On Dashboard: Toggle Jumia consent switch from OFF to ON
Show: Snackbar confirmation message
Highlight: Real-time UI updates
4. Transparency Timeline (3 minutes)
Step 4.1: Access Timeline

Navigate: Hamburger menu → Access Timeline
Show: Chronological list of 10 access log entries
Highlight: Different organizations, data types, and purposes
Point out: Approved vs. Denied status indicators
Step 4.2: Timeline Details

Show entries for:
First Bank: Transaction History for loan verification
MTN: Usage Data for service optimization
Paystack: Payment Info for transaction processing
Jumia: Purchase History (DENIED) for recommendations
Step 4.3: YarnGPT Integration

Tap: “Explain with YarnGPT” on any timeline entry
Expected: Navigate to YarnGPT chat with pre-filled query
5. YarnGPT Assistant Demo (4 minutes)
Step 5.1: Chat Interface

Show: Clean chat interface with language selector
Current Language: Nigerian English (default)
Initial Message: YarnGPT welcome message displayed
Step 5.2: Demo Queries (Test each)

Query 1: “Why did First Bank Nigeria access my transaction history?”

Expected Response: Banking-specific explanation about creditworthiness and CBN regulations
Audio: Click play button to demonstrate audio playback
Language: Switch to Igbo, ask same question, show different response
Query 2: “Explain why MTN accessed my usage data”

Expected Response: Telecom-specific explanation about network optimization
Audio: Demonstrate audio playback in Nigerian English
Query 3: “What are my consent rights in Nigeria?”

Expected Response: Comprehensive rights explanation
Demo: Switch language to Yoruba, ask same question
Show: Response in Yoruba with corresponding audio
Step 5.3: Language Switching

Demonstrate: All 4 supported languages
Nigerian English
Igbo
Yoruba
Hausa
Show: Consistent deterministic responses across languages
6. Settings & Profile (2 minutes)
Step 6.1: Settings Screen

Navigate: User avatar → Settings
Show: User profile with glassmorphism design
Sections:
Profile info (Adaora Okafor, demo@trustbase.ng)
Language & Preferences
Privacy & Data options
Support & About
Step 6.2: Settings Features

Language: Change app language (design-only)
Notifications: Toggle push notifications
Biometric: Toggle fingerprint auth (design-only)
Data Export: Show export option (design-only)
About: Show app version and demo notice
Key Demo Points to Emphasize
1. Modern Design System
Consistent glassmorphism effects on all cards and modals
Smooth Telegram-like transitions between screens
Cohesive color scheme with trust-focused blues and teals
Professional typography with Inter font family
2. Nigerian Context
Multi-language support for major Nigerian languages
Local organizations (First Bank, MTN, Jumia, Paystack)
Culturally relevant consent explanations
Trust scoring system for organizations
3. Privacy-First Approach
Clear consent status indicators
Detailed access logging with purposes
Easy consent revocation process
Transparent data usage explanations
4. YarnGPT Integration
Deterministic demo responses (no external API required)
Multi-language audio generation simulation
Context-aware explanations
Clear path for real YarnGPT integration
5. Technical Excellence
Session persistence and authentication flow
Responsive UI with proper loading states
Error handling and user feedback
Modular architecture ready for production
Troubleshooting Common Issues
Issue: Login fails Solution: Use any email with @ symbol and password with 6+ characters

Issue: Audio doesn’t play Solution: Ensure demo audio files are in frontend/assets/demo_audio/

Issue: Backend not responding Solution: Verify backend is running on http://localhost:8000

Issue: Profile popup doesn’t appear Solution: Wait 2-3 seconds after dashboard loads

Issue: YarnGPT responses are slow Solution: This is intentional to simulate real API delay (0.8-2.0 seconds)

Demo Variations
Quick Demo (5 minutes)
Login → Dashboard overview
Tap one organization → Show consent details
Open YarnGPT → Ask one question in English
Show timeline → Explain transparency
Technical Demo (25 minutes)
Include backend API exploration
Show code structure and architecture
Demonstrate real YarnGPT integration path
Discuss production deployment considerations
Business Demo (10 minutes)
Focus on user experience and trust features
Emphasize Nigerian market relevance
Highlight competitive advantages
Discuss monetization and partnership opportunities
Post-Demo Actions
Share Repository: Provide GitHub link for code review
Documentation: Direct to docs/run_instructions.md for setup
Next Steps: Discuss YarnGPT integration timeline
Feedback: Collect specific feature requests and improvements
Production Planning: Review deployment and scaling requirements
