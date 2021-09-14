select zone_new,vbn_generated,d2d_vbn,o2d_vbn,oye_dost_vbn,agency_vbn,vbn_generated-(d2d_vbn+o2d_vbn+oye_dost_vbn+agency_vbn) as others
from
(
Select ve.zone_new,count(distinct vbn)as vbn_generated,case when d2d_vbn is null then 0 else d2d_vbn end as d2d_vbn
,case when o2d_vbn is null then 0 else o2d_vbn end as o2d_vbn
,case when oye_dost_vbn is null then 0 else oye_dost_vbn end as oye_dost_vbn
,case when agency_vbn is null then 0 else agency_vbn end as agency_vbn
from tmp_operations.vehicle_consolidated ve 
left join
(Select v.zone_new,count(distinct case when referral_vbn is not null then referral_mobile end)o2d_vbn
from tmp_operations.merchant_partners mp 
left join tmp_operations.referrals_lead_data r on r.referree_mobile=mp.mobile
left join tmp_operations.vehicle_consolidated v on r.referral_mobile=v.driver_mobile
where v.onboarding_date between '2021-08-26' and current_date
group by 1) as o2d on o2d.zone_new=ve.zone_new
left join
(Select v.zone_new,count(distinct case when referral_vbn is not null then referral_mobile end)oye_dost_vbn
from tmp_operations.oye_dost mp 
left join tmp_operations.referrals_lead_data r on r.referree_mobile=mp.mobile_number
left join tmp_operations.vehicle_consolidated v on r.referral_mobile=v.driver_mobile
where v.onboarding_date between '2021-08-26' and current_date
group by 1) as oye on oye.zone_new=ve.zone_new
left join
(Select v.zone_new,count(distinct case when referree_vbn is not null then referral_vbn end)d2d_vbn
from  tmp_operations.referrals_lead_data r 
left join tmp_operations.vehicle_consolidated v on r.referral_mobile=v.driver_mobile
where v.onboarding_date between '2021-08-26' and current_date
group by 1) as d2d on d2d.zone_new=ve.zone_new
left join
(
select v.zone_new,count(distinct case when lead_number is not null then vbn end) as agency_vbn
from tmp_operations.vehicle_consolidated as v
left join tmp_operations.agency as a on v.driver_mobile = a.lead_number
where v.onboarding_date between '2021-08-26' and current_date
group by 1
) as agency on ve.zone_new=agency.zone_new
where ve.onboarding_date  between '2021-08-26' and current_date and ve.zone_new<>''
group by 1,3,4,5,6
order by 1
) as a
