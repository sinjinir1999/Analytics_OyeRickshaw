select zone_new,new_vbn,round((deployed*100.0/new_vbn),2) || '%' as deployment_percentage,ride_trx as ride_deployment, delivery_trx as delivery_deployment, swap_trx as swap_deployment
from
(
Select zone_new,
count(distinct vbn)as new_vbn,
count(distinct case when first_ride is not null or first_delivery_date is not null or first_swap_date is not null then vbn end) as deployed,
count(distinct case when onboarding_biz='RIDE ONBOARDING' then  vbn end) as ride_trx,
count(distinct case when onboarding_biz='DELIVERY ONBOARDING' then vbn end) as delivery_trx,
count(distinct case when onboarding_biz='SWAP ONBOARDING' then vbn end) as swap_trx
from tmp_operations.vehicle_consolidated 
where onboarding_date>='2021-08-26' and zone_new<>''
group by 1
) as a
