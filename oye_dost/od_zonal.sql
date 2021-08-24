select distinct od.zone,Total_Partners,count(distinct referral_mobile) Total_Referrals
,(count(distinct case when lead_verification_state = 'Verified' then referral_mobile end)
+count(distinct case when lead_verification_state <> 'Verified' and referral_vbn is not null then referral_mobile end)) as Verified_Referrals
,count(distinct case when referral_vbn is not null then referral_mobile end) as Total_VBN
,Previous_Day_Active_Merchants,Weekly_Active_Merchant Current_Week_Active_Merchants,Monthly_Active_Merchant Current_Month_Active_Merchants
from tmp_operations.referrals_lead_data rl
left join tmp_operations.oye_dost as od on rl.referree_mobile = od.mobile_number
left join tmp_operations.zoho_crm_data as z on rl.referral_mobile = z.driver_phone_number
left join
(
select distinct zone
,count(distinct mobile_number) Total_Partners
,count(distinct case when referral_date = current_date-2 then mobile_number end) Previous_Day_Active_Merchants
,count(distinct case when referral_date between current_date-6 and current_date then mobile_number end) as Weekly_Active_Merchant
,count(distinct case when referral_date between '2021-08-01' and last_day(current_date) then mobile_number end) as Monthly_Active_Merchant
from 
tmp_operations.oye_dost as od
left join tmp_operations.referrals_lead_data as rl on rl.referree_mobile=od.mobile_number
where zone is not null and zone <> ''
group by 1
) as a on od.zone = a.zone
where od.zone is not null and od.zone <> '' and referral_date >= '2021-08-01'
group by 1,2,6,7,8
order by 1 
