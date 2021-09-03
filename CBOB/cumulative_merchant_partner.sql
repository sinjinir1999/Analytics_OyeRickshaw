select month, merchant_partners
from
(select '4' as Month , count(distinct case when mp.onboarding_date<='2021-04-30' then mp.mobile end) as merchant_partners
from tmp_operations.merchant_partners mp) 
union
(select '5' as Month , count(distinct case when mp.onboarding_date<='2021-05-31' then mp.mobile end) as merchant_partners
from tmp_operations.merchant_partners mp) 
union
(select '6' as Month , count(distinct case when mp.onboarding_date<='2021-06-30' then mp.mobile end) as merchant_partners
from tmp_operations.merchant_partners mp) 
union
(select '7' as Month , count(distinct case when mp.onboarding_date<='2021-07-31' then mp.mobile end) as merchant_partners
from tmp_operations.merchant_partners mp) 
union
(select '8' as Month , count(distinct case when mp.onboarding_date<='2021-08-31' then mp.mobile end) as merchant_partners
from tmp_operations.merchant_partners mp)
union
(select '9' as Month , count(distinct case when mp.onboarding_date<='2021-09-30' then mp.mobile end) as merchant_partners
from tmp_operations.merchant_partners mp)
order by 1

