select month,merchant_partners,active_partners,(ROUND((active_partners * 100.0 / merchant_partners), 2) || '%') AS partners_referring_percentage from 
(select '4' as Month , count(distinct case when mp.onboarding_date<='2021-04-30' then mp.mobile end) as merchant_partners,count(distinct case when rank>=3 then apr.mobile end) as active_partners
from tmp_operations.merchant_partners mp
left join 
(select case when  referral_date between'2021-04-01' and '2021-04-30' then '4' end as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
group by 1,2,referral_mobile
order by 1
) as Apr on apr.month=month
union
select '5' as Month , count(distinct case when mp.onboarding_date<='2021-05-31' then mp.mobile end) as merchant_partners,count(distinct case when rank>=3 then may.mobile end) as active_partners
from tmp_operations.merchant_partners mp
left join 
(select case when  referral_date between'2021-05-01' and '2021-05-31' then '5' end as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
group by 1,2,referral_mobile
order by 1
) as may on may.month=month
union
select '6' as Month , count(distinct case when mp.onboarding_date<='2021-06-30' then mp.mobile end) as merchant_partners,count(distinct case when rank>=3 then jun.mobile end) as active_partners
from tmp_operations.merchant_partners mp
left join 
(select case when  referral_date between'2021-06-01' and '2021-06-30' then '6' end as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
group by 1,2,referral_mobile
order by 1
) as jun on jun.month=month
union
select '7' as Month , count(distinct case when mp.onboarding_date<='2021-07-31' then mp.mobile end) as merchant_partners,count(distinct case when rank>=3 then jul.mobile end) as active_partners
from tmp_operations.merchant_partners mp
left join 
(select case when  referral_date between'2021-07-01' and '2021-07-31' then '7' end as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
group by 1,2,referral_mobile
order by 1
) as jul on jul.month=month
union
select '8' as Month , count(distinct case when mp.onboarding_date<='2021-08-31' then mp.mobile end) as merchant_partners,count(distinct case when rank>=3 then aug.mobile end) as active_partners
from tmp_operations.merchant_partners mp
left join 
(select case when  referral_date between'2021-08-01' and '2021-08-31' then '8' end as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
group by 1,2,referral_mobile
order by 1
) as aug on aug.month=month
union
select '9' as Month , count(distinct case when mp.onboarding_date<='2021-09-30' then mp.mobile end) as merchant_partners,count(distinct case when rank>=3 then sep.mobile end) as active_partners
from tmp_operations.merchant_partners mp
left join 
(select case when  referral_date between'2021-09-01' and '2021-09-30' then '9' end as month,mobile,
row_number() over (partition by mobile order by referral_mobile) as rank
from
tmp_operations.merchant_partners mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile=rl.referree_mobile
group by 1,2,referral_mobile
order by 1
) as sep on sep.month=month

order by 1)
