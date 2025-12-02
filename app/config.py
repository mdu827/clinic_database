import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    # DB подключение
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = os.getenv("DB_PORT", "5432")
    DB_NAME = os.getenv("DB_NAME", "hospital_db")
    DB_USER = os.getenv("DB_USER", "leetcloud")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "5139")
    JWT_SECRET = os.getenv("JWT_SECRET", "your-super-secret-key-change-in-production")
    
    # PostgreSQL URL
    DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    
    # JWT настройки (добавляем)
    SECRET_KEY = JWT_SECRET  # для совместимости с остальным кодом
    ALGORITHM = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES = 15

settings = Settings()