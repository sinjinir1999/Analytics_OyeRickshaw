select onboarding_biz,count (distinct mobile) as total_drivers,
count(distinct case when final_status='Verified' then mobile end) as final_verification_count,
count(distinct case when final_status='Failed' then mobile end) as final_failed_count,
count(distinct case when final_status='Inprocess' then mobile end) as final_inprocess_count
from tmp_operations.bgv_data b
left join tmp_operations.vehicle_consolidated v on b.vbn=v.vbn
where onboarding_biz<>'' and onboarding_biz<>'ONBOARDING CHURN' and verification_subsription_category='ID+CRC'
Group by 1 
