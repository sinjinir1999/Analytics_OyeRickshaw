
	
	
SELECT extract(week from onboarding_date) as weeks, count(DISTINCT vbn) New_VBN,Ride_Onboardings Ride_First_Trx
,Delivery_Onboardings Del_First_Trx
,Swap_Onboardings Swap_First_Trx
	FROM tmp_operations.vehicle_consolidated
	JOIN (
		SELECT extract(week from first_ride) as first_ride_week
			, count(DISTINCT vbn) Ride_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_ride >= current_date-28
		GROUP BY 1
		) AS ride
		ON  extract(week from onboarding_date)= first_ride_week
	JOIN (
		SELECT extract(week from first_delivery_date) as first_delivery_week
			, count(DISTINCT vbn) Delivery_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_delivery_date >= current_date-28
		GROUP BY 1
		) AS del
		ON extract(week from onboarding_date)= first_delivery_week
	JOIN (
		SELECT extract(week from first_swap_date) as first_swap_week
			, count(DISTINCT vbn) Swap_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_swap_date >= current_date-28
		GROUP BY 1
		) AS swap
		ON extract(week from onboarding_date)= first_swap_week
	WHERE onboarding_date >= current_date-28
	GROUP BY 1,3,4,5
	order by 1
