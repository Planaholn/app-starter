import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "App Starter"
    database_url: str = "postgresql://postgres:postgres@db:5432/app"

settings = Settings()
