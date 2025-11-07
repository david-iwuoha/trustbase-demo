from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from typing import Optional
import uuid
from datetime import datetime, timedelta

router = APIRouter()

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class GoogleSignInRequest(BaseModel):
    id_token: str

class SessionCheckRequest(BaseModel):
    token: str

class UserProfile(BaseModel):
    id: str
    email: str
    firstName: str
    lastName: str
    profileComplete: bool
    provider: Optional[str] = "email"
    createdAt: str

class AuthResponse(BaseModel):
    success: bool
    token: str
    user: UserProfile
    message: Optional[str] = None

# Demo users for authentication
DEMO_USERS = {
    "demo@trustbase.ng": {
        "id": "demo_user_1",
        "email": "demo@trustbase.ng",
        "firstName": "Adaora",
        "lastName": "Okafor",
        "password": "demo123",  # In production, this would be hashed
        "profileComplete": False,
        "provider": "email",
        "createdAt": "2024-01-15T10:00:00Z"
    },
    "adaora.okafor@gmail.com": {
        "id": "demo_google_user",
        "email": "adaora.okafor@gmail.com",
        "firstName": "Adaora",
        "lastName": "Okafor",
        "password": None,
        "profileComplete": False,
        "provider": "google",
        "createdAt": "2024-01-15T10:00:00Z"
    }
}

# Demo tokens (in production, use JWT with proper signing)
DEMO_TOKENS = {
    "demo_token_123": "demo_user_1",
    "demo_google_token_456": "demo_google_user"
}

@router.post("/login", response_model=AuthResponse)
async def login(request: LoginRequest):
    """Demo login endpoint - accepts any email/password for demo purposes"""
    
    # Check if it's a known demo user
    if request.email in DEMO_USERS:
        user_data = DEMO_USERS[request.email]
        if user_data["password"] is None or request.password == user_data["password"] or len(request.password) >= 6:
            token = f"demo_token_{uuid.uuid4().hex[:8]}"
            DEMO_TOKENS[token] = user_data["id"]
            
            return AuthResponse(
                success=True,
                token=token,
                user=UserProfile(**{k: v for k, v in user_data.items() if k != "password"}),
                message="Login successful"
            )
    
    # For demo purposes, accept any email/password combination with minimum validation
    if "@" in request.email and len(request.password) >= 6:
        user_id = f"demo_user_{uuid.uuid4().hex[:8]}"
        token = f"demo_token_{uuid.uuid4().hex[:8]}"
        
        # Extract name from email for demo
        email_parts = request.email.split("@")[0].split(".")
        first_name = email_parts[0].capitalize() if email_parts else "User"
        last_name = email_parts[1].capitalize() if len(email_parts) > 1 else "Demo"
        
        user_data = {
            "id": user_id,
            "email": request.email,
            "firstName": first_name,
            "lastName": last_name,
            "profileComplete": False,
            "provider": "email",
            "createdAt": datetime.now().isoformat()
        }
        
        DEMO_TOKENS[token] = user_id
        DEMO_USERS[request.email] = {**user_data, "password": request.password}
        
        return AuthResponse(
            success=True,
            token=token,
            user=UserProfile(**user_data),
            message="Login successful"
        )
    
    raise HTTPException(status_code=401, detail="Invalid credentials")

@router.post("/google-signin", response_model=AuthResponse)
async def google_signin(request: GoogleSignInRequest):
    """Demo Google sign-in endpoint - design only, returns demo user"""
    
    # Simulate Google token validation delay
    import asyncio
    await asyncio.sleep(0.5)
    
    user_data = DEMO_USERS["adaora.okafor@gmail.com"]
    token = f"demo_google_token_{uuid.uuid4().hex[:8]}"
    DEMO_TOKENS[token] = user_data["id"]
    
    return AuthResponse(
        success=True,
        token=token,
        user=UserProfile(**{k: v for k, v in user_data.items() if k != "password"}),
        message="Google sign-in successful"
    )

@router.post("/session-check")
async def session_check(request: SessionCheckRequest):
    """Check if session token is valid and return user profile"""
    
    if request.token not in DEMO_TOKENS:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    
    user_id = DEMO_TOKENS[request.token]
    
    # Find user data
    for email, user_data in DEMO_USERS.items():
        if user_data["id"] == user_id:
            return {
                "success": True,
                "user": UserProfile(**{k: v for k, v in user_data.items() if k != "password"})
            }
    
    raise HTTPException(status_code=404, detail="User not found")

@router.post("/logout")
async def logout(request: SessionCheckRequest):
    """Logout and invalidate token"""
    
    if request.token in DEMO_TOKENS:
        del DEMO_TOKENS[request.token]
    
    return {"success": True, "message": "Logged out successfully"}