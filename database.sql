CREATE TABLE IF NOT EXISTS Patient (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender ENUM('M', 'F') NOT NULL,
    DateOfBirth DATE NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Address VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS Doctor (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(50),
    ContactNumber VARCHAR(15) NOT NULL
);
CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
CREATE TABLE IF NOT EXISTS MedicalRecord (
    RecordID INT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    Date DATE NOT NULL,
    Diagnosis TEXT,
    Prescription TEXT,
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
);
CREATE TABLE IF NOT EXISTS Bill (
    BillID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    BillDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    isPaid BOOLEAN NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

--HELP PATIENTS TO VIEW UNPAID BILLS
CREATE PROCEDURE PatientUnpaidBills(IN targetPatient INT)
BEGIN
    SELECT b.BillID, b.BillDate, b.TotalAmount, b.isPaid
    FROM Bill b
    WHERE b.PatientID = targetPatient AND isPaid = FALSE;
END;

--HELP DOCTORS TO CHECK THEIR UPCOMING APPOINTMENTS FOR THE DAY
CREATE PROCEDURE DoctorAppointmentsByDay(IN targetDoctor INT, IN targetDate DATE)
BEGIN
    SELECT a.AppointmentID, a.PatientID, a.AppointmentTime
    FROM Appointment a 
    WHERE a.DoctorID = targetDoctor AND a.AppointmentDate = targetDate;
END;

--HELP PATIENTS TO VIEW THEIR FUTURE APPOINTMENTS, ALSO CHECK WHICH DOCTOR THEY ARE SEEING
CREATE PROCEDURE PatientUpcomingAppointments(IN targetPatient INT)
BEGIN
    SELECT a.AppointmentID, a.DoctorID, a.AppointmentDate, a.AppointmentTime
    FROM Appointment a 
    WHERE a.PatientID = targetPatient AND a.AppointmentDate >= CURDATE();
END;