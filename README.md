TrustBase Demo
A Nigerian-focused consent and data-transparency platform demo with Flutter frontend and FastAPI backend.

Project Structure
frontend/ - Flutter mobile application
backend/ - FastAPI demo backend with mock data
designs/ - Design assets and specifications
docs/ - Documentation and demo scripts
Quick Start
Backend
cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --reload
Frontend
cd frontend
flutter pub get
flutter run
Features
Modern glassmorphism UI design
Multi-language support (Nigerian English, Igbo, Yoruba, Hausa)
YarnGPT integration with demo mode
Consent management and transparency timeline
Organization trust scoring
Demo Mode
This project runs entirely in demo mode with mock data and deterministic responses. No external APIs or production services are required.

See docs/run_instructions.md for detailed setup instructions.

