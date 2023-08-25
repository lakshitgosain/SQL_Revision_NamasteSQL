--Stored Procedures--
--if we want to run queries in sequence, we can define a stored procedure, thenw e can call it in ad-hoc way or we can schedule it as well

create procedure spemp
as 
select * from employee

exec spemp


--If we want to pass a variable to the stored procedure, we can specify the parameter

alter procedure spemp(@salary int)
as 
select * from employee
where salary>@salary


exec spemp @salary=10000

-- We can pass as many parameters as we want to 

alter procedure spemp(@salary int, @dept_id int) as
select * from employee 
where salary>@salary and dept_id=@dept_id

exec spemp @salary=10000 , @dept_id=100

-- If we do not pass the names of the parameters , we should still get the results based on the position of the parameters we pass through

exec spemp 10000, 100

-- In Procedures, we can also have insert queries running within the procedure.

alter procedure spemp (@salary int, @dept_id int) as
insert into dept values(800, 'HR1')
select * from employee where salary>@salary and dept_id=@dept_id

--we can even put an if else condition. We can even add string to the display/output

alter procedure spemp (@salary int, @dept_id int) as
declare @cnt int

select @cnt= count(1) from employee  where dept_id=@dept_id

if @cnt=0
print 'There is no employee in this dept'

else 
print 'Total Employee'+cast(@cnt as varchar(10))

exec spemp @salary=100 ,@dept_id=100
exec spemp @salary=10, @dept_id=900

-- We can use if-else in case of stored procedure
-- IN normal sql query, we cannot use if-else, and only case-when queries
-- THis is because, stored procedures are under programability 


-- We can use output variables as well and use the outside the stored procedure

alter procedure spemp (@dept_id int, @cnt int out) as
 select @cnt=count(1) from employee where dept_id=@dept_id

 if @cnt=0
 print 'There is no employee'

--else 
--print 'total employee'+ cast(@cnt as varchar(10))

declare @cnt1 int
exec spemp 100, @cnt1  out
print @cnt1

--We can use the @cnt1 out variable outside the Stored Procedure


----Functions-------

select *, datepart(year, order_date) from orders --Datepart is an inbuilt function
--We can create out own custom functions. We can use them anywhere in the queries just like datepart function

alter function fnproduct(@arg1 int, @arg2 int) 
returns float 
as 
begin
return (select @arg1 * @arg2)
end


select [dbo].[fnproduct](4,5)

select *, datepart(year, order_date), [dbo].[fnproduct](row_id,quantity) from orders


-- We can also define a default value
alter function fnproduct(@arg1 int, @arg2 int=200) 
returns float 
as 
begin
return (select @arg1 * @arg2)
end


select [dbo].[fnproduct](4,default)


---Pivot and Unpivot---
-- If we want to pivot data
select 
category ,
sum(case when datepart(year,order_date)=2020 then sales end) as sales_2020,
sum(case when datepart(year, order_date)=2021 then sales end) as sales_2021
from orders 
group by category

--We can recreate the same result of the above query using pivot
select * from 
(select category, datepart(year, order_date) as yod , sales
from orders) t1
pivot(
sum(sales) for yod in ([2020],[2021]) --this is used as both filter and column name
) as t2

--We cannot use integer as a string, and that is the reason we need to give square bractes for the integer values. We can mention string values without sq. brackets.

select * from 
(select category, region, sales
from orders ) t1
pivot(
sum(sales) for region in (West, East, South,North)
) as t2

delete from orders where order_date='2020-01-01'-- it has a where condition

truncate table orders -- to delete all the rows and it does not have a where condition

commit
rollback

begin transaction
-- we can mention the query here
end 

--Truncate does not allow to rollback. Delete allows us to rollback
--Delete is DML
--Truncate is DDL
--We cannot rollback DDL. We can rollback DML


