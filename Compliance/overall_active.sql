SELECT DATE (r.created_at) AS dates
	,v.oye_number AS vbn
	,rc_status
	,vehicle_insurance_status
	,KYC_Status
	,Driving_License_Status
FROM oye_prod.ride r
LEFT JOIN oye_prod.vehicle v ON r.vehicle_id = v.id
LEFT JOIN (
	SELECT generation_date
		,a.rc
		,a.rc_status
		,a.oye_number
		,a.driver_mobile
		,a.vehicle_insurance_status
		,a.KYC_Status
		,a.Driving_License_Status
	FROM (
		SELECT DATE (v.created_at) AS generation_date
			,v.rc
			,CASE 
				WHEN ud.STATE = 1
					THEN 'RC Initiated'
				WHEN ud.STATE = 2
					THEN 'Skipped'
				WHEN ud.STATE = 3
					THEN 'RC pending for approval'
				WHEN ud.STATE = 4
					THEN 'RC Approved'
				WHEN ud.STATE IN (
						5
						,6
						)
					THEN 'RC Rejected'
				ELSE 'RC Not Initiated'
				END AS rc_status
			,v.oye_number
			,r.name
			,o.mobile AS owner_mobile
			,d.mobile AS driver_mobile
			,(d.first_name || ' ' || d.last_name) Drivers_Name
			,CASE 
				WHEN ud3.STATE = 1
					THEN 'Vehicle Insurance Initiated'
				WHEN ud3.STATE = 2
					THEN 'Vehicle Insurance Skipped'
				WHEN ud3.STATE = 3
					THEN 'Vehicle Insurance pending for approval'
				WHEN ud3.STATE = 4
					THEN 'Vehicle Insurance Approved'
				WHEN ud3.STATE IN (
						5
						,6
						)
					THEN 'Vehicle Insurance Rejected'
				ELSE 'Vehicle Insurance Not Initiated'
				END AS vehicle_insurance_status
			,CASE 
				WHEN ud4.STATE = 1
					THEN 'License Initiated'
				WHEN ud4.STATE = 2
					THEN 'Skipped'
				WHEN ud4.STATE = 3
					THEN 'License pending for approval'
				WHEN ud4.STATE = 4
					THEN 'License Approved'
				WHEN ud4.STATE IN (
						5
						,6
						)
					THEN 'License Rejected'
				ELSE 'License Not Initiated'
				END AS Driving_License_Status
			,CASE 
				WHEN ud5.STATE = 1
					THEN 'KYC Initiated'
				WHEN ud5.STATE = 2
					THEN 'Skipped'
				WHEN ud5.STATE = 3
					THEN 'KYC pending for approval'
				WHEN ud5.STATE = 4
					THEN 'KYC Approved'
				WHEN ud5.STATE IN (
						5
						,6
						)
					THEN 'KYC Rejected'
				ELSE 'KYC Not Initiated'
				END AS KYC_Status
		FROM oye_prod.vehicle AS v
		LEFT JOIN oye_prod.user_document AS ud ON ud.user_id = v.id
			AND ud.user_type = 'VEHICLE'
			AND ud.document_type = 'RC'
		LEFT JOIN oye_prod.user_document AS ud3 ON ud3.user_id = v.id
			AND ud3.user_type = 'VEHICLE'
			AND ud3.document_type = 'VEHICLE_INSURANCE'
		LEFT JOIN oye_prod.OWNER AS o ON v.owner_id = o.id
		LEFT JOIN oye_prod.driver AS d ON d.vehicle_id = v.id
			AND d.STATE != 5
		LEFT JOIN oye_prod.user_document AS ud5 ON ud5.user_id = d.id
			AND ud5.user_type = 'DRIVER'
			AND ud5.document_type = 'AADHAAR'
		LEFT JOIN oye_prod.user_document AS ud4 ON ud4.user_id = d.id
			AND ud4.user_type = 'DRIVER'
			AND ud4.document_type = 'LICENSE'
		LEFT JOIN oye_prod.region AS r ON v.region_id = r.id
		WHERE v.STATE != 3
		) AS a
	LEFT JOIN (
		SELECT v.oye_number AS vbn
			,min(DATE (dh.created_at)) AS onboarding_date
		FROM oye_prod.vehicle AS v
		INNER JOIN oye_prod.driver_history AS dh ON dh.vehicle_id = v.id
		WHERE dh.vehicle_id IS NOT NULL
		GROUP BY 1
		) AS b ON a.oye_number = b.vbn
	) AS ride ON ride.oye_number = v.oye_number
WHERE r.STATE = 2
	AND DATE (r.created_at) >= '2021-04-01'

UNION

SELECT DATE (DATE) AS dates
	,vbn
	,rc_status
	,vehicle_insurance_status
	,KYC_Status
	,Driving_License_Status
FROM tmp_operations.del_drivers d
LEFT JOIN (
	SELECT generation_date
		,a.rc
		,a.rc_status
		,a.oye_number
		,a.driver_mobile
		,a.vehicle_insurance_status
		,a.KYC_Status
		,a.Driving_License_Status
	FROM (
		SELECT DATE (v.created_at) AS generation_date
			,v.rc
			,CASE 
				WHEN ud.STATE = 1
					THEN 'RC Initiated'
				WHEN ud.STATE = 2
					THEN 'Skipped'
				WHEN ud.STATE = 3
					THEN 'RC pending for approval'
				WHEN ud.STATE = 4
					THEN 'RC Approved'
				WHEN ud.STATE IN (
						5
						,6
						)
					THEN 'RC Rejected'
				ELSE 'RC Not Initiated'
				END AS rc_status
			,v.oye_number
			,r.name
			,o.mobile AS owner_mobile
			,d.mobile AS driver_mobile
			,(d.first_name || ' ' || d.last_name) Drivers_Name
			,CASE 
				WHEN ud3.STATE = 1
					THEN 'Vehicle Insurance Initiated'
				WHEN ud3.STATE = 2
					THEN 'Vehicle Insurance Skipped'
				WHEN ud3.STATE = 3
					THEN 'Vehicle Insurance pending for approval'
				WHEN ud3.STATE = 4
					THEN 'Vehicle Insurance Approved'
				WHEN ud3.STATE IN (
						5
						,6
						)
					THEN 'Vehicle Insurance Rejected'
				ELSE 'Vehicle Insurance Not Initiated'
				END AS vehicle_insurance_status
			,CASE 
				WHEN ud4.STATE = 1
					THEN 'License Initiated'
				WHEN ud4.STATE = 2
					THEN 'Skipped'
				WHEN ud4.STATE = 3
					THEN 'License pending for approval'
				WHEN ud4.STATE = 4
					THEN 'License Approved'
				WHEN ud4.STATE IN (
						5
						,6
						)
					THEN 'License Rejected'
				ELSE 'License Not Initiated'
				END AS Driving_License_Status
			,CASE 
				WHEN ud5.STATE = 1
					THEN 'KYC Initiated'
				WHEN ud5.STATE = 2
					THEN 'Skipped'
				WHEN ud5.STATE = 3
					THEN 'KYC pending for approval'
				WHEN ud5.STATE = 4
					THEN 'KYC Approved'
				WHEN ud5.STATE IN (
						5
						,6
						)
					THEN 'KYC Rejected'
				ELSE 'KYC Not Initiated'
				END AS KYC_Status
		FROM oye_prod.vehicle AS v
		LEFT JOIN oye_prod.user_document AS ud ON ud.user_id = v.id
			AND ud.user_type = 'VEHICLE'
			AND ud.document_type = 'RC'
		LEFT JOIN oye_prod.user_document AS ud3 ON ud3.user_id = v.id
			AND ud3.user_type = 'VEHICLE'
			AND ud3.document_type = 'VEHICLE_INSURANCE'
		LEFT JOIN oye_prod.OWNER AS o ON v.owner_id = o.id
		LEFT JOIN oye_prod.driver AS d ON d.vehicle_id = v.id
			AND d.STATE != 5
		LEFT JOIN oye_prod.user_document AS ud5 ON ud5.user_id = d.id
			AND ud5.user_type = 'DRIVER'
			AND ud5.document_type = 'AADHAAR'
		LEFT JOIN oye_prod.user_document AS ud4 ON ud4.user_id = d.id
			AND ud4.user_type = 'DRIVER'
			AND ud4.document_type = 'LICENSE'
		LEFT JOIN oye_prod.region AS r ON v.region_id = r.id
		WHERE v.STATE != 3
		) AS a
	LEFT JOIN (
		SELECT v.oye_number AS vbn
			,min(DATE (dh.created_at)) AS onboarding_date
		FROM oye_prod.vehicle AS v
		INNER JOIN oye_prod.driver_history AS dh ON dh.vehicle_id = v.id
		WHERE dh.vehicle_id IS NOT NULL
		GROUP BY 1
		) AS b ON a.oye_number = b.vbn
	) c ON c.oye_number = d.vbn
WHERE DATE (DATE) >= '2021-04-01'

UNION

SELECT DATE (onboarding_date)
	,vbn
	,rc_status
	,vehicle_insurance_status
	,KYC_Status
	,Driving_License_Status
FROM tmp_operations.vehicle_consolidated v
LEFT JOIN (
	SELECT generation_date
		,a.rc
		,a.rc_status
		,a.oye_number
		,a.driver_mobile
		,a.vehicle_insurance_status
		,a.KYC_Status
		,a.Driving_License_Status
	FROM (
		SELECT DATE (v.created_at) AS generation_date
			,v.rc
			,CASE 
				WHEN ud.STATE = 1
					THEN 'RC Initiated'
				WHEN ud.STATE = 2
					THEN 'Skipped'
				WHEN ud.STATE = 3
					THEN 'RC pending for approval'
				WHEN ud.STATE = 4
					THEN 'RC Approved'
				WHEN ud.STATE IN (
						5
						,6
						)
					THEN 'RC Rejected'
				ELSE 'RC Not Initiated'
				END AS rc_status
			,v.oye_number
			,r.name
			,o.mobile AS owner_mobile
			,d.mobile AS driver_mobile
			,(d.first_name || ' ' || d.last_name) Drivers_Name
			,CASE 
				WHEN ud3.STATE = 1
					THEN 'Vehicle Insurance Initiated'
				WHEN ud3.STATE = 2
					THEN 'Vehicle Insurance Skipped'
				WHEN ud3.STATE = 3
					THEN 'Vehicle Insurance pending for approval'
				WHEN ud3.STATE = 4
					THEN 'Vehicle Insurance Approved'
				WHEN ud3.STATE IN (
						5
						,6
						)
					THEN 'Vehicle Insurance Rejected'
				ELSE 'Vehicle Insurance Not Initiated'
				END AS vehicle_insurance_status
			,CASE 
				WHEN ud4.STATE = 1
					THEN 'License Initiated'
				WHEN ud4.STATE = 2
					THEN 'Skipped'
				WHEN ud4.STATE = 3
					THEN 'License pending for approval'
				WHEN ud4.STATE = 4
					THEN 'License Approved'
				WHEN ud4.STATE IN (
						5
						,6
						)
					THEN 'License Rejected'
				ELSE 'License Not Initiated'
				END AS Driving_License_Status
			,CASE 
				WHEN ud5.STATE = 1
					THEN 'KYC Initiated'
				WHEN ud5.STATE = 2
					THEN 'Skipped'
				WHEN ud5.STATE = 3
					THEN 'KYC pending for approval'
				WHEN ud5.STATE = 4
					THEN 'KYC Approved'
				WHEN ud5.STATE IN (
						5
						,6
						)
					THEN 'KYC Rejected'
				ELSE 'KYC Not Initiated'
				END AS KYC_Status
		FROM oye_prod.vehicle AS v
		LEFT JOIN oye_prod.user_document AS ud ON ud.user_id = v.id
			AND ud.user_type = 'VEHICLE'
			AND ud.document_type = 'RC'
		LEFT JOIN oye_prod.user_document AS ud3 ON ud3.user_id = v.id
			AND ud3.user_type = 'VEHICLE'
			AND ud3.document_type = 'VEHICLE_INSURANCE'
		LEFT JOIN oye_prod.OWNER AS o ON v.owner_id = o.id
		LEFT JOIN oye_prod.driver AS d ON d.vehicle_id = v.id
			AND d.STATE != 5
		LEFT JOIN oye_prod.user_document AS ud5 ON ud5.user_id = d.id
			AND ud5.user_type = 'DRIVER'
			AND ud5.document_type = 'AADHAAR'
		LEFT JOIN oye_prod.user_document AS ud4 ON ud4.user_id = d.id
			AND ud4.user_type = 'DRIVER'
			AND ud4.document_type = 'LICENSE'
		LEFT JOIN oye_prod.region AS r ON v.region_id = r.id
		WHERE v.STATE != 3
		) AS a
	LEFT JOIN (
		SELECT v.oye_number AS vbn
			,min(DATE (dh.created_at)) AS onboarding_date
		FROM oye_prod.vehicle AS v
		INNER JOIN oye_prod.driver_history AS dh ON dh.vehicle_id = v.id
		WHERE dh.vehicle_id IS NOT NULL
		GROUP BY 1
		) AS b ON a.oye_number = b.vbn
	) AS d ON d.oye_number = v.vbn
WHERE onboarding_biz = 'ONBOARDING CHURN'
	AND DATE (onboarding_date) >= '2021-04-01'

UNION

SELECT DATE (DATE) AS dates
	,vbn
	,rc_status
	,vehicle_insurance_status
	,KYC_Status
	,Driving_License_Status
FROM tmp_operations.swapping_off s
LEFT JOIN (
	SELECT generation_date
		,a.rc
		,a.rc_status
		,a.oye_number
		,a.driver_mobile
		,a.vehicle_insurance_status
		,a.KYC_Status
		,a.Driving_License_Status
	FROM (
		SELECT DATE (v.created_at) AS generation_date
			,v.rc
			,CASE 
				WHEN ud.STATE = 1
					THEN 'RC Initiated'
				WHEN ud.STATE = 2
					THEN 'Skipped'
				WHEN ud.STATE = 3
					THEN 'RC pending for approval'
				WHEN ud.STATE = 4
					THEN 'RC Approved'
				WHEN ud.STATE IN (
						5
						,6
						)
					THEN 'RC Rejected'
				ELSE 'RC Not Initiated'
				END AS rc_status
			,v.oye_number
			,r.name
			,o.mobile AS owner_mobile
			,d.mobile AS driver_mobile
			,(d.first_name || ' ' || d.last_name) Drivers_Name
			,CASE 
				WHEN ud3.STATE = 1
					THEN 'Vehicle Insurance Initiated'
				WHEN ud3.STATE = 2
					THEN 'Vehicle Insurance Skipped'
				WHEN ud3.STATE = 3
					THEN 'Vehicle Insurance pending for approval'
				WHEN ud3.STATE = 4
					THEN 'Vehicle Insurance Approved'
				WHEN ud3.STATE IN (
						5
						,6
						)
					THEN 'Vehicle Insurance Rejected'
				ELSE 'Vehicle Insurance Not Initiated'
				END AS vehicle_insurance_status
			,CASE 
				WHEN ud4.STATE = 1
					THEN 'License Initiated'
				WHEN ud4.STATE = 2
					THEN 'Skipped'
				WHEN ud4.STATE = 3
					THEN 'License pending for approval'
				WHEN ud4.STATE = 4
					THEN 'License Approved'
				WHEN ud4.STATE IN (
						5
						,6
						)
					THEN 'License Rejected'
				ELSE 'License Not Initiated'
				END AS Driving_License_Status
			,CASE 
				WHEN ud5.STATE = 1
					THEN 'KYC Initiated'
				WHEN ud5.STATE = 2
					THEN 'Skipped'
				WHEN ud5.STATE = 3
					THEN 'KYC pending for approval'
				WHEN ud5.STATE = 4
					THEN 'KYC Approved'
				WHEN ud5.STATE IN (
						5
						,6
						)
					THEN 'KYC Rejected'
				ELSE 'KYC Not Initiated'
				END AS KYC_Status
		FROM oye_prod.vehicle AS v
		LEFT JOIN oye_prod.user_document AS ud ON ud.user_id = v.id
			AND ud.user_type = 'VEHICLE'
			AND ud.document_type = 'RC'
		LEFT JOIN oye_prod.user_document AS ud3 ON ud3.user_id = v.id
			AND ud3.user_type = 'VEHICLE'
			AND ud3.document_type = 'VEHICLE_INSURANCE'
		LEFT JOIN oye_prod.OWNER AS o ON v.owner_id = o.id
		LEFT JOIN oye_prod.driver AS d ON d.vehicle_id = v.id
			AND d.STATE != 5
		LEFT JOIN oye_prod.user_document AS ud5 ON ud5.user_id = d.id
			AND ud5.user_type = 'DRIVER'
			AND ud5.document_type = 'AADHAAR'
		LEFT JOIN oye_prod.user_document AS ud4 ON ud4.user_id = d.id
			AND ud4.user_type = 'DRIVER'
			AND ud4.document_type = 'LICENSE'
		LEFT JOIN oye_prod.region AS r ON v.region_id = r.id
		WHERE v.STATE != 3
		) AS a
	LEFT JOIN (
		SELECT v.oye_number AS vbn
			,min(DATE (dh.created_at)) AS onboarding_date
		FROM oye_prod.vehicle AS v
		INNER JOIN oye_prod.driver_history AS dh ON dh.vehicle_id = v.id
		WHERE dh.vehicle_id IS NOT NULL
		GROUP BY 1
		) AS b ON a.oye_number = b.vbn
	) AS d ON d.oye_number = s.vbn
WHERE DATE (DATE) >= '2021-04-01'
