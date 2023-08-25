
select * from 
(select *,
row_number() over(partition by dept_id order by salary desc) as rn 
from employee ) as A
where rn<=2

--We cannot use where clause with the window functions as where clause executes before the window function and the 'rn' column isn't identified


select *,
row_number() over(order by salary desc) as rn, 
rank() over (order by salary desc) as rnk
from employee

-- Notice that 2 people with the same salary will have the same rank, while the rownumber is increasing incrementally


select *,
row_number() over(partition by dept_id order by salary desc) as rn, 
rank() over (partition by dept_id order by salary desc) as rnk
from employee

select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over (partition by dept_id order by salary desc) as rnk1,
row_number() over (partition by dept_id,salary order by salary desc , emp_name asc) as rnk2
from employee

-- If there are more than 1 records in the window only then it is going to consider other row for row numbers
--the partiton is now being created on the combination of 2 columns (salary and dept)


--More Functions
select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over (partition by dept_id order by salary desc) as rnk1,
dense_rank() over (partition by dept_id order by salary desc) as dnrnk
from employee

-- Rank and dense rank are same but Dense rank doesn't skip the position . AS we can see, we are getting 1,2,2,3 in dense rank and 1,2,2,4 in rank. No Number is skipped

select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over (order by salary desc) as rnk1,
dense_rank() over (order by salary desc) as dnrnk
from employee

-- If we want top 2 employees in each dept. if we use rank, 3 rows will come. We can anytime appy another order by condition
select * from
(select *,
row_number() over(partition by dept_id order by salary desc) as rn,
rank() over (order by salary desc, emp_age asc) as rnk1,
dense_rank() over (order by salary desc) as dnrnk
from employee) as A
where rnk1<=2

-- write a query to print top 5 selling products from each category from orders table

select * from (
select *,
dense_rank() over(partition by category order by tot_sales desc) as d_rnk
from (
select *,sum(sales) as tot_sales
from orders
group by category) as B) as A
where d_rnk<=5

--correct logic is below. THis also contains nested CTEs


with cat_product_sales as (
select category, product_id, sum(sales) as category_sales
from orders
group by category,product_id),
rnk_sales as (
select *,
rank() over(partition by category order by category_sales desc) as rn
from cat_product_sales)
select * from rnk_sales 
where rn<=5




-- Lead Function. We need to pass 2 mandatory arguments. It gives the next emp_id.
--If we mention 2 ,then it skips 2 emps.

-- In other terms , it is giving the employee id of the next employee.

select *,
lead(emp_id,2) over(order by salary desc) as lead_emp
from employee


-- We can also define the default as well. We can define a constant value or a column name. We wull not get nulls in that case.
select *,
lead(emp_id,2,9999) over(order by salary desc) as lead_emp
from employee


select *,
lead(emp_id,2, emp_age) over(order by salary desc) as lead_emp
from employee


select *,
lead(emp_id,2) over(partition by dept_id order by salary desc) as lead_emp
from employee


--Lag Function
select * , 
lead(salary,1) over(partition by dept_id order by salary desc) as lead_emp,
lag(salary,1) over (partition by dept_id order by salary asc) as lag_emp
from employee

-- IMP -- What lead is doing, we can achieve by using lag by managing the order by clause.



