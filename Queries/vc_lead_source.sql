SELECT v.vbn
	,CASE 
		WHEN mp.mobile IS NOT NULL
			THEN 'CBOB'
		WHEN o.mobile_number IS NOT NULL
			THEN 'Oye Dost'
		WHEN referree_vbn IS NOT NULL
			THEN 'Driver Referral'
		WHEN a.lead_number IS NOT NULL
			THEN 'Agency'
		WHEN z.lead_source = 'Field sourcing'
			THEN 'Walkins'
		WHEN z.lead_source IN (
				'App Installation'
				,'Operator app'
				,'Driver App installation'
				)
			THEN 'Online_Offline_marketing'
		ELSE 'Centrally Onboarded'
		END AS lead_source
	,city
	,v.zone
	,v.hub
	,driver_mobile
	,owner_mobile
	,v.onboarding_date
	,first_ride
	,last_ride
	,lifetime_rides
	,first_delivery_date
	,last_delivery_date
	,total_delivery_days
	,delivery_driver_status
	,first_swap_date
	,last_swap_date
	,total_swaps
	,onboarding_biz
	,v.zone_new
FROM tmp_operations.vehicle_consolidated v
LEFT JOIN tmp_operations.referrals_lead_data rl ON v.vbn = rl.referral_vbn
LEFT JOIN tmp_operations.merchant_partners mp ON rl.referree_mobile = mp.mobile
LEFT JOIN tmp_operations.oye_dost o ON rl.referree_mobile = o.mobile_number
LEFT JOIN tmp_operations.agency a ON v.driver_mobile = a.lead_number
LEFT JOIN tmp_operations.zoho_crm_data z ON v.driver_mobile = z.driver_phone_number
