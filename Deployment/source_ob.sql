	SElect vehicle_consolidated.onboarding_date,agency_vbn
			,count(DISTINCT CASE 
					WHEN lead_source IN (
							'Driver App installation'
							,'Operator app'
							)
						THEN vehicle_consolidated.vbn
					END) AS walkins
			,count(DISTINCT CASE 
					WHEN lead_source IS NULL
						THEN vehicle_consolidated.vbn
					END) AS field_sourcing,
					count(DISTINCT CASE 
					WHEN lead_source='Quickr'
						THEN vehicle_consolidated.vbn
					END) AS quickr
		FROM tmp_operations.vehicle_consolidated
		LEFT JOIN tmp_operations.zoho_crm_data ON zoho_crm_data.driver_phone_number = vehicle_consolidated.driver_mobile
	
	LEFT JOIN (
		SELECT vehicle_consolidated.onboarding_date
			,count(DISTINCT vbn) AS agency_vbn
		FROM tmp_operations.vehicle_consolidated
		LEFT JOIN tmp_operations.agency ON agency.lead_number = vehicle_consolidated.driver_mobile
		WHERE vehicle_consolidated.onboarding_date >= '2021-09-01'
			AND lead_number IS NOT NULL
		GROUP BY 1
		ORDER BY 1) a on  a.onboarding_date=vehicle_consolidated.onboarding_date
		
				WHERE vehicle_consolidated.onboarding_date >= '2021-09-01' 
		GROUP BY 1,2
		ORDER BY 1
