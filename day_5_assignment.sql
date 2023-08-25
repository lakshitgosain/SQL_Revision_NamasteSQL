--1- write a query to get region wise count of return orders

select region, count(*)
from orders
group by region

--2- write a query to get category wise sales of orders that were not returned

select category, sum(sales) as total_sales
from orders o
left join returns r
on o.order_id=r.order_id
where r.return_reason is NULL
group by category


select o.order_id, r.return_reason
from orders o
left join returns r
on o.order_id=r.order_id

--3- write a query to print dep name and average salary of employees in that dep .
select d.dep_name, avg(e.salary) as avg_salary
from employee e
inner join dept d
on d.dep_id=e.dept_id
group by d.dep_name


--4- write a query to print dep names where none of the emplyees have same salary.

select d.dep_name
from employee e
inner join dept d
on d.dep_id=e.dept_id
group by d.dep_name
having count(1)=1

select * from employee
select * from dept


--5- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)


select o.sub_category 
from orders o 
inner join returns r
on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3


--6- write a query to find cities where not even a single order was returned.


select o.city,count(r.return_reason) from orders o
left join returns r
on o.order_id=r.order_id
group by city 
having count(r.return_reason)=0

--7- write a query to find top 3 subcategories by sales of returned orders in east region

select TOP(3) sub_category,sum(sales) as total_sales
from orders o
inner join returns r
on o.order_id=r.order_id
where o.region='East'
group by o.sub_category
order by total_sales desc

--8- write a query to print dep name for which there is no employee

select d.dep_id
from dept d
left join employee e
on e.dept_id=d.dep_id
group by d.dep_id
having count(e.emp_id)=0

--9- write a query to print employees name for dep id is not avaiable in dept table

select *
from employee e
left join dept d
on d.dep_id=e.dept_id
where d.dep_id is NULL












