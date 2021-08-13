select onboarding_biz,count (distinct mobile) as total_drivers,
count(distinct case when aadhar_status='Verified' then mobile end) as aadhar_verification_count,
count(distinct case when aadhar_status='Pending' then mobile end) as aadhar_pending_count,
count(distinct case when aadhar_status='Failed' then mobile end) as aadhar_failed_count
from tmp_operations.bgv_data b
left join tmp_operations.vehicle_consolidated v on b.vbn=v.vbn
where onboarding_biz<>'' and onboarding_biz<>'ONBOARDING CHURN'
Group by 1 
