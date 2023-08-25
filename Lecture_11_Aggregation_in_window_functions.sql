--Aggregation using window functions

select *,
avg(salary) over(partition by dept_id) as avg_salary
from employee

--NOTE : We do not need to have order by as mandatory in case of agregation.

select *, 
min(salary) over(partition by dept_id) as min_salary,
max(salary) over(partition by dept_id) as max_salary
from employee

--It doesn't matter how the salary is sorted(order by) , for calculating avg,min, max etc.. so we dont need order by

select *, 
min(salary) over(partition by dept_id) as min_salary,
max(salary) over(partition by dept_id) as max_salary,
count(salary) over(partition by dept_id) as count_employee
from employee

--what happens if we use order by. It is giving us running salary..Adding the previous salary to the next salary. Look below query

select *, 
sum(salary) over(partition by dept_id order by emp_age asc) as running_salary,
sum(salary) over(partition by dept_id) as sum_salary
from employee

--If we use only order by with aggregation of window functions, we will get the running salary of all the table


select *, 
sum(salary) over(order by emp_id asc) as running_salary,
sum(salary) over(partition by dept_id) as sum_salary
from employee

-- We have all the liberty while using aggregation for window funcitons

--Max is interesting. We will get running max value

select *, 
max(salary) over(partition by dept_id) as max_salary,
max(salary) over(order by salary asc) as running_max_salary
from employee

select *,
sum(salary) over(order by salary) as running_salary
from employee

-- In the above , we are getting inconsistent results.
--If order by has duplicates, it will consider them as one, and aggregate them
-- To ensure we do not get into this issue, we need to use a column that is not duplicate or use combo of 2 columns

select *,
sum(salary) over(order by salary,emp_id desc) as running_salary
from employee

select *, 
avg(salary) over (partition by dept_id order by emp_id) as running_salary
from employee

-- Order of execution is partition first and then order by

-- Rolling Sum -- only previous n are considered for addition and not all the values
select *,
sum(salary) over(order by emp_id rows between 2 preceding and current row ) as rolling_sum
from employee


select *,
sum(salary) over(order by emp_id rows between 1 preceding and 1 following) as rolling_sum
from employee

-- Get the rows between 5 and 10. We can also apply partition for the same. Query below


select *,
sum(salary) over(partition by dept_id order by emp_id rows between 5 following and 10 following) as rolling_sum
from employee

--Unbounded keyword- All the rows previous to the current row
select *,
sum(salary) over(order by emp_id rows between unbounded preceding and current row) as rolling_salary_2
from employee


-- SUm of all the columns. We will get 91000 for all the rows for the col total salary
select *, 
sum(salary) over(order by emp_id rows between unbounded preceding and unbounded following) as total_salary_sum
from employee

-- An unrelated function to this lecture
select * ,
first_value(salary) over (order by salary) as first_value,
last_value(salary) over (order by salary) as last_value
from employee
--As we can notice the fist value is the first value but the last value is not the last value for the full table.

select * ,
first_value(salary) over(order by salary) as first_salary,
first_value(salary) over(order by salary desc) as last_salary,
last_Value(salary) over (order by salary rows between unbounded preceding and unbounded following) as last_salary1
from employee


-- Rolling sum of sales per year
 with month_wise_sales as (
 select datepart(year, order_date) as year_order , datepart(month, order_date) as month_order , sum(sales) as total_sales
 from orders
 group by datepart(year, order_date) , datepart(month, order_date) )
 select 
 year_order, month_order, total_sales, sum(total_sales) over(order by year_order, month_order rows between 2 preceding and current row) as rolling_sales
from month_wise_sales


