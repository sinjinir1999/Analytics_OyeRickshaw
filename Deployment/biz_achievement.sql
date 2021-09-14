select distinct onboarding_biz,
case when onboarding_biz = 'RIDE ONBOARDING' then 220 
when onboarding_biz = 'DELIVERY ONBOARDING' then 206
when onboarding_biz = 'SWAP ONBOARDING' then 310 else 0 end as Target,cross_ob as total_deployment,round((cross_ob*100.0/target),2)||'%' as achievement_percentage
from tmp_operations.vehicle_consolidated
left join
(
select total_ob,count(distinct vbn) cross_ob
from
(
select vbn,
case when first_swap_date is not null then 'SWAP ONBOARDING'
when first_delivery_date is not null then 'DELIVERY ONBOARDING'
when first_ride is not null then 'RIDE ONBOARDING' end as total_ob
from tmp_operations.vehicle_consolidated
where onboarding_date >= '2021-08-26' and onboarding_biz <> 'ONBOARDING CHURN'
) as a
group by 1
) as a on vehicle_consolidated.onboarding_biz = a.total_ob
where onboarding_date >= '2021-08-26' and onboarding_biz <> 'ONBOARDING CHURN'

