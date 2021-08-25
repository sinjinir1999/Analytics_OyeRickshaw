
select a.oye_number,a.document_number from
(select v.oye_number,v.region_id,d.id,d.mobile,kd.document_type, kd.document_number,kd.source_data->>'state' as state,kd.source_data->>'gender' as driver_gender, kd.details ->> 'dob' as dob,kd.details ->> 'address' as address
,kd.details ->> 'zip' as pincode
from kyc_document as kd
left join user_document ud on ud.kyc_document_id = kd.id and kd.document_type = 'RC' and ud.user_type = 'VEHICLE' and ud.document_type = 'RC'
left join driver as d on ud.user_id = d.id
left join vehicle v on v.id = d.vehicle_id
where kd.document_type = 'RC' and ud.user_type = 'VEHICLE'
) as a
where a.oye_number is not null

