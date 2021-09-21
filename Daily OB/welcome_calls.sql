
select onboarding_date,count(distinct vehicle_consolidated.vbn) total_vbn_generated
,count(distinct case when welcome_call.count_of_calls >= 1 then vehicle_consolidated.vbn end) as total_calls_done
,count(distinct case when welcome_call.welcome_call = 'Yes' then vehicle_consolidated.vbn end) as connected_calls
,count(distinct case when biz_interested = 'Ride' then welcome_call.vbn end) as Ride_Interested
,count(distinct case when biz_interested = 'Ride' and (first_ride is not null or first_delivery_date is not null or first_swap_date is not null) then vehicle_consolidated.vbn end) as ride_deployed
,count(distinct case when biz_interested = 'Delivery' then welcome_call.vbn end) as Delivery_Interested
,count(distinct case when biz_interested = 'Delivery' and (first_ride is not null or first_delivery_date is not null or first_swap_date is not null) then vehicle_consolidated.vbn end) as delivery_deployed
,count(distinct case when biz_interested = 'Swap' then welcome_call.vbn end) as Swap_Interested
,count(distinct case when biz_interested = 'Swap' and (first_ride is not null or first_delivery_date is not null or first_swap_date is not null) then vehicle_consolidated.vbn end) as swap_deployed
from tmp_operations.vehicle_consolidated
left join tmp_operations.welcome_call on vehicle_consolidated.vbn = welcome_call.vbn
where onboarding_date between current_date-6 and current_date
group by 1
order by 1 desc
