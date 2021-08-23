SELECT CASE 
WHEN months = 6 THEN 'June' 
WHEN months = 7 THEN 'July'
WHEN months = 5 THEN 'May'
WHEN months = 4 THEN 'April'
WHEN months = 8 THEN 'August' END AS Months
        ,vbn
		, (ROUND((o2d_vbn * 100.0 / vbn), 2) || '%') AS o2d_contribution
		, (ROUND((d2d_vbn * 100.0 / vbn), 2) || '%') AS d2d_contribution
		, (ROUND((oye_dost_vbn * 100.0 / NULLIF(vbn,0)), 2) || '%') AS oye_dost_contribution
		, (ROUND((agency_vbn * 100.0 / NULLIF(vbn,0)), 2) || '%') AS agency_contribution
		, (ROUND((field_sourcing * 100.0 / NULLIF(vbn,0)), 2) || '%') AS field_sourcing_or_walkins
		, (ROUND((walkins * 100.0 / NULLIF(vbn,0)), 2) || '%') AS offline_or_online_marketing
from
(
select extract(month from onboarding_date) months
,count(DISTINCT vehicle_consolidated.vbn) total_vbn
			, count(DISTINCT vehicle_consolidated.vbn) AS vbn
			, count(DISTINCT CASE WHEN lead_source = 'CBOB' THEN last_name END) AS o2d_leads
			, count(DISTINCT CASE WHEN lead_source = 'Driver Referral' THEN last_name END) AS d2d_leads
			, count(DISTINCT CASE WHEN lead_source = 'Oye Dost' THEN last_name END) AS oye_dost_leads
			, count(DISTINCT CASE WHEN lead_source = 'Agency' THEN last_name END) AS agency_leads
			, count(DISTINCT CASE WHEN lead_source = 'CBOB' THEN vehicle_consolidated.vbn END) AS o2d_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Driver Referral' THEN vehicle_consolidated.vbn END) AS d2d_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Oye Dost' THEN vehicle_consolidated.vbn END) AS oye_dost_vbn
			, count(DISTINCT CASE WHEN lead_source = 'Agency' THEN vehicle_consolidated.vbn END) AS agency_vbn
			, count(DISTINCT CASE WHEN lead_source in ('Driver App installation','Operator app') THEN vehicle_consolidated.vbn END) AS walkins
			, count(DISTINCT CASE WHEN lead_source is null THEN vehicle_consolidated.vbn END) AS field_sourcing
FROM tmp_operations.vehicle_consolidated
		LEFT JOIN tmp_operations.zoho_crm_data
			ON zoho_crm_data.driver_phone_number = vehicle_consolidated.driver_mobile
		WHERE onboarding_date >= '2021-04-01'
group by 1
order by 1
) as a
