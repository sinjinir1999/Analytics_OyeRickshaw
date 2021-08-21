SELECT DISTINCT a.zone_new
	,Total_VBN
	,(ROUND((First_Ladder * 100.0 / Total_VBN), 2) || '%') AS First_Ladder_Percentage
	,(ROUND((Second_Ladder * 100.0 / Total_VBN), 2) || '%') AS Second_Ladder_Percentage
	,(ROUND((Third_Ladder * 100.0 / Total_VBN), 2) || '%') AS Third_Ladder_Percentage from 
	(SELECT DISTINCT v.zone_new
	,count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Total_VBN
	,count(DISTINCT CASE 
			WHEN  v.first_ride IS NOT NULL
				OR v.first_delivery_date IS NOT NULL
				OR v.first_swap_date IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder
	,count(DISTINCT CASE 
			WHEN lifetime_rides >= 10
				OR total_delivery_days >= 10
				OR total_swaps >= 10
				AND (
					(tenth_delivery_date - v.first_delivery_date) <= 30
					OR (tenth_swap_date - v.first_swap_date) <= 30
					OR (ten_ride_date - v.first_ride) <= 30
					)
				THEN v.vbn
			END) AS Second_Ladder
	,count(DISTINCT CASE 
			WHEN lifetime_rides >= 100
				OR total_delivery_days >= 20
				OR total_swaps >= 20
				AND (
					(twenty_delivery_date - v.first_delivery_date) <= 30
					OR (twenty_swap_date - v.first_swap_date) <= 30
					OR (hundred_ride_date - v.first_ride) <= 30
					)
				THEN v.vbn
			END) AS Third_Ladder
FROM tmp_operations.referrals_lead_data rl
LEFT JOIN tmp_operations.merchant_partners AS mp ON rl.referree_mobile = mp.mobile
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
LEFT JOIN tmp_operations.ride_date_bifurcation AS rd ON rl.referral_vbn = rd.vbn
LEFT JOIN tmp_operations.delivery_date_bifurcation AS dd ON rl.referral_vbn = dd.vbn
LEFT JOIN tmp_operations.swap_date_bifurcation AS sd ON rl.referral_vbn = sd.vbn
WHERE v.zone_new IS NOT NULL and  mp.mobile is not null
	AND v.zone_new <> '' and referral_date between '2021-07-26' and '2021-08-25'
GROUP BY 1
ORDER BY 1) a
