SELECT extract(month from onboarding_date) months,count(DISTINCT vbn) AS vbn
		, count(DISTINCT CASE WHEN first_delivery_date IS NOT NULL
					OR first_ride IS NOT NULL
					OR first_swap_date IS NOT NULL THEN vbn END) AS first_txn
		, count(DISTINCT CASE WHEN lifetime_rides >= 40
					OR total_delivery_days >= 15
					OR total_swaps >= 10 THEN vbn END) AS oye_fleet
	FROM tmp_operations.vehicle_consolidated
	WHERE onboarding_date >= '2021-04-01'
	GROUP BY 1
	ORDER BY 1
