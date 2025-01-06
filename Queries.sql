select * from features;
select * from stores;
select * from test;
select * from train;

UPDATE train
SET IsHoliday = TRIM(REPLACE(REPLACE(IsHoliday, '\r', ''), '\n', ''))
WHERE IsHoliday LIKE '%TRUE%';





-------------------------------------------------------------------
-- Overall Total Sales Per Department Per Store--

Select 
		Date,
        monthname(Date) as 'Month Name' ,
        quarter(date) as 'Quarter',
		FLOOR(DATEDIFF(Date, (SELECT MIN(Date) FROM train)) / 7) + 1 AS 'Week' ,
		store as 'Store No' , 
		Dept as 'Department', 
		Weekly_Sales as 'Weekly Sales',
        IsHoliday 
 from train
 order by Weekly_Sales desc;
 
 ------------------------------------------------------------------
 -- Yearly Sales by Store with Department Breakdown --
Select 	
		year(Date) as 'Year',
		store as 'Store No' , 
		Dept as 'Department', 
        Round(Sum(Weekly_Sales),2) as 'Yearly sale'
 from train
 Group by store , Dept , Year(Date)
 order by sum(Weekly_Sales)Desc;
 
-------------------------------------------------------------------
-- Quarterly Sales by Store with Department Breakdown --

Select 	
		store as 'Store No' , 
		Dept as 'Department', 
        quarter(Date) As 'Quarter',
		Round(Sum(Weekly_Sales),2) as 'Quarterly Sales'
 from train
 Group by store,Dept,quarter(Date)
 order by sum(Weekly_Sales)Desc;

------------------------------------------------------------------
 -- Monthly Sales by Store with Department Breakdown --
 Select 	
		monthname(Date) as 'Month',
		store as 'Store No' , 
		Dept as 'Department', 
        Round(Sum(Weekly_Sales),2) as 'Monthly sale'
 from train
 Group by store,Dept,monthname(Date)
 order by sum(Weekly_Sales)Desc;
------------------------------------------------------------------
-- Top 3 & Bottom 3 Stores according to Total Sales--
(
Select Store, Round(sum(weekly_Sales),2) as 'Total Sales'
from train
Group by Store 
order by sum(weekly_Sales) desc
Limit 3
)
Union 
(
Select Store, Round(sum(weekly_Sales),2) as 'Total Sales'
from train
Group by Store 
order by sum(weekly_Sales) asc
Limit 3
);

--------------------------------------------------------------------------
-- Top 3 & Bottom 3 Department according to Total Sales--
(
Select Dept, Round(sum(weekly_Sales),2) as 'Total Sales'
from train
Group by Dept 
order by sum(weekly_Sales) desc
Limit 3
)
Union 
(
Select Dept, Round(sum(weekly_Sales),2) as 'Total Sales'
from train
Group by Dept 
order by sum(weekly_Sales) asc
Limit 3
);

-------------------------------------------------------------------
-- Total Sales on Weekend & Week-Days --
(
Select 
        Round(Sum(Weekly_Sales),2) as 'Total Sales',
IsHoliday from train
where 
	IsHoliday = 'True' 
)
Union
(
Select 
        Round(Sum(Weekly_Sales),2) as 'Total Sales',
IsHoliday from train
where 
		IsHoliday = 'FALSE'
);

-------------------------------------------------------------------
        
-- Average Sales on Week-Days & Weekend --      
        
(     
	select
		Round(avg(Weekly_Sales),2) as 'Average Sale', 
IsHoliday from train
where 
		IsHoliday = 'True'
)
Union
(

	select 
		Round(avg(Weekly_Sales),2) AS 'Average Sale',
IsHoliday from train
where 
		IsHoliday = 'FALSE'
);


------------------------------------------------------------------

select * from features;
select * from stores;
select * from test;
select * from train;

Select 	td.store,
		td.Dept,
        td.Date,
        ta.temperature,
        td.Weekly_Sales,
        td.IsHoliday
 from train td
 Join 	features ta 
 on 	ta.date = td.date 
 and 
		ta.store = td.Store
Order by td.Weekly_Sales desc;

------------------------------------------------------------------
select 
Case 
		when ta.temperature < 30 then 'Below 30' 
        when ta.temperature between 30 and 60 then '30-60'
        when ta.temperature > 60 then 'Above 60'
        end as 'Temperature' ,
        Round(AVG(td.Weekly_Sales),2) as 'Average Sales'
        
        from train td
        
JOIN features ta 
    ON ta.date = td.date AND ta.store = td.Store
Group by Case 
		when ta.temperature < 30 then 'Below 30' 
        when ta.temperature between 30 and 60 then '30-60'
        when ta.temperature > 60 then 'Above 60'
        End
Order by AVG(td.Weekly_Sales);