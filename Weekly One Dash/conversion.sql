SELECT weeks
		, (ROUND((vbn * 100.0 /NULLIF(total_leads,0)), 2) || '%') AS overall_conversion
		, (ROUND((o2d_vbn * 100.0 / NULLIF(o2d_leads,0)), 2) || '%') AS o2d_conversion
		, (ROUND((d2d_vbn * 100.0 / NULLIF(d2d_leads,0)), 2) || '%') AS d2d_conversion
		, (ROUND((oye_dost_vbn * 100.0 / NULLIF(oye_dost_leads,0)), 2) || '%') AS oye_dost_conversion
		, (ROUND((agency_vbn * 100.0 / NULLIF(agency_leads,0)), 2) || '%') AS agency_conversion
	FROM (
		SELECT extract(week FROM date_of_lead_generation) weeks
			, count(DISTINCT last_name) total_leads
			, count(DISTINCT vehicle_consolidated.vbn) AS vbn
			, count(DISTINCT CASE WHEN lead_source = 'CBOB' THEN last_name END) AS o2d_leads
			, count(DISTINCT CASE WHEN lead_source = 'Driver Referral' THEN last_name END) AS d2d_leads
			, count(DISTINCT CASE WHEN lead_source = 'Oye Dost' THEN last_name END) AS oye_dost_leads
			, count(DISTINCT CASE WHEN lead_source = 'Agency' THEN last_name END) AS agency_leads
			, count(DISTINCT CASE WHEN lead_source = 'CBOB' THEN vehicle_consolidated.vbn END) AS o2d_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Driver Referral' THEN vehicle_consolidated.vbn END) AS d2d_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Oye Dost' THEN vehicle_consolidated.vbn END) AS oye_dost_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Agency' THEN vehicle_consolidated.vbn END) AS agency_vbn
		FROM tmp_operations.zoho_crm_data
		LEFT JOIN tmp_operations.vehicle_consolidated
			ON zoho_crm_data.driver_phone_number = vehicle_consolidated.driver_mobile
		WHERE date_of_lead_generation between current_date-28 and current_date
		GROUP BY 1
		ORDER BY 1 desc
		) AS a
