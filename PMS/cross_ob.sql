

Select 'CROSS ONBOARDING RIDE' AS cross_ob_biz,vbn,driver_mobile,zone_new,hub,first_ride,first_delivery_date,first_swap_date
from tmp_operations.vehicle_consolidated
where onboarding_biz<>'RIDE ONBOARDING' and first_ride is not null and first_ride between '2021-08-26' and '2021-09-25' 
union
Select 'CROSS ONBOARDING DELIVERY' AS cross_ob_biz,vbn,driver_mobile,zone_new,hub,first_ride,first_delivery_date,first_swap_date
from tmp_operations.vehicle_consolidated
where onboarding_biz<>'DELIVERY ONBOARDING' and first_delivery_date is not null and  first_delivery_date between '2021-08-26' and '2021-09-25' 
union
Select 'CROSS ONBOARDING SWAP' AS cross_ob_biz,vbn,driver_mobile,zone_new,hub,first_ride,first_delivery_date,first_swap_date
from tmp_operations.vehicle_consolidated
where onboarding_biz<>'SWAP ONBOARDING' and first_swap_date is not null and first_swap_date between '2021-08-26' and '2021-09-25'
