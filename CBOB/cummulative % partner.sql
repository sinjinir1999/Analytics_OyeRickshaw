select month,count(distinct mobile) as merchant_partners,count(distinct case when rank>=3 then mobile end) as active_partners
from
((select '4' as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp

left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
where referral_date<='2021-04-01'
group by 1,2,referral_mobile
order by 1) 
union
(select '5' as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp

left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
where referral_date<='2021-05-01'
group by 1,2,referral_mobile
order by 1) 
union
(select '6' as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp

left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
where referral_date<='2021-06-01'
group by 1,2,referral_mobile
order by 1) 
union
(select '7' as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp

left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
where referral_date<='2021-07-01'
group by 1,2,referral_mobile
order by 1) 
union
(select '8' as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp

left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
where referral_date<='2021-08-01'
group by 1,2,referral_mobile
order by 1) ) as tab
group by 1 
order by 1
