Select Distinct referral_mobile,states,a.mobile as referree_mobile,Referred_date,vbn,a.onboarding_date,ranks,vbn_driver,
case when mp.mobile is not null then 'CBOB'
when od.mobile_number is not null then 'Oye Dost'
when vbn is not null then 'Driver Referral'
else 'Driver Referral'
end as lead_source
from
(
SELECT DISTINCT a.referral_mobile
	, CASE 
		WHEN a.Drstate = 2
			THEN 'Ride Count Processing'
		WHEN a.Drstate = 3
			THEN 'Ride Count Processed'
		WHEN a.Drstate = 4
			THEN 'Completed'
		WHEN a.Drstate = 5
			THEN 'Lead Generated'
		WHEN a.Drstate = 6
			THEN 'Lead Converted'
		WHEN a.Drstate = 10
			THEN 'Referral Expiry'
		WHEN a.Drstate = 1 AND a.D2state IN (
				2
				, 6
				)
			THEN 'App Downloaded'
		WHEN a.Drstate = 1 AND a.D2state IN (
				3
				, 5
				)
			THEN 'Deboarded'
		WHEN a.Drstate = 1 AND a.D2state = 4
			THEN 'Active'
		END AS states
	, a.mobile
	, a.Referred_date
	, b.oye_number vbn
	, b.dates onboarding_date
	, row_number() OVER (
		PARTITION BY a.mobile ORDER BY a.created_at ASC
		) AS ranks
	, vbn_driver
FROM (
	SELECT dr.referral_mobile
		, dr.STATE Drstate
		, d1.mobile
		, dr.created_at
		, DATE (dr.created_at) Referred_date
		, d2.STATE D2state
	FROM oye_prod.driver_referral AS dr
	INNER JOIN oye_prod.driver AS d1
		ON dr.referred_by_driver_id = d1.id
	LEFT JOIN oye_prod.driver AS d2
		ON dr.referral_driver_id = d2.id
	WHERE DATE (dr.created_at) >= '2020-04-25' AND dr.referral_mobile != ' '
	
	UNION
	
	SELECT d2.mobile
		, dr.STATE
		, d1.mobile
		, dr.created_at
		, DATE (dr.created_at)
		, d2.STATE
	FROM oye_prod.driver_referral AS dr
	INNER JOIN oye_prod.driver AS d1
		ON dr.referred_by_driver_id = d1.id
	INNER JOIN oye_prod.driver AS d2
		ON dr.referral_driver_id = d2.id
	WHERE DATE (dr.created_at) >= '2020-04-25' AND dr.referral_mobile = ''
	) a
LEFT JOIN (
	SELECT d.mobile
		, v.oye_number
		, min(DATE (dh.created_at)) AS dates
	FROM oye_prod.vehicle AS v
	INNER JOIN oye_prod.driver_history AS dh
		ON dh.vehicle_id = v.id
	JOIN oye_prod.driver d
		ON d.id = dh.driver_id
	INNER JOIN oye_prod.region r
		ON r.id = v.region_id
	WHERE dh.vehicle_id IS NOT NULL
	GROUP BY 1
		, 2
	) b
	ON b.mobile = a.mobile
LEFT JOIN (
	SELECT v.oye_number vbn_driver
		, d.mobile
	FROM oye_prod.vehicle v
	LEFT JOIN oye_prod.driver d
		ON d.vehicle_id = v.id
	WHERE d.mobile IS NOT NULL
	) AS c 
on c.mobile = a.referral_mobile
) as a
left join tmp_operations.merchant_partners as mp on a.mobile = mp.mobile
left join tmp_operations.oye_dost as od on a.mobile = od.mobile_number
