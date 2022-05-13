---------------- COMMON TABLE EXPRESSIONS ----------------


-- 1. Calculate the average salary of all employees
-- SELECT AVG(salary) AS average_salary_across_company FROM employees;


-- 2. Calculate the average salary of the employees in each team
-- SELECT departments.id AS department_id , departments.name AS department_name, AVG(employees.salary) AS avg_salary
-- FROM departments
-- LEFT JOIN employees
-- ON departments.id = employees.department_id
-- GROUP BY departments.id
-- ORDER BY departments.id;

-- 3. Using a CTE find the ratio of each employees salary to their team average
-- WITH department_avg_salary (department_id, department_name, average_salary) AS
--     (SELECT
--         departments.id, 
--         departments.name, 
--         AVG(employees.salary)
--     FROM departments
--     INNER JOIN employees
--     ON departments.id = employees.department_id
--     GROUP BY departments.id, departments.name
--     ORDER BY departments.id)
-- SELECT
--     employees.id,
--     employees.salary / department_avg_salary.average_salary AS salary_ratio
-- FROM employees
-- INNER JOIN department_avg_salary
-- ON employees.department_id = department_avg_salary.department_id;

-- 4. Find the employee with the highest ratio in Argentina
-- WITH department_avg_salary (department_id, department_name, average_salary) AS
--     (SELECT
--         departments.id, 
--         departments.name, 
--         AVG(employees.salary)
--     FROM departments
--     INNER JOIN employees
--     ON departments.id = employees.department_id
--     GROUP BY departments.id, departments.name
--     ORDER BY departments.id)
-- SELECT
--     employees.id,
--     employees.first_name,
--     MAX(employees.salary / department_avg_salary.average_salary) AS salary_ratio
-- FROM employees
-- INNER JOIN department_avg_salary
-- ON employees.department_id = department_avg_salary.department_id
-- WHERE employees.country = 'Argentina'
-- GROUP BY employees.id
-- ORDER BY salary_ratio DESC
-- LIMIT 1;

-- 5. Extension: Add a second CTE calculating the average salary for each country and add a column showing the difference between each employee's salary and their country averageS 
-- WITH country_avg_salary (country_name, average_salary) AS
--     (SELECT
--         country, 
--         AVG(salary)
--     FROM employees
--     GROUP BY country)
-- SELECT
--     employees.id,
--     employees.first_name,
--     employees.last_name,
--     employees.country,
--     employees.salary,
--     employees.salary - country_avg_salary.average_salary AS diff_from_country_avg
-- FROM employees
-- INNER JOIN country_avg_salary
-- ON employees.country = country_avg_salary.country_name;

---------------- WINDOW FUNCTIONS ----------------


-- 1. Find the running total of salary costs as the business has grown and hired more people
-- SELECT 
--     employees.id,
--     employees.start_date,
--     employees.salary,
--     SUM(employees.salary) OVER (ORDER BY employees.start_date) AS salary_running_total
-- FROM employees;

-- 2. Determine if any employees started on the same day (hint: some sort of ranking may be useful here)
-- WITH date_ranks (start_date, rank) AS
--     (SELECT
--         employees.start_date,
--         RANK() OVER (PARTITION BY employees.start_date ORDER BY employees.id)
--     FROM employees)
-- SELECT * 
-- FROM date_ranks
-- WHERE date_ranks.rank = 2;
 -- this determines if employees started on the same day by displaying the dates 

--  SELECT 
-- 	RANK() OVER (ORDER BY start_date) AS simple_ranking,
-- 	DENSE_RANK() OVER (ORDER BY start_date) AS dense_ranking
-- FROM employees
-- ORDER BY simple_ranking DESC
-- this was solution given: it shows the rank and dense rank for each employee sorted by start date

-- 3. Find how many employees there are from each country
-- SELECT 
-- employees.country,
-- COUNT(*)
-- FROM employees
-- GROUP BY employees.country;

-- 4. Show how the average salary cost for each department has changed as the number of employees has increased
-- SELECT 
--     *,
--     AVG(employees.salary) OVER (PARTITION BY departments.id ORDER BY employees.start_date)
-- FROM departments
-- INNER JOIN employees
-- ON departments.id = employees.department_id;

-- 5. Extension: Research the EXTRACT function and use it in conjunction with PARTITION and COUNT to show how many employees started working for BusinessCorp™ each year. If you're feeling adventurous you could further partition by month...



---------------- COMBINING THE TWO ----------------


-- 1. Find the maximum and minimum salaries
--SELECT MAX(salary), MIN(salary) FROM employees;

-- 2. Find the difference between the maximum and minimum salaries and each employee's own salary
--SELECT id, salary, MAX(salary) OVER () - salary AS diff_between_max_and_salary, salary - MIN(salary) OVER () AS diff_between_salary_and_min FROM employees;

-- 3. Order the employees by start date. Research how to calculate the NOT THIS->(median salary value and) the standard deviation in salary values and show how these change as more employees join the company
-- SELECT 
--     id, 
--     start_date, 
--     salary,
--     STDDEV(salary) OVER (ORDER BY start_date)
-- FROM employees;

-- 4. Limit this query to only Research & Development team members and show a rolling value for only the 5 most recent employees.
-- SELECT 
--     employees.id, 
--     departments.name,
--     start_date, 
--     salary,
--     STDDEV(salary) OVER (ORDER BY start_date ROWS 5 PRECEDING)
-- FROM employees
-- INNER JOIN departments
-- ON employees.department_id = departments.id
-- WHERE departments.name = 'Research and Development';

