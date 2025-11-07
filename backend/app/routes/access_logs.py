from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta
import uuid

router = APIRouter()

class AccessLog(BaseModel):
    id: str
    user_id: str
    organization_id: str
    organization_name: str
    organization_logo: str
    data_type: str
    purpose: str
    timestamp: str
    status: str  # approved, denied, pending
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None

class AccessLogResponse(BaseModel):
    access_logs: List[AccessLog]
    total: int

class AccessLogStats(BaseModel):
    total_accesses: int
    approved: int
    denied: int
    recent_24h: int
    top_organizations: List[dict]
    data_types_accessed: List[dict]

# Demo access logs data
DEMO_ACCESS_LOGS = [
    {
        "id": "log_1",
        "user_id": "demo_user_1",
        "organization_id": "org_1",
        "organization_name": "First Bank Nigeria",
        "organization_logo": "account_balance",
        "data_type": "Transaction History",
        "purpose": "Account verification for loan application",
        "timestamp": "2024-01-20T14:30:00Z",
        "status": "approved",
        "ip_address": "197.210.70.1",
        "user_agent": "FirstBank-Mobile/2.1.0"
    },
    {
        "id": "log_2",
        "user_id": "demo_user_1",
        "organization_id": "org_2",
        "organization_name": "MTN Nigeria",
        "organization_logo": "phone",
        "data_type": "Usage Data",
        "purpose": "Service optimization and billing",
        "timestamp": "2024-01-20T09:15:00Z",
        "status": "approved",
        "ip_address": "41.203.64.1",
        "user_agent": "MyMTN-App/3.2.1"
    },
    {
        "id": "log_3",
        "user_id": "demo_user_1",
        "organization_id": "org_4",
        "organization_name": "Paystack",
        "organization_logo": "payment",
        "data_type": "Payment Information",
        "purpose": "Transaction processing",
        "timestamp": "2024-01-19T16:45:00Z",
        "status": "approved",
        "ip_address": "52.31.139.75",
        "user_agent": "Paystack-Gateway/1.0"
    },
    {
        "id": "log_4",
        "user_id": "demo_user_1",
        "organization_id": "org_3",
        "organization_name": "Jumia",
        "organization_logo": "shopping_cart",
        "data_type": "Purchase History",
        "purpose": "Personalized recommendations",
        "timestamp": "2024-01-19T11:20:00Z",
        "status": "denied",
        "ip_address": "154.113.16.1",
        "user_agent": "Jumia-App/4.1.2"
    },
    {
        "id": "log_5",
        "user_id": "demo_user_1",
        "organization_id": "org_1",
        "organization_name": "First Bank Nigeria",
        "organization_logo": "account_balance",
        "data_type": "Personal Information",
        "purpose": "KYC compliance check",
        "timestamp": "2024-01-18T13:10:00Z",
        "status": "approved",
        "ip_address": "197.210.70.1",
        "user_agent": "FirstBank-Web/1.5.0"
    },
    {
        "id": "log_6",
        "user_id": "demo_user_1",
        "organization_id": "org_2",
        "organization_name": "MTN Nigeria",
        "organization_logo": "phone",
        "data_type": "Location Data",
        "purpose": "Network optimization",
        "timestamp": "2024-01-18T08:30:00Z",
        "status": "approved",
        "ip_address": "41.203.64.1",
        "user_agent": "MTN-Network/2.0"
    },
    {
        "id": "log_7",
        "user_id": "demo_user_1",
        "organization_id": "org_4",
        "organization_name": "Paystack",
        "organization_logo": "payment",
        "data_type": "Transaction Data",
        "purpose": "Fraud detection analysis",
        "timestamp": "2024-01-17T20:15:00Z",
        "status": "approved",
        "ip_address": "52.31.139.75",
        "user_agent": "Paystack-Security/1.2"
    },
    {
        "id": "log_8",
        "user_id": "demo_user_1",
        "organization_id": "org_1",
        "organization_name": "First Bank Nigeria",
        "organization_logo": "account_balance",
        "data_type": "Financial Data",
        "purpose": "Credit score assessment",
        "timestamp": "2024-01-16T15:45:00Z",
        "status": "approved",
        "ip_address": "197.210.70.1",
        "user_agent": "FirstBank-Credit/1.0"
    },
    {
        "id": "log_9",
        "user_id": "demo_user_1",
        "organization_id": "org_2",
        "organization_name": "MTN Nigeria",
        "organization_logo": "phone",
        "data_type": "Contact Info",
        "purpose": "Account verification",
        "timestamp": "2024-01-15T12:00:00Z",
        "status": "approved",
        "ip_address": "41.203.64.1",
        "user_agent": "MyMTN-App/3.2.1"
    },
    {
        "id": "log_10",
        "user_id": "demo_user_1",
        "organization_id": "org_3",
        "organization_name": "Jumia",
        "organization_logo": "shopping_cart",
        "data_type": "Delivery Address",
        "purpose": "Order fulfillment",
        "timestamp": "2024-01-14T18:30:00Z",
        "status": "denied",
        "ip_address": "154.113.16.1",
        "user_agent": "Jumia-Logistics/2.1"
    }
]

@router.get("/", response_model=AccessLogResponse)
async def get_access_logs(
    user_id: str = Query(...),
    organization_id: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    data_type: Optional[str] = Query(None),
    days: int = Query(30, description="Number of days to look back"),
    limit: int = Query(50, description="Maximum number of logs to return")
):
    """Get access logs for a user with optional filtering"""
    
    # Filter by user
    logs = [log for log in DEMO_ACCESS_LOGS if log["user_id"] == user_id]
    
    # Apply filters
    if organization_id:
        logs = [log for log in logs if log["organization_id"] == organization_id]
    
    if status:
        logs = [log for log in logs if log["status"] == status]
    
    if data_type:
        logs = [log for log in logs if log["data_type"] == data_type]
    
    # Filter by date range
    cutoff_date = datetime.now() - timedelta(days=days)
    logs = [
        log for log in logs 
        if datetime.fromisoformat(log["timestamp"].replace('Z', '+00:00')) >= cutoff_date
    ]
    
    # Sort by timestamp (most recent first)
    logs.sort(key=lambda x: x["timestamp"], reverse=True)
    
    # Apply limit
    logs = logs[:limit]
    
    return AccessLogResponse(
        access_logs=[AccessLog(**log) for log in logs],
        total=len(logs)
    )

@router.get("/{log_id}", response_model=AccessLog)
async def get_access_log(log_id: str):
    """Get specific access log details"""
    
    for log in DEMO_ACCESS_LOGS:
        if log["id"] == log_id:
            return AccessLog(**log)
    
    raise HTTPException(status_code=404, detail="Access log not found")

@router.get("/stats/summary", response_model=AccessLogStats)
async def get_access_stats(
    user_id: str = Query(...),
    days: int = Query(30, description="Number of days to analyze")
):
    """Get access statistics for a user"""
    
    # Filter logs for user and date range
    cutoff_date = datetime.now() - timedelta(days=days)
    user_logs = [
        log for log in DEMO_ACCESS_LOGS 
        if (log["user_id"] == user_id and 
            datetime.fromisoformat(log["timestamp"].replace('Z', '+00:00')) >= cutoff_date)
    ]
    
    # Calculate stats
    total_accesses = len(user_logs)
    approved = len([log for log in user_logs if log["status"] == "approved"])
    denied = len([log for log in user_logs if log["status"] == "denied"])
    
    # Recent 24h accesses
    recent_cutoff = datetime.now() - timedelta(hours=24)
    recent_24h = len([
        log for log in user_logs 
        if datetime.fromisoformat(log["timestamp"].replace('Z', '+00:00')) >= recent_cutoff
    ])
    
    # Top organizations
    org_counts = {}
    for log in user_logs:
        org_name = log["organization_name"]
        org_counts[org_name] = org_counts.get(org_name, 0) + 1
    
    top_organizations = [
        {"name": org, "count": count} 
        for org, count in sorted(org_counts.items(), key=lambda x: x[1], reverse=True)[:5]
    ]
    
    # Data types accessed
    data_type_counts = {}
    for log in user_logs:
        data_type = log["data_type"]
        data_type_counts[data_type] = data_type_counts.get(data_type, 0) + 1
    
    data_types_accessed = [
        {"type": dtype, "count": count} 
        for dtype, count in sorted(data_type_counts.items(), key=lambda x: x[1], reverse=True)
    ]
    
    return AccessLogStats(
        total_accesses=total_accesses,
        approved=approved,
        denied=denied,
        recent_24h=recent_24h,
        top_organizations=top_organizations,
        data_types_accessed=data_types_accessed
    )

@router.post("/simulate")
async def simulate_access_log(
    user_id: str,
    organization_id: str,
    data_type: str,
    purpose: str
):
    """Simulate a new access log entry (demo only)"""
    
    # Find organization details
    from .orgs import DEMO_ORGANIZATIONS
    org_name = "Unknown Organization"
    org_logo = "business"
    
    for org in DEMO_ORGANIZATIONS:
        if org["id"] == organization_id:
            org_name = org["name"]
            org_logo = org["logo"]
            break
    
    new_log = {
        "id": f"log_{uuid.uuid4().hex[:8]}",
        "user_id": user_id,
        "organization_id": organization_id,
        "organization_name": org_name,
        "organization_logo": org_logo,
        "data_type": data_type,
        "purpose": purpose,
        "timestamp": datetime.now().isoformat(),
        "status": "approved",  # Demo always approves
        "ip_address": "192.168.1.1",
        "user_agent": "Demo-Client/1.0"
    }
    
    DEMO_ACCESS_LOGS.append(new_log)
    
    return {
        "success": True,
        "message": "Access log created",
        "log_id": new_log["id"]
    }