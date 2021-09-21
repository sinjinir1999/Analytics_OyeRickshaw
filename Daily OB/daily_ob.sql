SELECT onboarding_date, count(DISTINCT vbn) New_VBN
,case when Ride_Onboardings is null then 0 else Ride_Onboardings end as Ride_First_Trx
,case when Delivery_Onboardings is null then 0 else Delivery_Onboardings end as  Del_First_Trx
,case when Swap_Onboardings is null then 0 else Swap_Onboardings end as Swap_First_Trx
		
	FROM tmp_operations.vehicle_consolidated
	LEFT JOIN (
		SELECT first_ride
			, count(DISTINCT vbn) Ride_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_ride BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS ride
		ON onboarding_date = ride.first_ride
	LEFT JOIN (
		SELECT first_delivery_date
			, count(DISTINCT vbn) Delivery_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_delivery_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS del
		ON onboarding_date = del.first_delivery_date
	LEFT JOIN (
		SELECT first_swap_date
			, count(DISTINCT vbn) Swap_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_swap_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS swap
		ON onboarding_date = swap.first_swap_date
	WHERE onboarding_date BETWEEN CURRENT_DATE - 6
			AND CURRENT_DATE
	GROUP BY 1,3,4,5
	order by 1 desc
