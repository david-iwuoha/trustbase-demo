TrustBase Demo Backend
FastAPI backend for the TrustBase Nigerian consent and data-transparency platform demo.

Features
Authentication: Demo login with email/password and Google sign-in simulation
Organizations: Nigerian companies with trust scores and consent management
Consents: Grant, revoke, and track data consent permissions
Access Logs: Transparent logging of all data access attempts
YarnGPT Integration: Demo mode with deterministic responses in 4 Nigerian languages
Quick Start
1. Install Dependencies
pip install -r requirements.txt
2. Run Development Server
python -m uvicorn app.main:app --reload
3. Access API Documentation
Interactive Docs: http://localhost:8000/docs
Health Check: http://localhost:8000/health
API Root: http://localhost:8000
API Endpoints
Authentication
POST /auth/login - Email/password login
POST /auth/google-signin - Google sign-in (design-only)
POST /auth/session-check - Validate session token
POST /auth/logout - Logout and invalidate token
Organizations
GET /orgs/ - List organizations with filtering
GET /orgs/{org_id} - Get organization details
GET /orgs/categories/list - Get organization categories
GET /orgs/trust-scores/summary - Trust score statistics
Consents
GET /consents/ - Get user consents with filtering
GET /consents/{consent_id} - Get consent details
POST /consents/grant - Grant new consent
POST /consents/revoke - Revoke existing consent
GET /consents/{consent_id}/history - Get consent history
GET /consents/stats/summary - Get consent statistics
Access Logs
GET /access-logs/ - Get access logs with filtering
GET /access-logs/{log_id} - Get specific access log
GET /access-logs/stats/summary - Get access statistics
POST /access-logs/simulate - Create demo access log
YarnGPT
POST /yarn/query - Query YarnGPT with deterministic responses
GET /yarn/languages - Get supported languages
GET /yarn/demo/prompts - Get demo prompts and responses
Utilities
GET /health - Health check endpoint
POST /seed/load - Reload demo data
Demo Data
The backend uses mock data stored in app/seed_data.json:

Users: 3 demo users with different authentication methods
Organizations: 5 Nigerian companies (banks, telecom, fintech, e-commerce)
Consents: Sample consent records with various statuses
Access Logs: Historical data access records
Demo Authentication
Email/Password
Email: Any valid email format (e.g., demo@trustbase.ng)
Password: Any password with 6+ characters (e.g., demo123)
Google Sign-in
Click endpoint returns predefined demo user
No real Google authentication implemented
YarnGPT Demo Mode
The YarnGPT integration runs in demo mode with deterministic responses:

Supported Languages
en-ng: Nigerian English
ig: Igbo
yo: Yoruba
ha: Hausa
Response Types
Default: General privacy information
Banking: Bank data access explanations
Telecom: Telecommunications data usage
Rights: User consent rights information
Explain: General access explanations
Example Queries
# Nigerian English
curl -X POST "http://localhost:8000/yarn/query" \
  -H "Content-Type: application/json" \
  -d '{"text": "Why did First Bank access my data?", "language": "en-ng"}'

# Igbo
curl -X POST "http://localhost:8000/yarn/query" \
  -H "Content-Type: application/json" \
  -d '{"text": "Gịnị mere First Bank ji nweta data m?", "language": "ig"}'
Real YarnGPT Integration
To replace demo mode with real YarnGPT:

1. Set Up YarnGPT Server
# Clone YarnGPT repository
git clone <yarngpt-repo-url>
cd yarngpt

# Install dependencies
pip install torch transformers torchaudio

# Download model checkpoints
# Configure WavTokenizer paths
# Start inference server
2. Update Backend Configuration
# In app/routes/yarn_adapter.py
YARNGPT_SERVER_URL = "http://localhost:8001"  # Your YarnGPT server

async def yarn_query_real(request: YarnQueryRequest):
    async with httpx.AsyncClient() as client:
        response = await client.post(
            f"{YARNGPT_SERVER_URL}/generate_audio",
            json=request.dict(),
            timeout=30.0
        )
        return YarnResponse(**response.json())
3. Expected YarnGPT API
POST /generate_audio
{
  "text": "Input text",
  "language": "en-ng|ig|yo|ha",
  "speaker": "default"
}

Response:
{
  "text": "Generated text",
  "audio_url": "http://server/audio.wav",
  "duration": 5.2,
  "processing_time": 2.1
}
Development
Project Structure
backend/
├── app/
│   ├── main.py              # FastAPI application
│   ├── seed_data.json       # Demo data
│   └── routes/
│       ├── auth.py          # Authentication endpoints
│       ├── orgs.py          # Organizations endpoints
│       ├── consents.py      # Consent management
│       ├── access_logs.py   # Access logging
│       └── yarn_adapter.py  # YarnGPT integration
├── requirements.txt         # Python dependencies
└── README.md               # This file
Adding New Endpoints
Create route file in app/routes/
Define Pydantic models for request/response
Implement endpoint functions
Include router in main.py
Modifying Demo Data
Edit app/seed_data.json to add/modify:

Users and authentication
Organizations and trust scores
Consent records and history
Access logs and statistics
Testing
# Run with auto-reload for development
python -m uvicorn app.main:app --reload --log-level debug

# Test endpoints
curl "http://localhost:8000/health"
curl "http://localhost:8000/orgs/"
Production Deployment
Database Migration
Replace in-memory storage with PostgreSQL:

# Use SQLAlchemy ORM
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://user:password@localhost/trustbase"
Security Enhancements
Implement proper JWT authentication
Add rate limiting with slowapi
Use environment variables for secrets
Enable HTTPS with SSL certificates
Add request validation and sanitization
Performance Optimization
Use async database drivers (asyncpg)
Implement caching with Redis
Add database connection pooling
Use CDN for static assets
Enable gzip compression
Monitoring and Logging
# Add structured logging
import structlog
logger = structlog.get_logger()

# Add metrics collection
from prometheus_client import Counter, Histogram
request_count = Counter('requests_total', 'Total requests')
Environment Variables
Create .env file for configuration:

# Database
DATABASE_URL=postgresql://user:password@localhost/trustbase

# Authentication
JWT_SECRET_KEY=your-secret-key
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=30

# YarnGPT
YARNGPT_SERVER_URL=http://localhost:8001
YARNGPT_API_KEY=your-api-key

# CORS
CORS_ORIGINS=["http://localhost:3000", "https://trustbase.ng"]
License
This is a demo application. See main project LICENSE for details.

