select zone_new,
count(distinct case when onboarding_date <= '2021-07-31' and count_of_leads >= 3 and months = 8 and months != 7 and referral_count>=3 then referree_mobile end) as total_leads
from
(
SELECT zone_new,extract(month from referral_date) months,referree_mobile,onboarding_date,
	count(distinct referral_mobile) count_of_leads,count(distinct case when referral_date between '2021-07-26' and '2021-08-25' then referral_mobile end) as referral_count
FROM tmp_operations.referrals_lead_data AS rl
LEFT JOIN tmp_operations.merchant_partners AS mp ON mp.mobile = rl.referree_mobile
WHERE zone_new IS NOT NULL
	AND zone_new <> ''
GROUP BY 1,2,3,4
) as a
group by 1
