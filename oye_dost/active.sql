select zone_new, count(distinct case when rank>=3 then mobile_number end) as Active_Partners
from
(select mobile_number,referral_mobile,
row_number() over (partition by mobile_number order by referral_mobile) as rank
from
tmp_operations.referrals_lead_data as rl
left join tmp_operations.oye_dost o on o.mobile_number=rl.referree_mobile
where referral_date>='2021-03-26'
group by 1,referral_mobile
) as A
left join tmp_operations.vehicle_consolidated v on v.driver_mobile=A.referral_mobile
where zone_new <>'' AND mobile_number <> ''
group by 1 
