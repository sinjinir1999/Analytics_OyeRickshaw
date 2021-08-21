
select mp.zone_new, count(distinct case when rank>=3 then referree_mobile end) as Active_Partners,
count(distinct case when mp.onboarding_date between '2021-07-26' and '2021-08-25' then mobile end) New_Merchant_Partners_acquired
from
(select referree_mobile,referral_mobile,
row_number() over (partition by referree_mobile order by referral_mobile) as rank
from
tmp_operations.referrals_lead_data as rl
where referral_date between '2021-07-26' and '2021-08-25'
group by 1,referral_mobile
) as A
left join tmp_operations.merchant_partners mp on A.referree_mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on v.driver_mobile=A.referral_mobile
where mp.zone_new <>''
group by 1 


