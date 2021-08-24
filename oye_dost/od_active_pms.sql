select months,count(distinct mobile_number) as active_partners
from
(select (case 
		when referral_date between '2021-04-26' and '2021-05-25' then 'May'
		 when referral_date between '2021-05-26' and '2021-06-25' then 'June'
		 when referral_date between '2021-06-26' and '2021-07-25' then 'July' 
		 when referral_date between '2021-07-26' and '2021-08-25' then 'August' end) as months,mobile_number,
row_number() over (partition by mobile_number order by referral_mobile) as rank
from
tmp_operations.referrals_lead_data as rl
left join tmp_operations.oye_dost o on o.mobile_number=rl.referree_mobile
where referral_date>='2021-05-01'
group by 1,2,referral_mobile
order by 1
) as A
where rank>=3
group by 1
