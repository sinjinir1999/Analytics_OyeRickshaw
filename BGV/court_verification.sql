select onboarding_biz,count (distinct mobile) as total_drivers,
count(distinct case when court_check_status='Verified' then mobile end) as court_verification_count,
count(distinct case when court_check_status='Failed' then mobile end) as court_failed_count
from tmp_operations.bgv_data b
left join tmp_operations.vehicle_consolidated v on b.vbn=v.vbn
where onboarding_biz<>'' and onboarding_biz<>'ONBOARDING CHURN'
Group by 1 
