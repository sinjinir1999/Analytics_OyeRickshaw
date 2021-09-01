select extract(month from mp.onboarding_date) as months,
count(distinct case when rank_ob>=1 then mp.mobile end) as Merchant_Partners_with_atleast_one_ob
from
(select mobile,referral_mobile,
row_number() over (partition by mobile order by referral_vbn) as rank_ob
from
tmp_operations.referrals_lead_data as rl
left join tmp_operations.merchant_partners mp on rl.referree_mobile=mp.mobile
where referral_date between '2021-04-01' and current_date
group by 1,referral_mobile,referral_vbn
) as A
left join tmp_operations.merchant_partners mp on A.mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on v.driver_mobile=A.referral_mobile
where mp.onboarding_date between '2021-04-01' and current_date
group by 1 

order by 1
