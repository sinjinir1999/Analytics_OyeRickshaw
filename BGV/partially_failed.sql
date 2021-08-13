select b.vbn,mobile,final_status,onboarding_biz,
case 
when aadhar_status ='Partially Verified' then aadhar_remark
when dl_status='Not Verifiable' then dl_remark
end as Partially_Failed_Reason
from tmp_operations.bgv_data b
left join tmp_operations.vehicle_consolidated v on b.vbn=v.vbn
where onboarding_biz<>'' and onboarding_biz<>'ONBOARDING CHURN' and final_status='Partially Failed'
order by 4
