from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import json
import os
from datetime import datetime
from typing import Dict, List, Optional

from .routes import auth, orgs, consents, access_logs, yarn_adapter

app = FastAPI(
    title="TrustBase Demo API",
    description="Nigerian-focused consent and data-transparency platform demo backend",
    version="1.0.0"
)

# CORS middleware for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/auth", tags=["authentication"])
app.include_router(orgs.router, prefix="/orgs", tags=["organizations"])
app.include_router(consents.router, prefix="/consents", tags=["consents"])
app.include_router(access_logs.router, prefix="/access-logs", tags=["access-logs"])
app.include_router(yarn_adapter.router, prefix="/yarn", tags=["yarn-gpt"])

# Load seed data
def load_seed_data():
    seed_file = os.path.join(os.path.dirname(__file__), "seed_data.json")
    try:
        with open(seed_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        return {
            "users": [],
            "organizations": [],
            "consents": [],
            "access_logs": []
        }

# Global data store (in production, use a real database)
data_store = load_seed_data()

@app.get("/")
async def root():
    return {
        "message": "TrustBase Demo API",
        "version": "1.0.0",
        "status": "running",
        "endpoints": {
            "auth": "/auth",
            "organizations": "/orgs",
            "consents": "/consents",
            "access_logs": "/access-logs",
            "yarn_gpt": "/yarn"
        }
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "data_counts": {
            "users": len(data_store.get("users", [])),
            "organizations": len(data_store.get("organizations", [])),
            "consents": len(data_store.get("consents", [])),
            "access_logs": len(data_store.get("access_logs", []))
        }
    }

@app.post("/seed/load")
async def reload_seed_data():
    """Reload seed data - demo only endpoint"""
    global data_store
    data_store = load_seed_data()
    return {
        "message": "Seed data reloaded",
        "counts": {
            "users": len(data_store.get("users", [])),
            "organizations": len(data_store.get("organizations", [])),
            "consents": len(data_store.get("consents", [])),
            "access_logs": len(data_store.get("access_logs", []))
        }
    }

# Make data_store available to other modules
app.state.data_store = data_store

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)