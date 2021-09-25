select mp.zone_new,
count(distinct case when date(mp.onboarding_date) between '2021-08-26' and current_date then mp.mobile end) New_Merchant_Partners_acquired,New_Merchant_Partners_with_atleast_one_ob,Old_Merchant_Partners_with_atleast_one_ob
from tmp_operations.merchant_partners mp
left join
(Select mp.zone_new,count(distinct mp.mobile) as New_Merchant_Partners_with_atleast_one_ob
from
tmp_operations.merchant_partners mp 
left join
(select mobile,referral_mobile,
row_number() over (partition by mobile order by referral_vbn) as rank_ob
from
tmp_operations.referrals_lead_data as rl
left join tmp_operations.merchant_partners mp on rl.referree_mobile=mp.mobile
where referral_date between '2021-08-26' and '2021-09-25'
group by 1,referral_mobile,referral_vbn
) as A on  A.mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on v.driver_mobile=A.referral_mobile
where mp.zone_new <>'' and date(mp.onboarding_date) between '2021-08-26' and current_date and rank_ob>=1  and v.onboarding_date between '2021-08-26' and '2021-09-25'
group by 1 
) new_merchant on mp.zone_new=new_merchant.zone_new
left join
(select zone_new,count(distinct mobile) as Old_Merchant_Partners_with_atleast_one_ob
from
(
select distinct mp.mobile, mp.zone_new,count(distinct referral_vbn) no_of_ref
from tmp_operations.referrals_lead_data r
left join tmp_operations.merchant_partners as mp on r.referree_mobile = mp.mobile
left join tmp_operations.vehicle_consolidated as v on r.referral_vbn=v.vbn
where mp.onboarding_date < '2021-08-26' and v.onboarding_date between '2021-08-26' and current_date
group by 1,2
) as a
where no_of_ref >= 1
group by 1)as old_merchant on  mp.zone_new=old_merchant.zone_new
where mp.zone_new <>''
group by 1,3,4
