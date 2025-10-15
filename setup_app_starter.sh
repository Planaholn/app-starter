#!/bin/bash
set -e

echo "🚀 Setting up App Starter baseline..."

# Create directories
mkdir -p src/{auth,core,jobs} tests .github/workflows

# Python package markers
touch src/__init__.py src/auth/__init__.py src/core/__init__.py src/jobs/__init__.py

# main.py
cat > src/main.py <<'PY'
from fastapi import FastAPI

app = FastAPI(title="App Starter")

@app.get("/health")
def health():
    return {"status": "ok"}
PY

# core/config.py
cat > src/core/config.py <<'PY'
import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "App Starter"
    database_url: str = "postgresql://postgres:postgres@db:5432/app"

settings = Settings()
PY

# other files
cat > src/core/db.py <<'PY'
# Placeholder for database setup
PY

cat > src/core/logger.py <<'PY'
import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("app-starter")
PY

# test
cat > tests/test_healthcheck.py <<'PY'
from starlette.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"
PY

# requirements.txt
cat > requirements.txt <<'REQ'
fastapi==0.115.0
uvicorn[standard]==0.30.0
starlette==0.38.2
pydantic==2.8.2
requests==2.32.3
pytest==8.3.2
REQ

# Dockerfile
cat > Dockerfile <<'DOCK'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ./src ./src
ENV PYTHONPATH=/app
EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
DOCK

# docker-compose.yml
cat > docker-compose.yml <<'YML'
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - PYTHONUNBUFFERED=1
    volumes:
      - .:/app
YML

# .env.example
cat > .env.example <<'ENV'
APP_NAME=App Starter
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/app
ENV

# CI workflow
cat > .github/workflows/ci.yml <<'YML'
name: CI
on:
  push:
    branches: [ "main" ]
  pull_request:
jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Install deps
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: Run tests
        run: pytest -q
YML

echo "✅ App Starter structure created successfully!"
