Select v.onboarding_date, count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS O2D_VBN,count(distinct case when (last_ride between '2021-09-01' and current_date) OR (last_delivery_date between '2021-09-01' and current_date) OR
			(last_swap_date between '2021-09-01' and current_date) then referral_vbn end) as Active_o2d
			,count(distinct case when (lifetime_rides between 1 and 5)or (total_delivery_days between 1 and 5) OR (total_swaps between 1 and 5) then vbn end)as One_to_five_transaction
						,count(distinct case when (lifetime_rides>5)or (total_delivery_days>5) OR (total_swaps>5) then vbn end)as More_than_five

			from tmp_operations.merchant_partners mp 
			left join tmp_operations.referrals_lead_data rl on mp.mobile=rl.referree_mobile
			left join tmp_operations.vehicle_consolidated v on v.driver_mobile=rl.referral_mobile
			where v.onboarding_date between '2021-09-01' and current_date
			group by 1 
			order by 1
