create database TechWorldHRDB ;


create table TemporaryStaff (
StaffID int PRIMARY KEY,
StaffName varchar(50) Not Null,
HireDate DATE
);

create table Departments  (
DepartmentID int PRIMARY KEY,
DepartmentName varchar(50) Not Null UNIQUE
);

create table Employees (
EmployeeID int PRIMARY KEY,
FullName varchar(100) Not Null,
Email VARCHAR(100) UNIQUE,
Salary DECIMAL(10,2) ,
DepartmentID int 
);

create table AccessCards (
   CardID INT PRIMARY KEY,
   CardNumber VARCHAR(50) NOT NULL UNIQUE,
  EmployeeAccessID INT UNIQUE REFERENCES Employees(EmployeeID)
);

create table Projects (
ProjectID int primary key ,
ProjectName varchar(100) not null

);

create table EmployeeProjects(
EmployeeID int Foreign key REFERENCES Employees(EmployeeID),
ProjectID   int Foreign key REFERENCES Projects(ProjectID),
AssignedDate  date,
PRIMARY KEY (EmployeeID, ProjectID)
);

ALTER TABLE Employees ADD PhoneNumber VARCHAR(20);

Drop Table TemporaryStaff;

INSERT INTO Departments 
VALUES (1, 'IT');
INSERT INTO Departments 
VALUES (2, 'HR');
INSERT INTO Departments
VALUES (3, 'Finance');


INSERT INTO Employees VALUES (1, 'Ahmad Ali', 'ahmad@techworld.com' , 1200.00 ,1, '0791111111');

INSERT INTO Employees VALUES (2, 'Sara Hassan', 'sara@techworld.com' , 950.00  ,2, '0792222222');

INSERT INTO Employees VALUES (3, 'Zaid Omar', 'zaid@techworld.com' , 1500.00 ,1, '0793333333');

INSERT INTO Employees VALUES (4, 'Mona Khaled', 'mona@techworld.com' , 800.00 ,3,  '0794444444');
insert into AccessCards 
values(1,101,1),
(2,102 ,2),
(3,103,3);
insert into Projects
values(1,'AI & Security Training'),
(2,'Cloud Migration');

insert into EmployeeProjects
values(1,1,'2026-10-30'),
(1,2,'2026-10-30'),
(2,1,'2026-10-30'),
(3,2,'2026-10-30');

UPDATE Employees SET Salary = 1350.00 WHERE EmployeeID = 1 ;
 
DELETE FROM Employees WHERE EmployeeID = 4;


 SELECT * FROM Employees;

 SELECT FullName, Salary FROM Employees;

 SELECT SUM(Salary) as TotalSalaries FROM Employees;

 SELECT AVG(Salary) as AverageSalary FROM Employees;

 SELECT MAX(Salary) as HighestSalary FROM Employees;

 SELECT MIN(Salary) as LowestSalary FROM Employees;

 SELECT COUNT(*) as TotalEmployees FROM Employees;

 select Employees.FullName,Employees.Salary,Departments.DepartmentName from Employees
 inner join Departments
 on Employees.DepartmentID= Departments.DepartmentID;

 select * from Departments
 left join Employees
 on Employees.DepartmentID= Departments.DepartmentID;

 select Employees.FullName,AccessCards.CardNumber from Employees
 inner join AccessCards 
 on AccessCards.EmployeeAccessID = Employees.EmployeeID;

 --Task 6.4: Multi-Table JOIN across Junction Table (M:N Relation)
--Write a query to list Employee FullName, ProjectName, and AssignedDate by joining Employees, EmployeeProjects, and Projects tables.


 --select Employees.FullName,Projects.ProjectName,EmployeeProjects.AssignedDate
 --from Employees
 --full join EmployeeProjects
 --on EmployeeProjects.EmployeeID=Employees.EmployeeID
 --full join Projects
 --on EmployeeProjects.ProjectID = Projects.ProjectID;

 select Employees.FullName,Projects.ProjectName,EmployeeProjects.AssignedDate
 from Employees
 inner join EmployeeProjects
 on EmployeeProjects.EmployeeID=Employees.EmployeeID
 inner join Projects
 on EmployeeProjects.ProjectID = Projects.ProjectID;

 select DepartmentID,sum(Salary) as totalSalary,count(*)as EmployeeCount from Employees
 group by DepartmentID;

 select DepartmentID,avg(Salary) as avgSalary from Employees
 group by DepartmentID
 having avg(Salary)>1000.00;

 select * from Employees
 where Salary >(select avg(Salary)from Employees) 

 create view vw_EmployeeDetails as
 select Employees.EmployeeID,Employees.FullName,Employees.Email,Departments.DepartmentName
 from Employees
 inner join Departments
 on Employees.DepartmentID= Departments.DepartmentID

 select  * from vw_EmployeeDetails;

 create Procedure sp_GetEmployeesByDepartment
 @DeptID INT
 as begin 
 select * from Employees
 where DepartmentID=@DeptID
 end;
EXEC sp_GetEmployeesByDepartment @DeptID = 1;
  

  create table EmployeeAudit(
  AuditID int primary key IDENTITY,
  EmployeeID int,
  Action VARCHAR(50),
  ActionDate DATETIME
  );

  create trigger trigger01
  on Employees
  after delete
  as begin
 INSERT INTO EmployeeAudit(EmployeeID,Action,ActionDate)
    SELECT EmployeeID,'DELETE',GETDATE()
    FROM deleted;
END;
insert into Employees
values(5,'Haya Ahmed','Haya@gmail.com',1700.00,2,0794444444);

DELETE FROM Employees
WHERE EmployeeID = 5;

select *FROM EmployeeAudit