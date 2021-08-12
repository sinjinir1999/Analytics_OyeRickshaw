select Month, total_drivers,(round((rc_count * 100.0 / total_drivers),2) || '%') AS rc_percentage,(round((vehicle_insurance * 100.0 / total_drivers),2) || '%') AS vehicle_insurance_percentage,
(round((Aadhar * 100.0 / total_drivers),2) || '%') AS aadhar_percentage,(round((dl * 100.0 / total_drivers),2) || '%') AS dl_percentage from

(select 4 as Month,count(distinct case when dates <= '2021-04-30' then total_drivers end) as total_drivers
,count(distinct case when dates <= '2021-04-30' then RC_count end) as RC_Count
,count(distinct case when dates <= '2021-04-30' then vehicle_insurance_status end) as vehicle_insurance
,count(distinct case when dates <= '2021-04-30' then Aadhar_count end) as Aadhar
,count(distinct case when dates <= '2021-04-30' then DL_count end) as DL
from
(
SELECT dates
	,vbn AS total_drivers
	,CASE
			WHEN rc_status = 'RC Approved'
				THEN vbn
			END AS RC_count
	,CASE
			WHEN vehicle_insurance_status = 'Vehicle Insurance Approved'
				THEN vbn
			END vehicle_insurance_status
	,CASE
			WHEN KYC_Status = 'KYC Approved'
				THEN vbn
			END AS Aadhar_count
	,CASE
			WHEN Driving_License_Status = 'License Approved'
				THEN vbn
			END AS DL_count
FROM tmp_operations.overall_active
ORDER BY 1
) as apr
union
select 5 as Month,count(distinct case when dates <= '2021-05-31' then total_drivers end) as total_drivers
,count(distinct case when dates <= '2021-05-31' then RC_count end) as RC_Count
,count(distinct case when dates <= '2021-05-31' then vehicle_insurance_status end) as vehicle_insurance
,count(distinct case when dates <= '2021-05-31' then Aadhar_count end) as Aadhar
,count(distinct case when dates <= '2021-05-31' then DL_count end) as DL
from
(
SELECT dates
	,vbn AS total_drivers
	,CASE
			WHEN rc_status = 'RC Approved'
				THEN vbn
			END AS RC_count
	,CASE
			WHEN vehicle_insurance_status = 'Vehicle Insurance Approved'
				THEN vbn
			END vehicle_insurance_status
	,CASE
			WHEN KYC_Status = 'KYC Approved'
				THEN vbn
			END AS Aadhar_count
	,CASE
			WHEN Driving_License_Status = 'License Approved'
				THEN vbn
			END AS DL_count
FROM tmp_operations.overall_active
ORDER BY 1
) as may
union
select 6 as Month,count(distinct case when dates <= '2021-06-30' then total_drivers end) as total_drivers
,count(distinct case when dates <= '2021-06-30' then RC_count end) as RC_Count
,count(distinct case when dates <= '2021-06-30' then vehicle_insurance_status end) as vehicle_insurance
,count(distinct case when dates <= '2021-06-30' then Aadhar_count end) as Aadhar
,count(distinct case when dates <= '2021-06-30' then DL_count end) as DL
from
(
SELECT dates
	,vbn AS total_drivers
	,CASE
			WHEN rc_status = 'RC Approved'
				THEN vbn
			END AS RC_count
	,CASE
			WHEN vehicle_insurance_status = 'Vehicle Insurance Approved'
				THEN vbn
			END vehicle_insurance_status
	,CASE
			WHEN KYC_Status = 'KYC Approved'
				THEN vbn
			END AS Aadhar_count
	,CASE
			WHEN Driving_License_Status = 'License Approved'
				THEN vbn
			END AS DL_count
FROM tmp_operations.overall_active
ORDER BY 1
) as june
union
select 7 as Month,count(distinct case when dates <= '2021-07-31' then total_drivers end) as total_drivers
,count(distinct case when dates <= '2021-07-31' then RC_count end) as RC_Count
,count(distinct case when dates <= '2021-07-31' then vehicle_insurance_status end) as vehicle_insurance
,count(distinct case when dates <= '2021-07-31' then Aadhar_count end) as Aadhar
,count(distinct case when dates <= '2021-07-31' then DL_count end) as DL
from
(
SELECT dates
	,vbn AS total_drivers
	,CASE
			WHEN rc_status = 'RC Approved'
				THEN vbn
			END AS RC_count
	,CASE
			WHEN vehicle_insurance_status = 'Vehicle Insurance Approved'
				THEN vbn
			END vehicle_insurance_status
	,CASE
			WHEN KYC_Status = 'KYC Approved'
				THEN vbn
			END AS Aadhar_count
	,CASE
			WHEN Driving_License_Status = 'License Approved'
				THEN vbn
			END AS DL_count
FROM tmp_operations.overall_active
ORDER BY 1
) as apr
union
select 8 as Month,count(distinct case when dates <= '2021-08-31' then total_drivers end) as total_drivers
,count(distinct case when dates <= '2021-08-31' then RC_count end) as RC_Count
,count(distinct case when dates <= '2021-08-31' then vehicle_insurance_status end) as vehicle_insurance
,count(distinct case when dates <= '2021-08-31' then Aadhar_count end) as Aadhar
,count(distinct case when dates <= '2021-08-31' then DL_count end) as DL
from
(
SELECT dates
	,vbn AS total_drivers
	,CASE
			WHEN rc_status = 'RC Approved'
				THEN vbn
			END AS RC_count
	,CASE
			WHEN vehicle_insurance_status = 'Vehicle Insurance Approved'
				THEN vbn
			END vehicle_insurance_status
	,CASE
			WHEN KYC_Status = 'KYC Approved'
				THEN vbn
			END AS Aadhar_count
	,CASE
			WHEN Driving_License_Status = 'License Approved'
				THEN vbn
			END AS DL_count
FROM tmp_operations.overall_active
ORDER BY 1
) as aug) as m
order by 1
