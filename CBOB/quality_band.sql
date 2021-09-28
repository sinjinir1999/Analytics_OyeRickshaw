Select months,count(distinct case when Category='Excellent' then mobile end) as excellent,
count(distinct case when Category='Good' then mobile end) as good,
count(distinct case when Category='Average' then mobile end) as average
from 
(Select  months,mobile,case when rank_ob>=3 then 'Excellent' 
when rank_ob=2 then 'Good'
when rank_ob=1 then 'Average' end as Category
from 
(select extract(month from v.onboarding_date) as months,mobile,referral_mobile,
row_number() over (partition by mobile order by v.vbn) as rank_ob
from tmp_operations.merchant_partners mp 
left join tmp_operations.referrals_lead_data as rl on rl.referree_mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on rl.referral_vbn=v.vbn
where v.onboarding_date>='2021-04-01'
group by 1,2,referral_mobile,v.vbn
order by 1) as t) as d
group by 1
order by 1
