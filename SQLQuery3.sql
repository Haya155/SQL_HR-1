create table TempInstructors (
TempID INT,
TempName VARCHAR(50), 
JoinedDate DATE
);

create table Departments (
DepartmentID int primary key,
DepartmentName VARCHAR(100) not null unique
);

create table Students (
StudentID INT primary key,
FullName VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE, 
GPA DECIMAL(3,2),
DepartmentID INT foreign key references Departments(DepartmentID)
);

create table StudentProfiles (
ProfileID INT primary key,
StudentID INT UNIQUE foreign key references Students(StudentID),
Address VARCHAR(200),
EmergencyPhone VARCHAR(20)
);

create table Courses (
CourseID INT primary key, 
CourseName VARCHAR(100) NOT NULL,
Credits INT,
DepartmentID INT foreign key references Departments(DepartmentID)
);

create table StudentCourses(
 StudentID INT foreign key references Students(StudentID) ,
 CourseID INT foreign key references Courses(CourseID), 
 EnrollmentDate DATE DEFAULT GETDATE(),
  Primary Key(StudentID, CourseID) 
);

alter table Students 
add Age int;

drop table TempInstructors ;

insert into Departments
values(1, 'Computer Science'), (2, 'Software Engineering'), (3, 'Business Administration');

insert into Students
values(101,'Ali Smadi','ali@coursehub.com',3.80 ,1,22),
(102, 'Omar Ahmad', 'omar@coursehub.com' ,2.90 ,1,21),
(103, 'Laila Hassan', 'laila@coursehub.com' ,3.50 ,2,23),
(104, 'Tariq Zaid', 'tariq@coursehub.com' ,2.10 ,3,20);

insert into StudentProfiles
values (1, 101, 'Amman, Jordan', '0791111111'), (2, 102, 'Irbid, Jordan', '0792222222'), (3, 103, 'Zarqa, Jordan', '0793333333');

insert into Courses
values(201, 'Database Systems', 3, 1), (202, 'Web Development', 3, 1), (203, 'Software Architecture', 3, 2);

insert into StudentCourses
values(101,201,'2026-10-31'),
(101,202,'2026-10-31'),
(102,201,'2026-10-31'),
(103,203,'2026-10-31');

update Students 
set GPA=2.50
where StudentID = 104;

delete Students 
where StudentID = 104;

select * from Students;
select Students.FullName,Students.GPA,Departments.DepartmentName from Students
inner join Departments
on Students.DepartmentID=Departments.DepartmentID;

select Departments.DepartmentName ,Students.FullName 
from Departments
left join Students
on Departments.DepartmentID=Students.DepartmentID;

select Students.FullName,StudentProfiles.Address,StudentProfiles.EmergencyPhone from Students
inner join StudentProfiles
on StudentProfiles.StudentID= Students.StudentID;

select Students.FullName,Courses.CourseName ,StudentCourses.EnrollmentDate  from Students
inner join StudentCourses
on StudentCourses.StudentID=Students.StudentID
inner join Courses
on StudentCourses.CourseID=Courses.CourseID;
SELECT
    COUNT(*) AS TotalStudents,
    AVG(GPA) AS AverageGPA,
    MAX(GPA) AS HighestGPA,
    MIN(GPA) AS LowestGPA
FROM Students;
select DepartmentID,avg(GPA) as AverageGPA,count(*) as TotalStudents from Students
group by DepartmentID;

select DepartmentID,avg(GPA) as AverageGPA from Students
group by DepartmentID
having avg(GPA)>3.00;

select DepartmentID,count(*)as TotalStudents from Students
where GPA>=2.50
group by DepartmentID
having count(*)>1;

EXEC sp_helpindex 'Students' 

create NonClustered index IX_Students_Email
on Students(Email);

select * from Students
where GPA>(select avg(GPA) from Students);

Create View vw_StudentAcademicDetails as
select Students.StudentID,Students.FullName,Students.GPA,Departments.DepartmentName from Students
inner join Departments
on Students.DepartmentID=Departments.DepartmentID;

SELECT * FROM vw_StudentAcademicDetails;

create Procedure  sp_GetStudentsByDepartment
@DeptID INT 
as
begin
Select * From Students
Where DepartmentID = @DeptID;
End;
EXEC sp_GetStudentsByDepartment @DeptID = 2;