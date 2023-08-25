-- TO read Data together from multiple ttables, we have the concept of joins .

--We can join the data together on the basis of some keys and get an output
-- We can apply the same logic with v-lookup

select o.order_id, r.return_reason 
from orders o
Inner Join returns r 
on o.order_id=r.order_id

--We only get the orders that are present in the orders table. THis is due to the inner join we are applying. 
select distinct o.order_id, o.order_date, r.return_reason
from orders o
Inner Join returns r
on 
o.order_id=r.order_id

select o.*
from orders as o
inner join returns as r
on o.order_id=r.order_id

-- DB Is smart enough to display the cols without alias if the column is present only in 1 table. If the column is in both the tables, we will receive an error for ambigious query/column

--Left Join
--THis is if we want to see all the orders. If there is no return order, put NA(NULL)
-- ALl the records from the left table are displayed and only the matching records from the right table will be displayed

select o.*, r.return_reason
from orders o
left join returns r
on o.order_id=r.order_id

--numbering below is the order of execution
select distinct o.order_id, r.return_reason --4
from orders o --1
left join --2
returns r --2
on o.order_id=r.order_id --3

--check the total loss due to returns
select r.return_reason,sum(o.sales) as total_sales
from orders o
inner join returns r
on o.order_id=r.order_id
group by r.return_reason

--return all the values where the return(right table) did not match. THese are basically the orders that have not been returned

select distinct o.order_id, r.return_reason --4
from orders o --1
left join returns r --2
on o.order_id=r.order_id --2
where r.return_reason is NULL --3


--We have more than 2 tables now

--cross join- every record will join with every other record

select * from employee, dept

select *
from employee e
INNER JOIN dept
on 1=1
order by e.emp_id

select * from employee

-- if there are 2 records in the 1st table and 3 records in the second table, then in total we will get 6 records


-- RIght join - We hardly use it as we can manipulate the positions of the tables in the left join itself...but it simply means that all records from the right table and NULL for the unmatched values from left table

select * 
from employee e
right join dept d
on e.dept_id=d.dep_id

--FUll Outer join 
--Whatever extra is there in the left join and whatever extra is there in the right join will also be displayed

select * from employee e
full outer join dept d
on d.dep_id=e.dept_id


--Join more than 2 Tables

select o.order_id, o.product_id, r.return_reason 
from orders o
inner join returns r on oorder_id=r.order_id
inner join people p on p.region=o.region