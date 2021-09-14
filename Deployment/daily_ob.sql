select *
from
(
Select ve.onboarding_date,count(distinct vbn)as vbn_generated,nullif(d2d_vbn,0),nullif(o2d_vbn,0),nullif(oye_dost_vbn,0),nullif(agency_vbn,0)
from tmp_operations.vehicle_consolidated ve 
left join
(Select v.onboarding_date,count(distinct case when referral_vbn is not null then referral_mobile end)o2d_vbn
from tmp_operations.merchant_partners mp 
left join tmp_operations.referrals_lead_data r on r.referree_mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on r.referral_mobile=v.driver_mobile
where v.onboarding_date between '2021-08-26' and current_date
group by 1) as o2d on o2d.onboarding_date=ve.onboarding_date
left join
(Select v.onboarding_date,count(distinct case when referral_vbn is not null then referral_mobile end)oye_dost_vbn
from tmp_operations.oye_dost mp 
left join tmp_operations.referrals_lead_data r on r.referree_mobile=mp.mobile_number
left join tmp_operations.vehicle_consolidated v on r.referral_mobile=v.driver_mobile
where v.onboarding_date between '2021-08-26' and current_date
group by 1) as oye on oye.onboarding_date=ve.onboarding_date
left join
(Select v.onboarding_date,count(distinct case when referree_vbn is not null then referral_vbn end)d2d_vbn
from  tmp_operations.referrals_lead_data r 
left join tmp_operations.vehicle_consolidated v on r.referral_mobile=v.driver_mobile
where v.onboarding_date between '2021-08-26' and current_date
group by 1) as d2d on d2d.onboarding_date=ve.onboarding_date
left join
(
select v.onboarding_date,count(distinct case when lead_number is not null then vbn end) as agency_vbn
from tmp_operations.vehicle_consolidated as v
left join tmp_operations.agency as a on v.driver_mobile = a.lead_number
where v.onboarding_date between '2021-08-26' and current_date
group by 1
) as agency on ve.onboarding_date=agency.onboarding_date 
where ve.onboarding_date  between '2021-08-26' and current_date
group by 1,3,4,5,6
order by 1
) as a
