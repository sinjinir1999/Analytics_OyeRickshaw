SELECT extract(month from referral_date) as months,mp.zone_new,persona
	,count(DISTINCT mobile) Total_Partners
	,count(DISTINCT referral_mobile) Total_Referrals
	,count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Total_VBN
	,count(DISTINCT CASE WHEN v.first_ride IS NOT NULL OR v.first_delivery_date IS NOT NULL OR v.first_swap_date IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder_Overall
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
FROM tmp_operations.referrals_lead_data rl
LEFT JOIN tmp_operations.merchant_partners AS mp ON rl.referree_mobile = mp.mobile
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
WHERE mp.mobile IS NOT NULL
	AND mp.persona <> ''
	AND referral_date >='2021-04-01'
GROUP BY 1,2,3
ORDER BY 1,2,3
