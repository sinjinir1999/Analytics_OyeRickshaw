SELECT *
FROM (
	SELECT ve.onboarding_date
		,count(DISTINCT vbn) AS vbn_generated
		,nullif(d2d_vbn, 0)
		,nullif(o2d_vbn, 0)
		,nullif(oye_dost_vbn, 0)
		,nullif(agency_vbn, 0)
		,nullif(online_or_offline_marketing, 0)
		,nullif(walkins, 0)
	FROM tmp_operations.vehicle_consolidated ve
	LEFT JOIN (
		SELECT v.onboarding_date
			,count(DISTINCT CASE 
					WHEN referral_vbn IS NOT NULL
						THEN referral_mobile
					END) o2d_vbn
		FROM tmp_operations.merchant_partners mp
		LEFT JOIN tmp_operations.referrals_lead_data r ON r.referree_mobile = mp.mobile
		LEFT JOIN tmp_operations.vehicle_consolidated v ON r.referral_mobile = v.driver_mobile
		WHERE v.onboarding_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS o2d ON o2d.onboarding_date = ve.onboarding_date
	LEFT JOIN (
		SELECT v.onboarding_date
			,count(DISTINCT CASE 
					WHEN referral_vbn IS NOT NULL
						THEN referral_mobile
					END) oye_dost_vbn
		FROM tmp_operations.oye_dost mp
		LEFT JOIN tmp_operations.referrals_lead_data r ON r.referree_mobile = mp.mobile_number
		LEFT JOIN tmp_operations.vehicle_consolidated v ON r.referral_mobile = v.driver_mobile
		WHERE v.onboarding_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS oye ON oye.onboarding_date = ve.onboarding_date
	LEFT JOIN (
		SELECT v.onboarding_date
			,count(DISTINCT CASE 
					WHEN referree_vbn IS NOT NULL
						THEN referral_vbn
					END) d2d_vbn
		FROM tmp_operations.referrals_lead_data r
		LEFT JOIN tmp_operations.vehicle_consolidated v ON r.referral_mobile = v.driver_mobile
		WHERE v.onboarding_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS d2d ON d2d.onboarding_date = ve.onboarding_date
	LEFT JOIN (
		SELECT v.onboarding_date
			,count(DISTINCT CASE 
					WHEN lead_number IS NOT NULL
						THEN vbn
					END) AS agency_vbn
		FROM tmp_operations.vehicle_consolidated AS v
		LEFT JOIN tmp_operations.agency AS a ON v.driver_mobile = a.lead_number
		WHERE v.onboarding_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS agency ON ve.onboarding_date = agency.onboarding_date
	LEFT JOIN (
		SELECT vehicle_consolidated.onboarding_date
			,count(DISTINCT CASE 
					WHEN lead_source IN (
							'Driver App installation'
							,'Operator app'
							,'App Installation'
							)
						THEN vehicle_consolidated.vbn
					END) AS online_or_offline_marketing
			,count(DISTINCT CASE 
					WHEN lead_source = 'Field sourcing'
						THEN vehicle_consolidated.vbn
					END) AS walkins
		FROM tmp_operations.vehicle_consolidated
		LEFT JOIN tmp_operations.zoho_crm_data ON zoho_crm_data.driver_phone_number = vehicle_consolidated.driver_mobile
		WHERE vehicle_consolidated.onboarding_date BETWEEN CURRENT_DATE - 6
				AND CURRENT_DATE
		GROUP BY 1
		) AS others ON ve.onboarding_date = others.onboarding_date
	WHERE ve.onboarding_date BETWEEN CURRENT_DATE - 6
			AND CURRENT_DATE
	GROUP BY 1
		,3
		,4
		,5
		,6
		,7
		,8
	ORDER BY 1 DESC
	) AS a
