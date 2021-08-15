select distinct mp.zone_name,Total_Partners,count(distinct referral_mobile) Total_Referrals
,(count(distinct case when lead_verification_state = 'Verified' then referral_mobile end)
+count(distinct case when lead_verification_state <> 'Verified' and referral_vbn is not null then referral_mobile end)) as Verified_Referrals
,count(distinct case when referral_vbn is not null then referral_mobile end) as Total_VBN
,Previous_Day_Active_Merchants,Weekly_Active_Merchant Current_Week_Active_Merchants,Monthly_Active_Merchant Current_Month_Active_Merchants
from tmp_operations.referrals_lead_data rl
left join tmp_operations.merchant_partners as mp on rl.referree_mobile = mp.mobile
left join tmp_operations.zoho_crm_data as z on rl.referral_mobile = z.driver_phone_number
left join
(
select distinct zone_name
,count(distinct mobile) Total_Partners
,count(distinct case when referral_date = current_date-2 then mobile end) Previous_Day_Active_Merchants
,count(distinct case when referral_date between current_date-6 and current_date then mobile end) as Weekly_Active_Merchant
,count(distinct case when referral_date between '2021-07-26' and '2021-08-25' then mobile end) as Monthly_Active_Merchant
from 
tmp_operations.merchant_partners as mp
left join tmp_operations.referrals_lead_data as rl on mp.mobile = rl.referree_mobile
where zone_name is not null and zone_name <> ''
group by 1
) as a on mp.zone_name = a.zone_name
where mp.zone_name is not null and mp.zone_name <> '' and referral_date between '2021-07-26' and '2021-08-25'
group by 1,2,6,7,8
order by 1 

