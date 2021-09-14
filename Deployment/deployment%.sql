select 
(count(distinct case when first_ride is not null or first_delivery_date is not null or first_swap_date is not null then vbn end)*1.00 / 
count(distinct vehicle_consolidated.vbn)) deployed
from tmp_operations.vehicle_consolidated 
where onboarding_date >= '2021-08-26'
