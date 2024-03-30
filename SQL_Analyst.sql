--- Tỉ lệ khách hàng mua bảo hiểm xe 
select count(id) as total_customer,
       count(case when [CarInsurance] = 1 then id end) as customer_CarInsurance,
	    100.0*count(case when [CarInsurance] = 1 then id end)/count(id) as pct_customer_CarInsurance,
		count(case when [CarInsurance] = 0 then id end) as customer_NoCarInsurance,
	   100.0*count(case when [CarInsurance] = 0 then id end) /count(id) as  pct_customer_NoCarInsurance
from [dbo].[CarInsurance]
---Mối liên hệ giữa các nhóm tuổi và quyết định mua bao hiểm xe
---Có sự khác biệt về tỷ lệ mua bảo hiểm xe giữa các nhóm tuổi không?
SELECT count(id) as number_customer,
       Age_group,
	   round(100.0*count(id)/(select count(id) from [dbo].[CarInsurance] where [CarInsurance] = 1),2) as pct_age
From (
SELECT id,
       case when age <= 10 then '< 10'
	        when age > 10 and age <=20 then '11-20'
			when age > 20 and age <= 30 then '21-30'
			when age > 30 and age <= 40 then '31-40'
			when age > 40 and age <= 50 then '41-50'
			when age > 50 and age <= 60 then '51-60'
			when age > 60 and age <= 70 then '61-70'
			when age > 70 and age <= 80 then '71-80'
			else '80+' end as Age_Group
from [dbo].[CarInsurance]
WHERE [CarInsurance] = 1
) as subquery
group by Age_Group
Order by Count(id) desc
 --- Mối liên hệ giữa các nhóm tuổi và quyết định mua bao hiểm xe
--- Có sự khác biệt về tỷ lệ mua bảo hiểm xe giữa các nhóm tuổi không? 
SELECT 
    [Job],
    COUNT(id) AS number_customer,
    --AVG([Balance]) AS Avg_Balance,
    COUNT(id) * 100.0 / (SELECT COUNT(id) FROM [dbo].[CarInsurance] WHERE [CarInsurance] = 1) AS pct
FROM 
    [dbo].[CarInsurance]
WHERE [CarInsurance] = 1
GROUP BY 
    [Job]
ORDER BY 
    COUNT(id) DESC, AVG([Balance]) DESC;

--Có sự khác biệt trong việc mua bảo hiểm xe giữa khách hàng độc thân và đã kết hôn?
select [Marital],
       count(id) as number_customer,
       round(100.0*count(id) /(select count(id) from [dbo].[CarInsurance] where [CarInsurance] = 1),2) as pct_marital
from [dbo].[CarInsurance]
where [CarInsurance] = 1
group by [Marital]
order by count(id) desc
--- Có sự  mối tương quan giữa nhóm khách hàng có khoản vay nhà ở và khoản vay xe và quyết định mua bảo hiểm xe.
SELECT 
    total_customer,
    total_hh_insurance_and_car_loan,
    100.0*total_hh_insurance_and_car_loan  / total_customer AS percentage_hh_insurance_and_car_insurance
FROM (
    SELECT 
        COUNT(*) AS total_customer,
        SUM(CASE WHEN HHInsurance = 0 AND [CarLoan] = 0  THEN 1 ELSE 0 END) AS total_hh_insurance_and_car_loan
    FROM 
        CarInsurance
	WHERE CarInsurance = 1
) AS subquery;

---Tính ti lệ khách hàng có nhu cầu mua bảo hiểm xe của nhóm khách hàng có nợ xấu và không có nợ xấu
SELECT
    [Default] AS Has_Default,
	COUNT(id) AS customer,
	100.0 * COUNT(id) / (SELECT COUNT(*) FROM [dbo].[CarInsurance] WHERE [CarInsurance] = 1) AS Percentage_Car_Insurance
FROM
    [dbo].[CarInsurance]
WHERE 
    [CarInsurance] = 1
GROUP BY
    [Default];
