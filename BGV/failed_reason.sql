select b.vbn,mobile,final_status,onboarding_biz,
case when ca_status in('Failed','Not Verifiable') then ca_remark
when aadhar_status ='Failed' then aadhar_remark
when pan_status='Failed' then pan_remark
when dl_status='Failed' then dl_remark
when cr_status='Failed' then court_record
end as Failed_Reason

from tmp_operations.bgv_data b
left join tmp_operations.vehicle_consolidated v on b.vbn=v.vbn
where onboarding_biz<>'' and onboarding_biz<>'ONBOARDING CHURN' and final_status='Failed'
order by 4
