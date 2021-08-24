SELECT zone
	,Total_Referrals,Total_VBN
	,(ROUND((Verified_Referrals * 100.0 / Total_Referrals), 2) || '%') AS Verified_Referrals_percentage
	,(ROUND((First_Ladder * 100.0 / Total_Referrals), 2) || '%') AS First_Ladder_Percentage
	,(ROUND((Second_Ladder * 100.0 / Total_Referrals), 2) || '%') AS Second_Ladder_Percentage

FROM
(SELECT  od.zone,count(distinct referral_mobile) Total_Referrals
,(count(distinct case when lead_verification_state = 'Verified' then referral_mobile end)
+count(distinct case when lead_verification_state <> 'Verified' and referral_vbn is not null then referral_mobile end)) as Verified_Referrals
,count(distinct case when referral_vbn is not null then referral_mobile end) as Total_VBN
	,count(DISTINCT CASE 
			WHEN v.first_ride IS NOT NULL
				OR v.first_delivery_date IS NOT NULL
				OR v.first_swap_date IS NOT NULL
				THEN v.vbn
			END) AS First_Ladder
	,count(DISTINCT CASE 
			WHEN lifetime_rides >= 40
				OR total_delivery_days >= 10
				OR total_swaps >= 10
				AND ((forty_ride_date-v.first_ride)<=15 OR
					(tenth_swap_date - v.first_swap_date) <= 15
					OR (tenth_delivery_date - v.first_swap_date) <= 15
					)
				THEN v.vbn
			END) AS Second_Ladder
from tmp_operations.referrals_lead_data rl
left join tmp_operations.oye_dost as od on rl.referree_mobile = od.mobile_number
left join tmp_operations.zoho_crm_data as z on rl.referral_mobile = z.driver_phone_number
left join tmp_operations.vehicle_consolidated as v on rl.referral_mobile = v.driver_mobile

LEFT JOIN (select vbn
, max(first_ride_date) first_ride_date
,max(ten_ride_date) ten_ride_date
,max(forty_ride_date) forty_ride_date
from
(
select oye_number as vbn,case when ranks = 1 then ride_date end as first_ride_date
,case when ranks = 10 then ride_date end as ten_ride_date
,case when ranks = 40 then ride_date end as forty_ride_date
from
(
select oye_number,date(r.created_at) ride_date,row_number() over(partition by oye_number order by r.id asc)  ranks
from oye_prod.vehicle as v
left join oye_prod.ride r on v.id = r.vehicle_id
where r.state = 2
and oye_number not like '%TEST%' and oye_number not in
  ('1',
'2',
'3',
'4',
'5',
'6',
'7',
'8',
'9',
'10',
'11',
'12',
'13',
'14',
'15',
'16',
'17',
'18',
'19',
'20',
'21',
'22',
'23',
'24',
'25',
'26',
'27',
'28',
'29',
'30',
'31',
'32',
'33',
'34',
'35',
'36',
'37',
'38',
'39',
'40')
) as a
) as a
group by 1) AS rd ON rl.referral_vbn = rd.vbn
LEFT JOIN tmp_operations.delivery_date_bifurcation AS dd ON rl.referral_vbn = dd.vbn
LEFT JOIN tmp_operations.swap_date_bifurcation AS sd ON rl.referral_vbn = sd.vbn
WHERE od.zone IS NOT NULL
	AND od.zone <> '' and referral_date>='2021-08-01'
GROUP BY 1
ORDER BY 1) as T
