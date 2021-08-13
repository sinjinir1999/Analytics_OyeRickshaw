select onboarding_biz,count (distinct mobile) as total_drivers,
count(distinct case when document_status='Verified' then mobile end) as document_verification_count,
count(distinct case when document_status='Failed' then mobile end) as document_failed_count,
count(distinct case when document_status='Pending' then mobile end) as document_pending_count
from tmp_operations.bgv_data b
left join tmp_operations.vehicle_consolidated v on b.vbn=v.vbn
where onboarding_biz<>'' and onboarding_biz<>'ONBOARDING CHURN'
Group by 1 
