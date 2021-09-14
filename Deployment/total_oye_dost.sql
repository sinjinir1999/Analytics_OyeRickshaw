Select Oye_dost_VBN,Active_oye_dost,One_five,More_than_five,(round((Active_oye_dost * 100.0 / Oye_dost_VBN),2)||'%') as active_percentage,(round((One_five * 100.0 / Oye_dost_VBN),2)||'%') as One_to_five_percentage,
(round((More_than_five * 100.0 / Oye_dost_VBN),2)||'%') as More_than_five_percentage
from
(Select count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Oye_dost_VBN,count(distinct case when (last_ride between '2021-09-01' and current_date) OR (last_delivery_date between '2021-09-01' and current_date) OR
			(last_swap_date between '2021-09-01' and current_date) then referral_vbn end) as Active_oye_dost
			,count(distinct case when (lifetime_rides between 1 and 5)or (total_delivery_days between 1 and 5) OR (total_swaps between 1 and 5) then vbn end)as One_five
						,count(distinct case when (lifetime_rides>5)or (total_delivery_days>5) OR (total_swaps>5) then vbn end)as More_than_five

			from tmp_operations.oye_dost mp 
			left join tmp_operations.referrals_lead_data rl on mp.mobile_number=rl.referree_mobile
			left join tmp_operations.vehicle_consolidated v on v.driver_mobile=rl.referral_mobile
			where v.onboarding_date between '2021-09-01' and current_date) as t
		
