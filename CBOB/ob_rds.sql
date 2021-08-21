SELECT DISTINCT mp.zone_new
	,count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Overall_Onboarding
	,count(DISTINCT CASE 
			WHEN onboarding_biz = 'RIDE ONBOARDING'
				AND referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Ride_Onboarding
	,count(DISTINCT CASE 
			WHEN onboarding_biz = 'DELIVERY ONBOARDING'
				AND referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Delivery_Onboarding
	,count(DISTINCT CASE 
			WHEN onboarding_biz = 'SWAP ONBOARDING'
				AND referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Swap_Onboarding
FROM tmp_operations.referrals_lead_data rl
LEFT JOIN tmp_operations.merchant_partners AS mp ON rl.referree_mobile = mp.mobile
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
WHERE mp.zone_new IS NOT NULL
	AND mp.mobile IS NOT NULL
	AND mp.zone_new <> ''
	AND referral_date between '2021-07-26' and '2021-08-25'
GROUP BY 1
ORDER BY 1
