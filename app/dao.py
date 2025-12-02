from sqlalchemy.orm import Session
from sqlalchemy import and_
from app import models, schemas

# НОВЫЙ DAO для аутентификации
class UserDAO:
    @staticmethod
    def get_user_by_credentials(db: Session, fio: str, license_number: str):
        return db.query(models.User).filter(
            models.User.fio == fio, 
            models.User.license_number == license_number
        ).first()
    @staticmethod
    def get_all_persons(db: Session):
        return db.query(models.Person).all()
    @staticmethod
    def get_all_users(db: Session):
        return db.query(models.User).all()
    @staticmethod
    def get_all_patients(db: Session):
        return db.query(models.Patient).join(models.Person).all()
    @staticmethod
    def create_user(db: Session, user: schemas.UserCreate):
        db_user = models.User(fio=user.fio, license_number=user.license_number)
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    @staticmethod
    def get_user_by_id(db: Session, user_id: int):
        return db.query(models.User).filter(models.User.id == user_id).first()

# Существующие DAO для клиники
class PersonDAO:
    @staticmethod
    def create_person(db: Session, person: schemas.PersonCreate):
        db_person = models.Person(
            FirstName=person.FirstName,
            LastName=person.LastName,
            MiddleName=person.MiddleName,
            DateOfBirth=person.DateOfBirth,
            Gender=person.Gender,
            ContactInfo=person.ContactInfo,
            Address=person.Address
        )
        db.add(db_person)
        db.commit()
        db.refresh(db_person)
        return db_person

    @staticmethod
    def get_person(db: Session, person_id: int):
        return db.query(models.Person).filter(models.Person.PersonID == person_id).first()

class DoctorDAO:
    @staticmethod
    def create_doctor(db: Session, doctor: schemas.DoctorCreate):
        person = db.query(models.Person).filter(models.Person.PersonID == doctor.PersonID).first()
        if not person:
            return None
        
        db_doctor = models.Doctor(
            PersonID=doctor.PersonID,
            Specialization=doctor.Specialization,
            LicenseNumber=doctor.LicenseNumber
        )
        db.add(db_doctor)
        db.commit()
        db.refresh(db_doctor)
        return db_doctor

    @staticmethod
    def get_doctor(db: Session, doctor_id: int):
        return db.query(models.Doctor).filter(models.Doctor.DoctorID == doctor_id).first()

class PatientDAO:
    @staticmethod
    def create_patient(db: Session, patient: schemas.PatientCreate):
        person = db.query(models.Person).filter(models.Person.PersonID == patient.PersonID).first()
        if not person:
            return None
        
        db_patient = models.Patient(
            PersonID=patient.PersonID,
            InsuranceNumber=patient.InsuranceNumber
        )
        db.add(db_patient)
        db.commit()
        db.refresh(db_patient)
        return db_patient

class MedicalRecordDAO:
    @staticmethod
    def create_medical_record(db: Session, record: schemas.MedicalRecordCreate):
        patient = db.query(models.Patient).filter(models.Patient.PatientID == record.PatientID).first()
        doctor = db.query(models.Doctor).filter(models.Doctor.DoctorID == record.DoctorID).first()
        
        if not patient or not doctor:
            return None
        
        db_record = models.MedicalRecord(
            PatientID=record.PatientID,
            DoctorID=record.DoctorID,
            Diagnosis=record.Diagnosis,
            Comments=record.Comments
        )
        db.add(db_record)
        db.commit()
        db.refresh(db_record)
        return db_record

class AppointmentDAO:
    @staticmethod
    def create_appointment(db: Session, appointment: schemas.AppointmentCreate):
        patient = db.query(models.Patient).filter(models.Patient.PatientID == appointment.PatientID).first()
        doctor = db.query(models.Doctor).filter(models.Doctor.DoctorID == appointment.DoctorID).first()
        
        if not patient or not doctor:
            return None
        
        db_appointment = models.Appointment(
            PatientID=appointment.PatientID,
            DoctorID=appointment.DoctorID,
            AppointmentDate=appointment.AppointmentDate,
            Status=appointment.Status
        )
        db.add(db_appointment)
        db.commit()
        db.refresh(db_appointment)
        return db_appointment

class DoctorScheduleDAO:
    @staticmethod
    def create_schedule(db: Session, schedule: schemas.DoctorScheduleCreate):
        doctor = db.query(models.Doctor).filter(models.Doctor.DoctorID == schedule.DoctorID).first()
        if not doctor:
            return None
        
        db_schedule = models.DoctorSchedule(
            DoctorID=schedule.DoctorID,
            RecordTime=schedule.RecordTime,
            TaskStatus=schedule.TaskStatus
        )
        db.add(db_schedule)
        db.commit()
        db.refresh(db_schedule)
        return db_schedule