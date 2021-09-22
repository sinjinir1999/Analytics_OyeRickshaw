with d_incentive as
( select created_date,driver_id,coalesce(sum(case when incentive_type='DRIVER_TO_DRIVER_REFERRAL' then incentive end ),0)::decimal/100 d2d,
coalesce(sum(case when incentive_type='RIDE_COUNT_MULTIPLIER' then incentive end ),0)::decimal/100 rc,
coalesce(sum(case when incentive_type='RIDER_APP_REFERRAL' then incentive end ),0)::decimal/100 app
from oye_prod.driver_incentive
group by 1,2
order by 1
)
select driver_earning.created_date,rg.name,d.id,vehicle.oye_number,coalesce(sum(driver_earning.total_earning+driver_earning.bonus_pay),0)::Decimal/100 earning,
coalesce(sum(driver_earning.cash),0)::decimal/100 cash,coalesce(sum(d_incentive.d2d),0) d2d_incentive,
coalesce(sum(d_incentive.rc),0) rc_incentive,
coalesce(sum(d_incentive.app),0) app_incentive,
coalesce(sum(case when dd.deduction_reason_id=2 then dd.amount end),0)::decimal/100 as EMI,
coalesce(sum(case when dd.deduction_reason_id=5 then dd.amount end),0)::decimal/100 as lease,
coalesce(sum(case when dd.deduction_reason_id=6 then dd.amount end),0)::decimal/100 as tds,
coalesce(sum(case when dd.deduction_reason_id in (9,36) then dd.amount end),0)::decimal/100 as ming,
coalesce(sum(case when dd.deduction_reason_id=10 then dd.amount end),0)::decimal/100 as joining_bonus,
coalesce(sum(case when dd.deduction_reason_id in (26,40,50,51) then dd.amount end),0)::decimal/100 as login_incentive ,
coalesce(sum(case when dd.deduction_reason_id=47 then dd.amount end),0)::decimal/100 as operational_charges,
coalesce(sum(case when dd.deduction_reason_id=71 then dd.amount end),0)::decimal/100 as daily_rc
from oye_prod.driver_earning
join d_incentive on d_incentive.created_date=driver_earning.created_date and driver_earning.driver_id=d_incentive.driver_id
join oye_prod.driver_deduction dd on driver_earning.id=dd.driver_earning_id
join oye_prod.driver d on driver_earning.driver_id=d.id
left join oye_prod.vehicle  on d.vehicle_id =vehicle.id
join oye_prod.region rg on vehicle.region_id =rg.id
where driver_earning.created_date >= '2021-05-01'
group by 1,2,3,4
order by 1
