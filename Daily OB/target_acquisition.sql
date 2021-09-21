select *,(target-(ride_acquired+delivery_acquired+swap_acquired)) overall_target_delta
,(ride_target-ride_acquired) ride_delta
,(delivery_target-delivery_acquired) delivery_delta
,(swap_target-swap_acquired) swap_delta
from
(
select zone_new,max(target) as target, max(ride) ride_target, max(swap) swap_target, max(delivery) delivery_target
,count(distinct case when first_ride between '2021-08-26' and '2021-09-25' then vbn end) as ride_acquired
,count(distinct case when first_delivery_date between '2021-08-26' and '2021-09-25' then vbn end) as delivery_acquired
,count(DISTINCT case when first_swap_date between '2021-08-26' and '2021-09-25' then vbn end) AS swap_acquired
from tmp_operations.vehicle_consolidated
left join tmp_operations.ob_targets on vehicle_consolidated.zone_new = ob_targets.zone
where zone_new is not null
group by 1
) as a





