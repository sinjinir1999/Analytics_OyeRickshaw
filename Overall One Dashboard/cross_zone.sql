
SELECT v.zone_new, Cross_OB_ride,Cross_OB_delivery,Cross_OB_swap
	FROM tmp_operations.vehicle_consolidated v
	LEFT JOIN (
		SELECT zone_new
			, count(distinct case when onboarding_biz<>'RIDE ONBOARDING' and first_ride is not null then vbn end)
 AS Cross_OB_ride
		FROM tmp_operations.vehicle_consolidated
		WHERE first_ride between '2021-09-01' and current_date
		GROUP BY 1
		) AS ride
		ON  ride.zone_new=v.zone_new
	lEFT JOIN (
		SELECT zone_new
			,count(distinct case when onboarding_biz<>'DELIVERY ONBOARDING' and first_delivery_date is not null then vbn end) AS Cross_OB_delivery
		FROM tmp_operations.vehicle_consolidated
		WHERE first_delivery_date  between '2021-09-01' and current_date
		GROUP BY 1
		) AS del
		ON del.zone_new=v.zone_new
	lEFT JOIN (
				Select zone_new
			,count(distinct case when onboarding_biz<>'SWAP ONBOARDING' then vbn end) AS Cross_OB_swap
		FROM tmp_operations.vehicle_consolidated
		WHERE first_swap_date  between '2021-09-01' and current_date
		GROUP BY 1
		) AS swap
		ON swap.zone_new=v.zone_new
	GROUP BY 1,2,3,4
	order by 1
