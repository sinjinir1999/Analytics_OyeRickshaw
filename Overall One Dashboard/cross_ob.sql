select Months,Total_VBN
,round((Ride_Only*100.0/Total_VBN),2)||'%' as Ride_Only
,round((Delivery_Only*100.0/Total_VBN),2)||'%' as Delivery_Only
,round((Swap_Only*100.0/Total_VBN),2)||'%' as Swap_Only
,round((Ride_and_Swap*100.0/Total_VBN),2)||'%' as Ride_and_Swap_Only
,round((Ride_and_Delivery*100.0/Total_VBN),2)||'%' as Ride_and_Delivery
,round((Delivery_and_Swap*100.0/Total_VBN),2)||'%' as Ride_and_Swap
,round((Ride_Delivery_Swap*100.0/Total_VBN),2)||'%' as R_D_S
from
(
SELECT extract(month from onboarding_date) Months
		, count(DISTINCT vbn) Total_VBN
		, count(DISTINCT CASE WHEN first_delivery_date is null and first_swap_date is null and
						onboarding_biz='RIDE ONBOARDING' THEN vbn END) AS Ride_Only
		, count(DISTINCT CASE WHEN first_ride is null and first_swap_date is null and
						onboarding_biz='DELIVERY ONBOARDING' THEN vbn END) AS Delivery_Only
		, count(DISTINCT CASE WHEN first_delivery_date is null and first_ride is null and 
						onboarding_biz='SWAP ONBOARDING' THEN vbn END) AS Swap_Only,
						count(DISTINCT CASE WHEN first_delivery_date is null and first_ride is not null and first_swap_date is not null THEN vbn END) AS Ride_and_Swap,
						count(DISTINCT CASE WHEN first_ride is null and first_delivery_date is not null and first_swap_date is not null THEN vbn END) AS Delivery_and_Swap,
						count(DISTINCT CASE WHEN first_swap_date is null and first_delivery_date is not null and first_ride is not null then vbn end) AS Ride_and_Delivery,
						count(DISTINCT case when first_ride is not null and first_delivery_date is not null and first_swap_date is not null then vbn end) AS Ride_Delivery_Swap
						
					FROM tmp_operations.vehicle_consolidated
	WHERE onboarding_date >= '2021-4-01'
	GROUP BY 1
	ORDER BY extract(month from onboarding_date)
) as a
