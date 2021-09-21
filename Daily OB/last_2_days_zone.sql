--daily dashboard last 2 days

SELECT onboarding_date,v.zone_new, count(DISTINCT vbn) New_VBN,(case when Ride_Onboardings is null then 0 else Ride_Onboardings end) Ride_First_Trx
,(case when Delivery_Onboardings is null then 0 else Delivery_Onboardings end) Del_First_Trx
,(case when Swap_Onboardings is null then 0 else Swap_Onboardings end)Swap_First_Trx
		
	FROM tmp_operations.vehicle_consolidated v
	left JOIN (
		SELECT first_ride,zone_new
			, count(DISTINCT vbn) Ride_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_ride BETWEEN CURRENT_DATE - 2
				AND CURRENT_DATE
		GROUP BY 1,2
		) AS ride
		ON v.onboarding_date = ride.first_ride and v.zone_new=ride.zone_new
	left JOIN (
		SELECT first_delivery_date,zone_new
			, count(DISTINCT vbn) Delivery_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_delivery_date BETWEEN CURRENT_DATE - 2
				AND CURRENT_DATE
		GROUP BY 1,2
		) AS del
		ON v.onboarding_date = del.first_delivery_date and v.zone_new=del.zone_new
	left JOIN (
		SELECT first_swap_date,zone_new
			, count(DISTINCT vbn) Swap_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_swap_date BETWEEN CURRENT_DATE - 2
				AND CURRENT_DATE
		GROUP BY 1,2
		) AS swap
		ON v.onboarding_date = swap.first_swap_date and v.zone_new=swap.zone_new
	WHERE onboarding_date BETWEEN CURRENT_DATE - 2
			AND CURRENT_DATE and v.zone_new<>''
	GROUP BY 1,2,4,5,6
	order by 1 desc,2
