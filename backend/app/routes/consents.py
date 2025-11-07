from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import uuid

router = APIRouter()

class ConsentRequest(BaseModel):
    user_id: str
    organization_id: str
    data_types: List[str]
    purpose: str

class ConsentRevoke(BaseModel):
    user_id: str
    organization_id: str
    reason: Optional[str] = None

class Consent(BaseModel):
    id: str
    user_id: str
    organization_id: str
    organization_name: str
    data_types: List[str]
    purpose: str
    status: str  # active, revoked, expired
    granted_at: str
    revoked_at: Optional[str] = None
    expires_at: Optional[str] = None

class ConsentHistory(BaseModel):
    id: str
    consent_id: str
    action: str  # granted, revoked, updated, accessed
    timestamp: str
    data_types: Optional[List[str]] = None
    reason: Optional[str] = None

class ConsentResponse(BaseModel):
    consents: List[Consent]
    total: int

# Demo consents data
DEMO_CONSENTS = [
    {
        "id": "consent_1",
        "user_id": "demo_user_1",
        "organization_id": "org_1",
        "organization_name": "First Bank Nigeria",
        "data_types": ["Personal Info", "Financial Data", "Transaction History"],
        "purpose": "Account management and loan processing",
        "status": "active",
        "granted_at": "2024-01-15T10:30:00Z",
        "revoked_at": None,
        "expires_at": "2025-01-15T10:30:00Z"
    },
    {
        "id": "consent_2",
        "user_id": "demo_user_1",
        "organization_id": "org_2",
        "organization_name": "MTN Nigeria",
        "data_types": ["Contact Info", "Usage Data", "Location Data"],
        "purpose": "Service optimization and billing",
        "status": "active",
        "granted_at": "2024-01-10T14:15:00Z",
        "revoked_at": None,
        "expires_at": "2025-01-10T14:15:00Z"
    },
    {
        "id": "consent_3",
        "user_id": "demo_user_1",
        "organization_id": "org_3",
        "organization_name": "Jumia",
        "data_types": ["Purchase History", "Preferences", "Delivery Address"],
        "purpose": "Personalized recommendations and delivery",
        "status": "revoked",
        "granted_at": "2024-01-05T09:45:00Z",
        "revoked_at": "2024-01-18T16:20:00Z",
        "expires_at": "2025-01-05T09:45:00Z"
    },
    {
        "id": "consent_4",
        "user_id": "demo_user_1",
        "organization_id": "org_4",
        "organization_name": "Paystack",
        "data_types": ["Payment Info", "Transaction Data"],
        "purpose": "Payment processing and fraud prevention",
        "status": "active",
        "granted_at": "2024-01-12T11:00:00Z",
        "revoked_at": None,
        "expires_at": "2025-01-12T11:00:00Z"
    }
]

# Demo consent history
DEMO_CONSENT_HISTORY = [
    {
        "id": "history_1",
        "consent_id": "consent_1",
        "action": "granted",
        "timestamp": "2024-01-15T10:30:00Z",
        "data_types": ["Personal Info", "Financial Data", "Transaction History"],
        "reason": "Initial consent for account opening"
    },
    {
        "id": "history_2",
        "consent_id": "consent_3",
        "action": "revoked",
        "timestamp": "2024-01-18T16:20:00Z",
        "data_types": ["Purchase History", "Preferences", "Delivery Address"],
        "reason": "User requested data deletion"
    },
    {
        "id": "history_3",
        "consent_id": "consent_2",
        "action": "updated",
        "timestamp": "2024-01-16T13:10:00Z",
        "data_types": ["Contact Info", "Usage Data"],
        "reason": "Removed location data sharing"
    }
]

@router.get("/", response_model=ConsentResponse)
async def get_consents(
    user_id: str = Query(...),
    status: Optional[str] = Query(None),
    organization_id: Optional[str] = Query(None)
):
    """Get user's consents with optional filtering"""
    
    consents = [c for c in DEMO_CONSENTS if c["user_id"] == user_id]
    
    # Apply filters
    if status:
        consents = [c for c in consents if c["status"] == status]
    
    if organization_id:
        consents = [c for c in consents if c["organization_id"] == organization_id]
    
    return ConsentResponse(
        consents=[Consent(**consent) for consent in consents],
        total=len(consents)
    )

@router.get("/{consent_id}", response_model=Consent)
async def get_consent(consent_id: str):
    """Get specific consent details"""
    
    for consent in DEMO_CONSENTS:
        if consent["id"] == consent_id:
            return Consent(**consent)
    
    raise HTTPException(status_code=404, detail="Consent not found")

@router.post("/grant")
async def grant_consent(request: ConsentRequest):
    """Grant new consent"""
    
    consent_id = f"consent_{uuid.uuid4().hex[:8]}"
    timestamp = datetime.now().isoformat()
    
    # Find organization name
    from .orgs import DEMO_ORGANIZATIONS
    org_name = "Unknown Organization"
    for org in DEMO_ORGANIZATIONS:
        if org["id"] == request.organization_id:
            org_name = org["name"]
            break
    
    new_consent = {
        "id": consent_id,
        "user_id": request.user_id,
        "organization_id": request.organization_id,
        "organization_name": org_name,
        "data_types": request.data_types,
        "purpose": request.purpose,
        "status": "active",
        "granted_at": timestamp,
        "revoked_at": None,
        "expires_at": datetime.fromisoformat(timestamp.replace('Z', '+00:00')).replace(year=datetime.now().year + 1).isoformat()
    }
    
    DEMO_CONSENTS.append(new_consent)
    
    # Add to history
    DEMO_CONSENT_HISTORY.append({
        "id": f"history_{uuid.uuid4().hex[:8]}",
        "consent_id": consent_id,
        "action": "granted",
        "timestamp": timestamp,
        "data_types": request.data_types,
        "reason": f"Consent granted for: {request.purpose}"
    })
    
    return {
        "success": True,
        "message": "Consent granted successfully",
        "consent_id": consent_id
    }

@router.post("/revoke")
async def revoke_consent(request: ConsentRevoke):
    """Revoke existing consent"""
    
    # Find and update consent
    for consent in DEMO_CONSENTS:
        if (consent["user_id"] == request.user_id and 
            consent["organization_id"] == request.organization_id and 
            consent["status"] == "active"):
            
            consent["status"] = "revoked"
            consent["revoked_at"] = datetime.now().isoformat()
            
            # Add to history
            DEMO_CONSENT_HISTORY.append({
                "id": f"history_{uuid.uuid4().hex[:8]}",
                "consent_id": consent["id"],
                "action": "revoked",
                "timestamp": datetime.now().isoformat(),
                "data_types": consent["data_types"],
                "reason": request.reason or "User requested consent revocation"
            })
            
            return {
                "success": True,
                "message": f"Consent revoked for {consent['organization_name']}",
                "consent_id": consent["id"]
            }
    
    raise HTTPException(status_code=404, detail="Active consent not found")

@router.get("/{consent_id}/history")
async def get_consent_history(consent_id: str):
    """Get consent history"""
    
    history = [h for h in DEMO_CONSENT_HISTORY if h["consent_id"] == consent_id]
    
    return {
        "history": [ConsentHistory(**h) for h in history],
        "total": len(history)
    }

@router.get("/stats/summary")
async def get_consent_stats(user_id: str = Query(...)):
    """Get consent statistics for user"""
    
    user_consents = [c for c in DEMO_CONSENTS if c["user_id"] == user_id]
    
    active_count = len([c for c in user_consents if c["status"] == "active"])
    revoked_count = len([c for c in user_consents if c["status"] == "revoked"])
    
    return {
        "total": len(user_consents),
        "active": active_count,
        "revoked": revoked_count,
        "expired": len(user_consents) - active_count - revoked_count,
        "organizations": len(set(c["organization_id"] for c in user_consents))
    }