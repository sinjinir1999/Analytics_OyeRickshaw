select extract(month from mp.onboarding_date)as months,count(distinct mobile) Total_Partners,Total_Referrals
,Verified_Referrals, Overall_Onboarding as Total_vbn
from
tmp_operations.merchant_partners mp 
left join 
(select extract(month from referral_date) as ref_month,count(distinct referral_mobile) as Total_Referrals
from tmp_operations.merchant_partners mp 
left join tmp_operations.referrals_lead_data re   on mp.mobile=re.referree_mobile
where referral_date between '2021-04-01' and current_date
group by 1
order by 1) as a on extract(month from mp.onboarding_date)=a.ref_month

left join
(select extract(month from referral_date) as refe_month,(count(distinct case when lead_verification_state = 'Verified' then referral_mobile end)+count(distinct case when lead_verification_state <> 'Verified' and referral_vbn is not null then referral_mobile end)) as Verified_Referrals
from tmp_operations.merchant_partners mp 
left join tmp_operations.referrals_lead_data re   on mp.mobile=re.referree_mobile
left join tmp_operations.zoho_crm_data z on re.referral_mobile=z.driver_phone_number
where referral_date between '2021-04-01' and current_date
group by 1
order by 1) as b on extract(month from mp.onboarding_date)=b.refe_month
left join 
(SELECT extract(month from v.onboarding_date)as month_ob
	,count(DISTINCT CASE 
			WHEN referral_vbn IS NOT NULL
				THEN referral_mobile
			END) AS Overall_Onboarding
FROM tmp_operations.referrals_lead_data rl
LEFT JOIN tmp_operations.merchant_partners AS mp ON rl.referree_mobile = mp.mobile
LEFT JOIN tmp_operations.vehicle_consolidated AS v ON rl.referral_mobile = v.driver_mobile
WHERE  mp.mobile IS NOT NULL
	AND v.onboarding_date between '2021-04-01' and current_date
GROUP BY 1
ORDER BY 1) as c on month_ob=extract(month from mp.onboarding_date)
where mp.onboarding_date between '2021-04-01' and current_date
group by 1,3,4,5
order by 1
