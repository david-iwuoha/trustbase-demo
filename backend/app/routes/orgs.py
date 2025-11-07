from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import List, Optional
import json

router = APIRouter()

class Organization(BaseModel):
    id: str
    name: str
    logo: str
    trustScore: float
    consentActive: bool
    dataTypes: List[str]
    description: Optional[str] = None
    category: Optional[str] = None

class OrganizationResponse(BaseModel):
    organizations: List[Organization]
    total: int

# Demo organizations data
DEMO_ORGANIZATIONS = [
    {
        "id": "org_1",
        "name": "First Bank Nigeria",
        "logo": "account_balance",
        "trustScore": 8.5,
        "consentActive": True,
        "dataTypes": ["Personal Info", "Financial Data", "Transaction History"],
        "description": "Leading Nigerian commercial bank providing comprehensive financial services",
        "category": "Banking"
    },
    {
        "id": "org_2",
        "name": "MTN Nigeria",
        "logo": "phone",
        "trustScore": 7.8,
        "consentActive": True,
        "dataTypes": ["Contact Info", "Usage Data", "Location Data"],
        "description": "Nigeria's largest telecommunications company",
        "category": "Telecommunications"
    },
    {
        "id": "org_3",
        "name": "Jumia",
        "logo": "shopping_cart",
        "trustScore": 7.2,
        "consentActive": False,
        "dataTypes": ["Purchase History", "Preferences", "Delivery Address"],
        "description": "Leading e-commerce platform in Nigeria",
        "category": "E-commerce"
    },
    {
        "id": "org_4",
        "name": "Paystack",
        "logo": "payment",
        "trustScore": 9.1,
        "consentActive": True,
        "dataTypes": ["Payment Info", "Transaction Data"],
        "description": "Modern online and offline payments for Africa",
        "category": "Fintech"
    },
    {
        "id": "org_5",
        "name": "Flutterwave",
        "logo": "credit_card",
        "trustScore": 8.7,
        "consentActive": True,
        "dataTypes": ["Payment Info", "Merchant Data"],
        "description": "Payment infrastructure for global merchants and payment service providers",
        "category": "Fintech"
    }
]

@router.get("/", response_model=OrganizationResponse)
async def get_organizations(
    user_id: Optional[str] = Query(None),
    category: Optional[str] = Query(None),
    active_only: bool = Query(False)
):
    """Get list of organizations with optional filtering"""
    
    organizations = DEMO_ORGANIZATIONS.copy()
    
    # Apply filters
    if category:
        organizations = [org for org in organizations if org.get("category") == category]
    
    if active_only:
        organizations = [org for org in organizations if org["consentActive"]]
    
    return OrganizationResponse(
        organizations=[Organization(**org) for org in organizations],
        total=len(organizations)
    )

@router.get("/{org_id}", response_model=Organization)
async def get_organization(org_id: str):
    """Get specific organization details"""
    
    for org in DEMO_ORGANIZATIONS:
        if org["id"] == org_id:
            return Organization(**org)
    
    raise HTTPException(status_code=404, detail="Organization not found")

@router.get("/categories/list")
async def get_categories():
    """Get list of organization categories"""
    
    categories = list(set(org.get("category", "Other") for org in DEMO_ORGANIZATIONS))
    return {
        "categories": sorted(categories),
        "total": len(categories)
    }

@router.get("/trust-scores/summary")
async def get_trust_score_summary():
    """Get trust score statistics"""
    
    scores = [org["trustScore"] for org in DEMO_ORGANIZATIONS]
    
    return {
        "average": sum(scores) / len(scores),
        "highest": max(scores),
        "lowest": min(scores),
        "distribution": {
            "excellent": len([s for s in scores if s >= 9.0]),
            "good": len([s for s in scores if 7.5 <= s < 9.0]),
            "fair": len([s for s in scores if 6.0 <= s < 7.5]),
            "poor": len([s for s in scores if s < 6.0])
        }
    }