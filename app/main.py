from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from typing import List, Optional

from . import models, schemas
from .database import engine, get_db
from .pages.router import router as pages_router
from .dao import UserDAO, PersonDAO, DoctorDAO, PatientDAO, MedicalRecordDAO, AppointmentDAO, DoctorScheduleDAO
from .auth import create_access_token, get_current_user


# Создаем таблицы
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Clinic API", version="1.0.0")

# Монтируем статические файлы и шаблоны
app.mount("/static", StaticFiles(directory="app/static"), name="static")
app.include_router(pages_router)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# НОВЫЕ ЭНДПОИНТЫ АУТЕНТИФИКАЦИИ
@app.post("/register", response_model=schemas.UserResponse)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    """Регистрация нового пользователя"""
    # Проверяем, существует ли пользователь
    existing_user = UserDAO.get_user_by_credentials(
        db, user.fio, user.license_number
    )
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User already exists"
        )
    
    return UserDAO.create_user(db, user)

@app.post("/login", response_model=schemas.Token)
def login(user_data: schemas.UserLogin, db: Session = Depends(get_db)):
    """Вход в систему и получение JWT токена"""
    user = UserDAO.get_user_by_credentials(
        db, user_data.fio, user_data.license_number
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect fio or license number"
        )
    
    access_token = create_access_token(user_id=user.id)
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/me", response_model=schemas.UserResponse)
def read_users_me(current_user: models.User = Depends(get_current_user)):
    """Получить информацию о текущем пользователе (защищенный эндпоинт)"""
    return current_user

# СУЩЕСТВУЮЩИЕ ЭНДПОИНТЫ КЛИНИКИ
@app.get("/")
async def root():
    return {"message": "Clinic API is running"}

@app.get("/doctors", response_model=List[schemas.DoctorInfo])
def get_all_doctors(db: Session = Depends(get_db)):
    """Получить список всех врачей"""
    doctors = db.query(models.Doctor).join(models.Person).all()
    return doctors

@app.get("/doctors/{doctor_id}", response_model=schemas.DoctorInfo)
def get_doctor_by_id(doctor_id: int, db: Session = Depends(get_db)):
    """Получить врача по ID"""
    doctor = db.query(models.Doctor).filter(models.Doctor.DoctorID == doctor_id).first()
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return doctor

@app.get("/doctors/search/{license_number}", response_model=schemas.DoctorInfo)
def get_doctor_by_license(license_number: str, db: Session = Depends(get_db)):
    """Получить врача по номеру лицензии"""
    doctor = db.query(models.Doctor).filter(models.Doctor.LicenseNumber == license_number).first()
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return doctor

@app.get("/doctors/specialization/{specialization}", response_model=List[schemas.DoctorInfo])
def get_doctors_by_specialization(specialization: str, db: Session = Depends(get_db)):
    """Получить врачей по специализации"""
    doctors = db.query(models.Doctor).filter(
        models.Doctor.Specialization.ilike(f"%{specialization}%")
    ).all()
    return doctors

@app.post("/persons/", response_model=schemas.PersonResponse)
def create_person(person: schemas.PersonCreate, db: Session = Depends(get_db)):
    """Создать нового человека"""
    db_person = PersonDAO.create_person(db, person)
    if db_person is None:
        raise HTTPException(status_code=400, detail="Ошибка при создании человека")
    return db_person

@app.post("/doctors/", response_model=schemas.DoctorResponse)
def create_doctor(doctor: schemas.DoctorCreate, db: Session = Depends(get_db)):
    """Создать нового врача"""
    db_doctor = DoctorDAO.create_doctor(db, doctor)
    if db_doctor is None:
        raise HTTPException(status_code=400, detail="Человек с указанным PersonID не существует")
    return db_doctor

@app.post("/patients/", response_model=schemas.PatientCreate)
def create_patient(patient: schemas.PatientCreate, db: Session = Depends(get_db)):
    """Создать нового пациента"""
    db_patient = PatientDAO.create_patient(db, patient)
    if db_patient is None:
        raise HTTPException(status_code=400, detail="Человек с указанным PersonID не существует")
    return db_patient

@app.post("/medical-records/", response_model=schemas.MedicalRecordCreate)
def create_medical_record(record: schemas.MedicalRecordCreate, db: Session = Depends(get_db)):
    """Создать новую медицинскую запись"""
    db_record = MedicalRecordDAO.create_medical_record(db, record)
    if db_record is None:
        raise HTTPException(status_code=400, detail="Пациент или врач с указанными ID не существуют")
    return db_record

@app.post("/appointments/", response_model=schemas.AppointmentCreate)
def create_appointment(appointment: schemas.AppointmentCreate, db: Session = Depends(get_db)):
    """Создать новую запись на прием"""
    db_appointment = AppointmentDAO.create_appointment(db, appointment)
    if db_appointment is None:
        raise HTTPException(status_code=400, detail="Пациент или врач с указанными ID не существуют")
    return db_appointment

@app.post("/doctor-schedule/", response_model=schemas.DoctorScheduleCreate)
def create_doctor_schedule(schedule: schemas.DoctorScheduleCreate, db: Session = Depends(get_db)):
    """Создать новую запись в расписании врача"""
    db_schedule = DoctorScheduleDAO.create_schedule(db, schedule)
    if db_schedule is None:
        raise HTTPException(status_code=400, detail="Врач с указанным ID не существует")
    return db_schedule

@app.get("/persons", response_model=List[schemas.PersonResponse])
def get_all_persons(db: Session = Depends(get_db)):
    """Получить список всех людей"""
    persons = db.query(models.Person).all()
    return persons
@app.get("/find-doctor/", response_model=schemas.DoctorResponse)
def find_doctor(
    license_number: str,
    db: Session = Depends(get_db)
):
    """Найти врача по номеру лицензии (полная информация)"""
    # Ищем врача с полной информацией о человеке
    doctor = db.query(models.Doctor).\
        join(models.Person).\
        filter(models.Doctor.LicenseNumber == license_number).\
        first()
    
    if not doctor:
        raise HTTPException(
            status_code=404, 
            detail="Врач с указанным номером лицензии не найден"
        )
    
    return doctor
@app.get("/find-patient/", response_model=schemas.PatientResponse)
def find_patient(
    insurance_number: str, 
    db: Session = Depends(get_db)
):
    """Найти пациента по номеру страховки (полная информация)"""
    # Ищем пациента с полной информацией о человеке
    patient = db.query(models.Patient).\
        join(models.Person).\
        filter(models.Patient.InsuranceNumber == insurance_number).\
        first()
    
    if not patient:
        raise HTTPException(
            status_code=404, 
            detail="Пациент с указанным номером страховки не найден"
        )
    
    return patient
@app.get("/persons/{person_id}", response_model=schemas.PersonResponse)
def get_person_by_id(person_id: int, db: Session = Depends(get_db)):
    """Получить человека по ID"""
    person = db.query(models.Person).filter(models.Person.PersonID == person_id).first()
    
    if not person:
        raise HTTPException(
            status_code=404,
            detail="Человек с указанным ID не найден"
        )
    
    return person
# @app.get("/users", response_model=List[schemas.UserResponse])
# def get_all_users(db: Session = Depends(get_db)):
#     """Получить список всех пользователей (для администрирования)"""
#     users = db.query(models.User).all()
#     return users
@app.get("/patients", response_model=List[schemas.PatientResponse])
def get_all_patients(db: Session = Depends(get_db)):
    """Получить список всех пациентов"""
    patients = db.query(models.Patient).join(models.Person).all()
    return patients
@app.post("/doctors/full/", response_model=schemas.DoctorResponse)
def create_doctor_full(
    first_name: str,
    last_name: str,
    specialization: str,
    license_number: str,
    db: Session = Depends(get_db)
):
    """Создать врача с автоматическим созданием Person записи"""
    # Сначала создаем человека
    person_data = schemas.PersonCreate(
        FirstName=first_name,
        LastName=last_name,
        MiddleName=None
    )
    person = PersonDAO.create_person(db, person_data)
    
    # Затем создаем врача
    doctor_data = schemas.DoctorCreate(
        PersonID=person.PersonID,
        Specialization=specialization,
        LicenseNumber=license_number
    )
    doctor = DoctorDAO.create_doctor(db, doctor_data)
    
    return doctor

# ПРИМЕР ЗАЩИЩЕННОГО ЭНДПОИНТА (только для авторизованных пользователей)
@app.get("/protected-data")
def get_protected_data(current_user: models.User = Depends(get_current_user)):
    """Пример защищенного эндпоинта"""
    return {
        "message": "This is protected data", 
        "user_id": current_user.id,
        "user_fio": current_user.fio
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)