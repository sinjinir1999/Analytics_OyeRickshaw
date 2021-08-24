SELECT DISTINCT o.zone
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
LEFT JOIN tmp_operations.oye_dost AS o ON rl.referree_mobile = o.mobile_number
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
WHERE o.zone IS NOT NULL
	AND o.mobile_number IS NOT NULL
	AND referral_date between '2021-07-26' and '2021-08-25'
GROUP BY 1
ORDER BY 1
