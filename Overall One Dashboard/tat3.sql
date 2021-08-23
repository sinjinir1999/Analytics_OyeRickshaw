select case when months = 6 then 'June'
when months = 7 then 'July' 
when months = 5 then 'May'
when months = 4 then 'April'
when months = 8 then 'August' end as months,total_vbn,
round((zero_to_2_days*100.0/total_vbn),2)||'%' zero_to_2_days
,round((three_to_8_days*100.0/total_vbn),2)||'%' three_to_8_days
,round((nine_to_15_days*100.0/total_vbn),2)||'%' nine_to_15_days
,round((greater_than_15*100.0/total_vbn),2)||'%' greater_than_15
from
(
select extract(months from ob_date) months,count(distinct case when vc_last_call_date is not null then vbn end) as total_vbn,count(distinct case when tat between 0 and 2 then vbn end) as zero_to_2_days,
count(distinct case when tat between 3 and 8 then vbn end) as three_to_8_days,
count(distinct case when tat between 9 and 15 then vbn end) as nine_to_15_days,
count(distinct case when tat >= 16 then vbn end) as greater_than_15
from
(
Select date(onboarding_date) as ob_date,vehicle_consolidated.vbn,vc_last_call_date,abs(date(vc_last_call_date)-date(onboarding_date)) tat
from tmp_operations.vehicle_consolidated
left join tmp_operations.zoho_crm_data on vehicle_consolidated.driver_mobile=zoho_crm_data.driver_phone_number
where onboarding_date between '2021-04-01' and last_day(current_date)
) as a
group by 1
order by 1
) as a
