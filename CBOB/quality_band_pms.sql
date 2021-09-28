Select months,count(distinct case when Category='Excellent' then mobile end) as excellent,
count(distinct case when Category='Good' then mobile end) as good,
count(distinct case when Category='Average' then mobile end) as average
from 
(Select  months,mobile,case when rank_ob>=3 then 'Excellent' 
when rank_ob=2 then 'Good'
when rank_ob=1 then 'Average' end as Category
from 
(select  (case when v.onboarding_date between '2021-03-26' and '2021-04-25' then 'April'
		when v.onboarding_date between '2021-04-26' and '2021-05-25' then 'May'
		 when v.onboarding_date between '2021-05-26' and '2021-06-25' then 'June'
		 when v.onboarding_date between '2021-06-26' and '2021-07-25' then 'July'
		 when v.onboarding_date between '2021-07-26' and '2021-08-25' then 'August'
		 	 when v.onboarding_date between '2021-08-26' and '2021-09-25' then 'September'
		 	 	 when v.onboarding_date between '2021-09-26' and '2021-10-25' then 'October' end) as months
		 ,mobile,referral_mobile,
row_number() over (partition by mobile order by v.vbn) as rank_ob
from tmp_operations.merchant_partners mp 
left join tmp_operations.referrals_lead_data as rl on rl.referree_mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on rl.referral_vbn=v.vbn
where v.onboarding_date>='2021-04-01'
group by 1,2,referral_mobile,v.vbn
order by 1) as t) as d
group by 1
order by 1
