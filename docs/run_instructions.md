TrustBase Demo - Setup and Run Instructions
Complete guide to set up and run the TrustBase demo application locally.

Prerequisites
Flutter Development
Flutter SDK: 3.10.0 or higher
Dart SDK: 3.0.0 or higher
Android Studio or VS Code with Flutter extensions
Android Emulator or iOS Simulator (or physical device)
Backend Development
Python: 3.8 or higher
pip: Python package manager
Verification Commands
flutter --version
python --version
pip --version
Project Structure Overview
trustbase-demo/
├── frontend/           # Flutter mobile application
├── backend/           # FastAPI demo backend
├── designs/          # Design specifications and assets
├── docs/            # Documentation and guides
└── README.md        # Project overview
Backend Setup (FastAPI)
1. Navigate to Backend Directory
cd trustbase-demo/backend
2. Create Virtual Environment (Recommended)
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
3. Install Dependencies
pip install -r requirements.txt
4. Start Backend Server
# Development server with auto-reload
python -m uvicorn app.main:app --reload

# Or specify host and port explicitly
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
5. Verify Backend is Running
Open browser to http://localhost:8000
Should see: {"message": "TrustBase Demo API", "version": "1.0.0", "status": "running"}
API documentation: http://localhost:8000/docs
Health check: http://localhost:8000/health
Frontend Setup (Flutter)
1. Navigate to Frontend Directory
cd trustbase-demo/frontend
2. Install Flutter Dependencies
flutter pub get
3. Verify Flutter Setup
# Check for any setup issues
flutter doctor

# List available devices
flutter devices
4. Run Flutter Application
# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in debug mode with hot reload
flutter run --debug

# Run in release mode (for performance testing)
flutter run --release
5. Alternative: Run from IDE
VS Code: Open frontend folder, press F5 or Ctrl+F5
Android Studio: Open frontend folder, click “Run” button
Demo Data and Configuration
Backend Demo Data
The backend uses mock data stored in backend/app/seed_data.json:

3 demo users with different authentication methods
5 organizations (First Bank, MTN, Jumia, Paystack, Flutterwave)
4 consent records with various statuses
10 access log entries showing data access history
Demo User Credentials
Email/Password Login:

Email: Any valid email format (e.g., demo@trustbase.ng)
Password: Any password with 6+ characters (e.g., demo123)
Google Sign-in:

Click “Continue with Google” button (design-only, no real Google auth)
Returns demo user: Adaora Okafor
YarnGPT Demo Responses
Deterministic responses are configured in:

Frontend: frontend/lib/services/yarn_adapter.dart
Backend: backend/app/routes/yarn_adapter.py
Documentation: docs/yarn_prompts.md
Testing the Demo
1. Authentication Flow
# Test login endpoint
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "demo@trustbase.ng", "password": "demo123"}'
2. Organizations API
# Get organizations list
curl "http://localhost:8000/orgs/"

# Get specific organization
curl "http://localhost:8000/orgs/org_1"
3. YarnGPT Demo
# Test YarnGPT query
curl -X POST "http://localhost:8000/yarn/query" \
  -H "Content-Type: application/json" \
  -d '{"text": "Why did First Bank access my data?", "language": "en-ng"}'
4. Frontend Demo Flow
Launch app → Splash screen → Login
Login with any email/password → Dashboard
Dashboard → Wait for profile popup → Dismiss or proceed
Tap organization → View consent details → Revoke/grant consent
Menu → Access Timeline → View access logs
Timeline → Tap “Explain” → YarnGPT chat
YarnGPT → Ask questions → Test language switching
Settings → View profile → Test various options
Development and Customization
Adding New Organizations
Edit backend/app/seed_data.json:

{
  "id": "org_new",
  "name": "New Organization",
  "logo": "business",
  "trustScore": 8.0,
  "consentActive": true,
  "dataTypes": ["Custom Data Type"],
  "description": "Organization description",
  "category": "Custom Category"
}
Adding YarnGPT Responses
Edit frontend/lib/services/yarn_adapter.dart:

'new_keyword': {
  'text': 'New response text',
  'audioUrl': 'demo_audio/new_response.mp3',
}
Modifying UI Colors
Edit frontend/lib/utils/colors.dart:

static const Color primaryBlue = Color(0xFF0F4C75);
static const Color accentTeal = Color(0xFF3282B8);
Adding New Languages
Add language to frontend/lib/screens/yarn/yarn_chat.dart
Add responses to frontend/lib/services/yarn_adapter.dart
Create corresponding audio files
Update backend yarn_adapter.py
Troubleshooting
Common Backend Issues
Issue: ModuleNotFoundError: No module named 'fastapi' Solution:

pip install -r requirements.txt
Issue: Port 8000 already in use Solution:

# Use different port
python -m uvicorn app.main:app --port 8001 --reload

# Or kill process using port 8000
# Windows: netstat -ano | findstr :8000
# macOS/Linux: lsof -ti:8000 | xargs kill
Issue: CORS errors when accessing from Flutter Solution: Backend already configured for CORS. Ensure backend is running on localhost:8000

Common Frontend Issues
Issue: flutter: command not found Solution: Install Flutter SDK and add to PATH

Issue: No devices available Solution:

# Start Android emulator
flutter emulators --launch <emulator-id>

# Or connect physical device with USB debugging enabled
Issue: Gradle build failed Solution:

cd frontend/android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
Issue: Audio files not playing Solution: Ensure audio files exist in frontend/assets/demo_audio/

Issue: Network error connecting to backend Solution:

Verify backend is running on http://localhost:8000
Check device/emulator can reach localhost
For physical devices, use computer’s IP address instead of localhost
Performance Issues
Issue: Slow animations or UI lag Solution:

# Run in release mode for better performance
flutter run --release

# Or enable performance overlay
flutter run --enable-software-rendering
Issue: Backend API slow responses Solution: This is intentional demo behavior (0.8-2.0 second delays). To remove:

# In backend/app/routes/yarn_adapter.py, comment out:
# await asyncio.sleep(random.uniform(0.8, 2.0))
Production Deployment Considerations
Backend Deployment
Use production ASGI server (Gunicorn + Uvicorn)
Replace in-memory data store with real database (PostgreSQL)
Implement proper JWT authentication
Add rate limiting and security headers
Use environment variables for configuration
Frontend Deployment
Build release APK: flutter build apk --release
Build iOS app: flutter build ios --release
Configure proper API endpoints for production
Implement real Firebase authentication
Add crash reporting and analytics
YarnGPT Integration
Set up GPU-enabled server for YarnGPT model
Implement proper audio file storage (AWS S3, Google Cloud Storage)
Add request queuing and load balancing
Implement caching for repeated queries
Set up monitoring and logging
Getting Help
Documentation
API Documentation: http://localhost:8000/docs (when backend is running)
Flutter Documentation: https://flutter.dev/docs
FastAPI Documentation: https://fastapi.tiangolo.com/
Demo-Specific Help
Demo Script: docs/demo_script.md
YarnGPT Prompts: docs/yarn_prompts.md
Design Guidelines: designs/colors.md, designs/typography.md
Common Commands Reference
# Backend
cd backend
python -m uvicorn app.main:app --reload

# Frontend  
cd frontend
flutter pub get
flutter run

# Reset demo data
curl -X POST "http://localhost:8000/seed/load"

# Check backend health
curl "http://localhost:8000/health"
Next Steps
Review Code: Explore the modular architecture and clean code structure
Test Demo: Follow docs/demo_script.md for comprehensive testing
Customize: Modify colors, add organizations, or extend functionality
Integrate YarnGPT: Follow integration guide in yarn_adapter.py comments
Deploy: Plan production deployment with real authentication and database
For questions or issues, refer to the comprehensive documentation in the docs/ directory or review the well-commented source code.

