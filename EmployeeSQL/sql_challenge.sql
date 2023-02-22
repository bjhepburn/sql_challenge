DROP TABLE if exists departments;
DROP TABLE if exists dept_emp;
DROP TABLE if exists dept_manager;
DROP TABLE if exists employees;
DROP TABLE if exists salaries;
DROP TABLE if exists titles;

-- Creating tables, imported from QuickDBD file.

CREATE TABLE "employees" (
    "emp_no" VARCHAR(30)   NOT NULL,
    "emp_title_id" VARCHAR(30)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(30)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(30)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "salaries" (
    "emp_no" VARCHAR(30)   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "emp_no" VARCHAR(30)   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" VARCHAR(30)   NOT NULL,
    "dept_no" VARCHAR(30)   NOT NULL
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "dept_name" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

-- Copy data from CSV into tables

COPY departments
FROM 'C:\Users\Brad Hepburn\Desktop\github_repos\sql_challenge\EmployeeSQL\data\departments.csv'
DELIMITER ','
CSV HEADER;

COPY dept_emp
FROM 'C:\Users\Brad Hepburn\Desktop\github_repos\sql_challenge\EmployeeSQL\data\dept_emp.csv'
DELIMITER ','
CSV HEADER;

COPY dept_manager
FROM 'C:\Users\Brad Hepburn\Desktop\github_repos\sql_challenge\EmployeeSQL\data\dept_manager.csv'
DELIMITER ','
CSV HEADER;

COPY employees
FROM 'C:\Users\Brad Hepburn\Desktop\github_repos\sql_challenge\EmployeeSQL\data\employees.csv'
DELIMITER ','
CSV HEADER;

COPY salaries
FROM 'C:\Users\Brad Hepburn\Desktop\github_repos\sql_challenge\EmployeeSQL\data\salaries.csv'
DELIMITER ','
CSV HEADER;

COPY titles
FROM 'C:\Users\Brad Hepburn\Desktop\github_repos\sql_challenge\EmployeeSQL\data\titles.csv'	
DELIMITER ','
CSV HEADER;

--DATA ANALYSIS
--1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, last_name, first_name, sex, salaries.salary
FROM employees, salaries
WHERE salaries.emp_no = employees.emp_no;

--2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name,last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR from hire_date) = 1986;

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT employees.first_name, employees.last_name, dept_manager.emp_no, departments.dept_name, dept_manager.dept_no 
FROM dept_manager
LEFT JOIN departments
ON departments.dept_no = dept_manager.dept_no
LEFT JOIN employees
ON employees.emp_no = dept_manager.emp_no;

--4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT e.first_name, e.last_name, e.emp_no, d.dept_name, de.dept_no
FROM employees as e
LEFT JOIN dept_emp as de
ON de.emp_no = e.emp_no
LEFT JOIN departments as d
ON d.dept_no = de.dept_no;

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT first_name, last_name, emp_no
FROM employees
WHERE emp_no IN
(
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no =
	(
		SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'
	)
);

--7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.first_name,e.last_name,de.emp_no,d.dept_name
FROM dept_emp as de
INNER JOIN
employees as e
ON e.emp_no =  de.emp_no
INNER JOIN
departments as d 
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' or d.dept_name = 'Development';

--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, count(last_name) as count
FROM employees
GROUP BY last_name
ORDER BY count DESC


