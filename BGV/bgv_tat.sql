SELECT onboarding_biz
	,avg(DATE (ca_verified_on) - DATE (ca_requested_on)) * 1.0 AS tat_current_address
	,avg(DATE (ac_verified_on) - DATE (ac_requested_on)) * 1.0 AS tat_aadhar
--	,avg(DATE (pan_verified_on) - DATE (pan_requested_on)) * 1.0 AS tat_pan
--	,avg(DATE (dl_verified_on) - DATE (dl_requested_on)) * 1.0 AS tat_dl
--	,avg(DATE (cr_verified_on) - DATE (cr_requested_on)) * 1.0 AS tat_cr
FROM tmp_operations.bgv_data b
LEFT JOIN tmp_operations.vehicle_consolidated v ON b.vbn = v.vbn
WHERE onboarding_biz <> ''
	AND onboarding_biz <> 'ONBOARDING CHURN'
GROUP BY 1
