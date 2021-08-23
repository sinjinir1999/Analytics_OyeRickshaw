SELECT case when months = 6 then 'June'
when months = 7 then 'July' 
when months = 5 then 'May'
when months = 4 then 'April' 
when months = 8 then 'August' end as Months
		, total_leads
		, (round((o2d_leads * 100.0 / total_leads),2) || '%') AS o2d_leads
		, (round((d2d_leads * 100.0 / total_leads),2) || '%') AS d2d_leads
		, (round((oye_dost_leads * 100.0 / total_leads),2) || '%') AS oye_dost_leads
		, (round((agency_leads * 100.0 / total_leads),2) || '%') AS agency_leads
	FROM (
		SELECT extract(month FROM date_of_lead_generation) months
			, count(DISTINCT last_name) total_leads
			, count(DISTINCT vehicle_consolidated.vbn) AS vbn
			, count(DISTINCT CASE WHEN lead_source = 'CBOB' THEN last_name END) AS o2d_leads
			, count(DISTINCT CASE WHEN lead_source = 'Driver Referral' THEN last_name END) AS d2d_leads
			, count(DISTINCT CASE WHEN lead_source = 'Oye Dost' THEN last_name END) AS oye_dost_leads
			, count(DISTINCT CASE WHEN lead_source = 'Agency' THEN last_name END) AS agency_leads
			, count(DISTINCT CASE WHEN lead_source = 'CBOB' THEN vehicle_consolidated.vbn END) AS o2d_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Driver Referral' THEN vehicle_consolidated.vbn END) AS d2d_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Oye Dost' THEN vehicle_consolidated.vbn END) AS oye_dost_vbn
		FROM tmp_operations.zoho_crm_data
		LEFT JOIN tmp_operations.vehicle_consolidated
			ON zoho_crm_data.driver_phone_number = vehicle_consolidated.driver_mobile
		WHERE date_of_lead_generation >= '2021-04-01'
		GROUP BY 1
		ORDER BY 1
		) AS a
