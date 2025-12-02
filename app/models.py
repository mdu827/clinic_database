from sqlalchemy import Column, Integer, String, Text, Date, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

# НОВАЯ МОДЕЛЬ для аутентификации
class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    fio = Column(Text, nullable=False)
    license_number = Column(Text, nullable=False)

class Person(Base):
    __tablename__ = "persons"
    
    PersonID = Column("personid", Integer, primary_key=True, index=True)
    FirstName = Column("firstname", String(100), nullable=False)
    LastName = Column("lastname", String(100), nullable=False)
    MiddleName = Column("middlename", String(100))
    DateOfBirth = Column("dateofbirth", Date)
    Gender = Column("gender", String(10))
    ContactInfo = Column("contactinfo", String(200))
    Address = Column("address", Text)

class Patient(Base):
    __tablename__ = "patients"
    
    PatientID = Column("patientid", Integer, primary_key=True, index=True)
    PersonID = Column("personid", Integer, ForeignKey("persons.personid"), nullable=False)
    InsuranceNumber = Column("insurancenumber", String(50))
    
    person = relationship("Person")

class Doctor(Base):
    __tablename__ = "doctors"
    
    DoctorID = Column("doctorid", Integer, primary_key=True, index=True)
    PersonID = Column("personid", Integer, ForeignKey("persons.personid"), nullable=False)
    Specialization = Column("specialization", String(100))
    LicenseNumber = Column("licensenumber", String(50), unique=True)
    
    person = relationship("Person")

class MedicalRecord(Base):
    __tablename__ = "medicalrecords"
    
    MedicalRecordID = Column("medicalrecordid", Integer, primary_key=True, index=True)
    PatientID = Column("patientid", Integer, ForeignKey("patients.patientid"), nullable=False)
    DoctorID = Column("doctorid", Integer, ForeignKey("doctors.doctorid"), nullable=False)
    Diagnosis = Column("diagnosis", Text)
    Comments = Column("comments", Text)
    RecordDate = Column("recorddate", TIMESTAMP)

class Appointment(Base):
    __tablename__ = "appointments"
    
    AppointmentID = Column("appointmentid", Integer, primary_key=True, index=True)
    PatientID = Column("patientid", Integer, ForeignKey("patients.patientid"), nullable=False)
    DoctorID = Column("doctorid", Integer, ForeignKey("doctors.doctorid"), nullable=False)
    AppointmentDate = Column("appointmentdate", TIMESTAMP)
    Status = Column("status", String(20))

class DoctorSchedule(Base):
    __tablename__ = "doctorschedule"
    
    ScheduleID = Column("scheduleid", Integer, primary_key=True, index=True)
    DoctorID = Column("doctorid", Integer, ForeignKey("doctors.doctorid"), nullable=False)
    RecordTime = Column("recordtime", TIMESTAMP)
    TaskStatus = Column("taskstatus", String(20))