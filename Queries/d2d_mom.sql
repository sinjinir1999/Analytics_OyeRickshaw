Select extract(month from referral_date)as months,
count (distinct referree_vbn) as d2d_partners,d2d_vbn,Active_d2d_vbn
from tmp_operations.referrals_lead_data r
left join 
(Select extract(month from v.onboarding_date) as months, count(DISTINCT CASE 
			WHEN referree_vbn IS NOT NULL
				THEN vbn
			END) AS d2d_vbn
			,count(distinct case when referree_vbn is not null and ((last_ride>='2021-01-01') OR (last_delivery_date >='2021-01-01') OR
			(last_swap_date >='2021-01-01')) then vbn end) as Active_d2d_vbn
				from tmp_operations.referrals_lead_data rl 
			left join tmp_operations.vehicle_consolidated v on v.driver_mobile=rl.referral_mobile
			where v.onboarding_date>='2021-01-01'
			group by 1
			order by 1 ) as d2d on extract(month from referral_date)=d2d.months
			
			where referral_date>='2021-01-01'
			group by 1,3,4
			order by 1
