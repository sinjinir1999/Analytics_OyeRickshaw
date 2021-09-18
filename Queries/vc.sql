Select vbn,case when mp.mobile is not null then 'CBOB'
when o.mobile_number is not null then 'Oye Dost'
when referree_vbn is not null then 'Driver Referral'
when a.lead_number is not null then 'Agency'
else 'Centrally Onboarded' end as lead_source,
city,v.zone,v.hub,driver_mobile,owner_mobile,v.onboarding_date,first_ride,last_ride,lifetime_rides,first_delivery_date,last_delivery_date,
total_delivery_days,delivery_driver_status,first_swap_date,
last_swap_date,total_swaps,onboarding_biz,v.zone_new from tmp_operations.vehicle_consolidated v
left join tmp_operations.referrals_lead_data rl on v.vbn=rl.referral_vbn
left join tmp_operations.merchant_partners mp on rl.referree_mobile=mp.mobile
left join tmp_operations.oye_dost o on rl.referree_mobile=o.mobile_number
left join tmp_operations.agency a on v.driver_mobile=a.lead_number
