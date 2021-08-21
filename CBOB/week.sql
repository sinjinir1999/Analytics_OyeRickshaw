SELECT v.zone_new,extract(week from v.onboarding_date) as weeks,
count(distinct case when mp.mobile is not null then referral_mobile end) Total_Leads_cbob
	,count(distinct case when referral_vbn is not null then referral_mobile end) as Total_VBN
	,count(DISTINCT CASE 
			WHEN  v.first_ride IS NOT NULL
				OR v.first_delivery_date IS NOT NULL
				OR v.first_swap_date IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder
FROM tmp_operations.referrals_lead_data rl
LEFT JOIN tmp_operations.merchant_partners AS mp ON rl.referree_mobile = mp.mobile
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
left join tmp_operations.zoho_crm_data as z on rl.referral_mobile=z.driver_phone_number
LEFT JOIN tmp_operations.ride_date_bifurcation AS rd ON rl.referral_vbn = rd.vbn
LEFT JOIN tmp_operations.delivery_date_bifurcation AS dd ON rl.referral_vbn = dd.vbn
LEFT JOIN tmp_operations.swap_date_bifurcation AS sd ON rl.referral_vbn = sd.vbn
WHERE v.zone_new IS NOT NULL and  mp.mobile is not null
	AND v.zone_new <> '' and referral_date between current_date-31 and current_date and v.onboarding_date between current_date-31 and current_date
	group by 1,2
ORDER BY 1,2
