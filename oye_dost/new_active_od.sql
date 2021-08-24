
select v.zone_new, count(distinct case when rank>=3 then referree_mobile end) as Active_Partners,
count(distinct case when o.ob_date between '2021-07-26' and '2021-08-25' then mobile_number end) New_Merchant_Partners_acquired
from
(select referree_mobile,referral_mobile,
row_number() over (partition by referree_mobile order by referral_mobile) as rank
from
tmp_operations.referrals_lead_data as rl
where referral_date between '2021-07-26' and '2021-08-25'
group by 1,referral_mobile
) as A
left join tmp_operations.oye_dost o on A.referree_mobile=o.mobile_number
left join tmp_operations.vehicle_consolidated v on v.driver_mobile=A.referral_mobile
where v.zone_new <>'' and o.mobile_number <>''
group by 1 


