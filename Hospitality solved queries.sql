create database hotel_db;
USE hotel_db;

select * from dim_rooms;
select * from fact_bookings;
select * from fact_aggregated;
select * from dim_date;
select * from dim_hotel;


# Total Revenue
  select 
  sum(revenue_realized) 
from fact_bookings;

#  Occupancy 
SELECT
ROUND((SUM(successful_bookings) * 100.0) / SUM(capacity),2) AS occupancy_percentage
FROM fact_aggregated;

#Cancellation Rate
select
count(booking_status)
from fact_bookings
where booking_status ="Cancelled";

# Total Booking

SELECT
count(booking_status)
from fact_bookings;
 
 # Utilized Capacity
 select
 sum(successful_bookings)
 from fact_aggregated;

# Class Wise Revenue

SELECT
dr.room_class,
SUM(fb.revenue_realized) AS revenue
FROM fact_bookings fb
JOIN dim_rooms dr
ON fb.room_category = dr.room_id
GROUP BY dr.room_class
ORDER BY revenue DESC;

SELECT 
dh.city,
SUM(fb.revenue_realized) AS revenue
FROM fact_bookings fb
JOIN dim_hotel dh
ON fb.property_id = dh.property_id
GROUP BY dh.city
HAVING SUM(fb.revenue_realized) > 500000000;

# Weekday  & Weekend  Revenue and Booking

select 
dd.day_type,
sum(fb.revenue_realized) as revenue,
count(fb.booking_id) as bookings
from fact_bookings fb
join dim_date dd
on dd.date=fb.check_in_date
group by day_type;

# Revenue by State & hotel

select 
dh.property_name as Hotel,
dh.city          as Cities,
sum(fb.revenue_realized) as Revenue
from fact_bookings fb
join dim_hotel     dh
on fb.property_id= dh.property_id
group by dh.property_name,dh.city;

# Checked out cancel No show
select
booking_status,
count(*)
from fact_bookings
group by booking_status;

 SELECT
    dd.`week no`,
    SUM(fb.revenue_realized) AS revenue,
    COUNT(fb.booking_id) AS total_bookings,
    ROUND(
        (SUM(fa.successful_bookings) * 100.0) /
        SUM(fa.capacity),
        2
    ) AS occupancy_percentage
FROM fact_bookings fb
JOIN dim_date dd
    ON fb.check_in_date = dd.date
JOIN fact_aggregated fa
    ON fb.property_id = fa.property_id
    AND fb.check_in_date = fa.check_in_date
GROUP BY dd.`week no`
ORDER BY dd.`week no`;
