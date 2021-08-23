
	
	
SELECT extract(month from onboarding_date) as months, count(DISTINCT vbn) New_VBN,Ride_Onboardings Ride_First_Trx
,Delivery_Onboardings Del_First_Trx
,Swap_Onboardings Swap_First_Trx
	FROM tmp_operations.vehicle_consolidated
	JOIN (
		SELECT extract(month from first_ride) as first_ride_month
			, count(DISTINCT vbn) Ride_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_ride >= '2021-04-01'
		GROUP BY 1
		) AS ride
		ON  extract(month from onboarding_date)= first_ride_month
	JOIN (
		SELECT extract(month from first_delivery_date) as first_delivery_month
			, count(DISTINCT vbn) Delivery_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_delivery_date >= '2021-04-01'
		GROUP BY 1
		) AS del
		ON extract(month from onboarding_date)= first_delivery_month
	JOIN (
		SELECT extract(month from first_swap_date) as first_swap_month
			, count(DISTINCT vbn) Swap_Onboardings
		FROM tmp_operations.vehicle_consolidated
		WHERE first_swap_date >='2021-04-01'
		GROUP BY 1
		) AS swap
		ON extract(month from onboarding_date)= first_swap_month
	WHERE onboarding_date >= '2021-04-01'
	GROUP BY 1,3,4,5
	order by 1
