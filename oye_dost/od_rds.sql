SELECT DISTINCT o.zone
	,count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Total_VBN
	,count(DISTINCT CASE 
			WHEN v.first_ride IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder_Ride
	,count(DISTINCT CASE 
			WHEN v.first_delivery_date IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder_Delivery
	,count(DISTINCT CASE 
			WHEN v.first_swap_date IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder_Swap
	,count(DISTINCT CASE 
			WHEN lifetime_rides >= 40
				AND (forty_ride_date - v.first_ride) <= 15
				THEN v.vbn
			END) AS Second_Ladder_Ride
	,count(DISTINCT CASE 
			WHEN total_delivery_days >= 10
				AND (tenth_delivery_date - v.first_delivery_date) <= 15
				THEN v.vbn
			END) AS Second_Ladder_Delivery
	,count(DISTINCT CASE 
			WHEN total_swaps >= 10
				AND (tenth_swap_date - v.first_swap_date) <= 15
				THEN v.vbn
			END) AS Second_Ladder_Swap

FROM tmp_operations.referrals_lead_data rl
LEFT JOIN tmp_operations.oye_dost AS o ON rl.referree_mobile = o.mobile_number
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
LEFT JOIN tmp_operations.ride_date_bifurcation AS rd ON rl.referral_vbn = rd.vbn
LEFT JOIN tmp_operations.delivery_date_bifurcation AS dd ON rl.referral_vbn = dd.vbn
LEFT JOIN tmp_operations.swap_date_bifurcation AS sd ON rl.referral_vbn = sd.vbn
WHERE o.zone IS NOT NULL
	AND o.mobile_number IS NOT NULL
	AND referral_date between '2021-07-26' and '2021-08-25'
GROUP BY 1
ORDER BY 1
