from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import date, datetime

# НОВЫЕ СХЕМЫ для аутентификации
class UserCreate(BaseModel):
    fio: str
    license_number: str

class UserLogin(BaseModel):
    fio: str
    license_number: str

class UserResponse(BaseModel):
    id: int
    fio: str
    license_number: str

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

# Существующие схемы для клиники
class PersonBase(BaseModel):
    FirstName: str
    LastName: str
    MiddleName: Optional[str] = None
    DateOfBirth: Optional[date] = None
    Gender: Optional[str] = None
    ContactInfo: Optional[str] = None
    Address: Optional[str] = None

    class Config:
        from_attributes = True

class DoctorInfo(BaseModel):
    DoctorID: int
    PersonID: int
    Specialization: Optional[str]
    LicenseNumber: str
    person: PersonBase

    class Config:
        from_attributes = True

class DoctorSimple(BaseModel):
    DoctorID: int
    FirstName: str
    LastName: str
    Specialization: Optional[str]
    LicenseNumber: str

    class Config:
        from_attributes = True

class PersonCreate(BaseModel):
    FirstName: str = Field(..., min_length=1, max_length=100, description="Имя")
    LastName: str = Field(..., min_length=1, max_length=100, description="Фамилия")
    MiddleName: Optional[str] = Field(None, max_length=100, description="Отчество")
    DateOfBirth: Optional[date] = Field(None, description="Дата рождения")
    Gender: Optional[str] = Field(None, max_length=10, description="Пол")
    ContactInfo: Optional[str] = Field(None, max_length=200, description="Контактная информация")
    Address: Optional[str] = Field(None, description="Адрес")

class DoctorCreate(BaseModel):
    PersonID: int = Field(..., description="ID человека")
    Specialization: str = Field(..., max_length=100, description="Специализация")
    LicenseNumber: str = Field(..., max_length=50, description="Номер лицензии")

class PatientCreate(BaseModel):
    PersonID: int = Field(..., description="ID человека")
    InsuranceNumber: Optional[str] = Field(None, max_length=50, description="Номер страховки")

class MedicalRecordCreate(BaseModel):
    PatientID: int = Field(..., description="ID пациента")
    DoctorID: int = Field(..., description="ID врача")
    Diagnosis: str = Field(..., description="Диагноз")
    Comments: Optional[str] = Field(None, description="Комментарии")

class AppointmentCreate(BaseModel):
    PatientID: int = Field(..., description="ID пациента")
    DoctorID: int = Field(..., description="ID врача")
    AppointmentDate: datetime = Field(..., description="Дата и время приема")
    Status: Optional[str] = Field("Scheduled", max_length=20, description="Статус")

class DoctorScheduleCreate(BaseModel):
    DoctorID: int = Field(..., description="ID врача")
    RecordTime: datetime = Field(..., description="Время записи")
    TaskStatus: Optional[str] = Field("Available", max_length=20, description="Статус задачи")

# Response схемы
class PersonResponse(BaseModel):
    PersonID: int
    FirstName: str
    LastName: str
    MiddleName: Optional[str]
    DateOfBirth: Optional[date]
    Gender: Optional[str]
    ContactInfo: Optional[str]
    Address: Optional[str]

    class Config:
        from_attributes = True

class DoctorResponse(BaseModel):
    DoctorID: int
    PersonID: int
    Specialization: Optional[str]
    LicenseNumber: str
    person: PersonResponse

    class Config:
        from_attributes = True
class PatientResponse(BaseModel):
    PatientID: int
    PersonID: int
    InsuranceNumber: Optional[str]
    person: PersonResponse  # Включаем данные из таблицы Persons

    class Config:
        from_attributes = True