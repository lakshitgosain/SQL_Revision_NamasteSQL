-- 1- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909
-- 2- write a query to find orders where city is null (2 rows)
begin tran
update orders 
set city=NULL
where  order_id in ('CA-2020-161389','US-2021-156909')
	
select * from orders where order_id in ('CA-2020-161389','US-2021-156909')
rollback


--3- write a query to get total profit, first order date and latest order date for each category
select sum(profit) as tot_profit, min(order_date) as min_date, max(order_date) as max_date
from orders
group by category

--4- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

select sub_category , avg(profit) as avg_profit, max(profit)/2 as max_profit
from orders
group by sub_category
having avg(profit) > max(profit)/2


-- 5 write a query to find students who have got same marks in Physics and Chemistry. 

create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);


select student_id,marks from exams 
where subject in ('Chemistry','Physics')
group by student_id,marks
having count(*)=2

--6- write a query to find total number of products in each category.

select sub_category,count(product_id) as product_count
from orders
group by sub_category

--7- write a query to find top 5 sub categories in west region by total quantity sold

select top (5) sub_category,region, sum(quantity) as sum_qty
from orders
group by sub_category, region
having region in ('West')
order by sum(quantity) desc

select top 5  sub_category, sum(quantity) as total_quantity
from orders
where region='West'
group by sub_category
order by total_quantity desc


--8- write a query to find total sales for each region and ship mode combination for orders in year 2020

select region,ship_mode, sum(sales) as sales_reg
from (
select * from orders where order_date between '2020-01-01' and '2020-12-31') as A
group by region, ship_mode


select region, ship_mode , sum(sales) as sales_reg
from orders
having order_date between '2020-01-01' and '2020-12-31'
group by region, ship_mode