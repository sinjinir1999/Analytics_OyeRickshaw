SELECT zones,
	Total_leads
	,Closed_Leads,Oye_Driver
	,VBN_Created AS Leads_Converted
	,(round(((VBN_Created * 100.0) / NULLIF(Closed_Leads, 0.00)), 2) || '%') AS Lead_Conversion_Percentage
FROM (
	SELECT zones
		,(Same_State + Closed_Leads) AS Total_Leads
		,Same_State
		,Closed_Leads
		,VBN_Created,Oye_Driver
	FROM (
		SELECT zone.name zones
			,count(DISTINCT CASE 
					WHEN lead_state = 'Lead Verified, Documentation in progress'
						THEN z.id
					END) AS Same_State
			,count(DISTINCT CASE 
					WHEN lead_state IN (
							'Active'
							,'Unlinked'
							,'Dropped'
							)
						AND dc_last_call_date BETWEEN '2021-08-26'
							AND '2021-09-25'
						THEN z.id
					END) Closed_Leads
			,count(DISTINCT CASE 
					WHEN lead_state IN (
							'Active'
							,'Unlinked'
							)
						AND dc_last_call_date BETWEEN '2021-08-26'
							AND '2021-09-25'
						THEN z.id
					END) VBN_Created,
					count(DISTINCT CASE WHEN (v.lifetime_rides>=50
						or  total_delivery_days>=10
						or total_swaps>=10) AND ((first_ride>='2021-07-26' and first_ride<='2021-08-25') or (first_delivery_date>='2021-07-26' and first_delivery_date<='2021-08-25') 
						or (first_swap_date>='2021-07-26' and first_swap_date<='2021-08-25'))
							THEN v.vbn
					END) Oye_Driver
		FROM tmp_operations.zoho_crm_data AS z
		LEFT JOIN tmp_operations.vehicle_consolidated as v ON v.driver_mobile = z.driver_phone_number
		LEFT JOIN analytics.zone ON zone.name = z.zone
		LEFT JOIN analytics.hub_mapping ON hub_mapping.zone_id = zone.id
		LEFT JOIN analytics.city ON city.id = hub_mapping.city_id
		WHERE zone.name <> ''
		GROUP BY 1
		ORDER BY 2 DESC
		) AS a
	) AS m
