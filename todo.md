TrustBase Demo Implementation Plan
Core Files to Create
Frontend (Flutter)
frontend/pubspec.yaml - Flutter dependencies
frontend/lib/main.dart - App entry point
frontend/lib/utils/colors.dart - Brand colors
frontend/lib/utils/theme.dart - App theme
frontend/lib/screens/splash_screen.dart - Animated splash
frontend/lib/screens/auth/login_screen.dart - Login with Google design
frontend/lib/screens/dashboard/dashboard_screen.dart - Main dashboard
frontend/lib/screens/consent/consent_detail.dart - Consent management
frontend/lib/screens/timeline/timeline_screen.dart - Access timeline
frontend/lib/screens/yarn/yarn_chat.dart - YarnGPT chat interface
frontend/lib/services/yarn_adapter.dart - Demo YarnGPT adapter
Backend (FastAPI)
backend/requirements.txt - Python dependencies
backend/app/main.py - FastAPI app
backend/app/routes/auth.py - Auth endpoints
backend/app/routes/orgs.py - Organization endpoints
backend/app/routes/consents.py - Consent endpoints
backend/app/routes/yarn_adapter.py - YarnGPT demo adapter
backend/app/seed_data.json - Mock data
Documentation & Assets
designs/colors.md - Brand color specifications
docs/yarn_prompts.md - Deterministic YarnGPT responses
docs/demo_script.md - Step-by-step demo guide
docs/run_instructions.md - Setup instructions
Implementation Order
Create project structure and dependencies
Implement brand colors and theme system
Build core screens with glassmorphism design
Create backend with demo endpoints
Implement YarnGPT demo adapter
Add documentation and assets
Test complete demo flow
