use oyo;
create table oyo_hotel_stays(
booking_id integer not null,
        customerid integer,
        status varchar(50),
        check_in text,
        check_out text,
        no_of_rooms integer,
        hotel_id integer,
        amount float,
        discount integer,
        date_of_booking text
        );
        
create table oyo_city(
hotel_id int,
        city varchar(50)
        );
        
select * from oyo_hotel_stays;
select * from oyo_city;

alter table oyo_hotel_stays add column newcheck_in date;
SET SQL_SAFE_UPDATES = 0;
update  oyo_hotel_stays
set newcheck_in=str_to_date(substr(check_in,1,10),'%m/%d/%Y');

alter table oyo_hotel_stays add column newcheck_out date;
update  oyo_hotel_stays
set newcheck_out=str_to_date(substr(check_out,1,10),'%m/%d/%Y');

alter table oyo_hotel_stays add column newdate_of_booking date;
update  oyo_hotel_stays
set newdate_of_booking=str_to_date(substr(date_of_booking,1,10),'%m/%d/%Y');

alter table oyo_hotel_stays
add price float;

update oyo_hotel_stays
set price = amount + discount;

alter table oyo_hotel_stays
add no_of_nights int null;

update oyo_hotel_stays
set no_of_nights = DATEDIFF(newcheck_out,newcheck_in);

alter table oyo_hotel_stays
add rate float null;

update oyo_hotel_stays
set rate = ROUND( case when no_of_rooms = 1 then 
		price/no_of_nights 
		else price/no_of_nights/no_of_rooms end,2);
        
select * from oyo_hotel_stays;

select count(*) from oyo_hotel_stays;
select count(*) from oyo_city;
select count(distinct(city)) from oyo_city;

-- No of oyo hotels in diff cities --

select city,count(hotel_id) from oyo_city
group by city
order by count(hotel_id) desc;

-- avg room rates of diff cities --

 select city ,ROUND( AVG(rate),2) as average_room_rates
 from oyo_hotel_stays
 inner join oyo_city
 using (hotel_id)
 group by city
 order by average_room_rates desc;
 
 -- cancellation rates city wise --
 
 select city, 
			format(100.0* sum(case when status = 'Cancelled' then 1 else 0 end)
			/count(newdate_of_booking),'f1') as cancellation_rate
	 from	oyo_hotel_stays
	 inner join oyo_city
	using (hotel_id)
	 group by city
	 order by cancellation_rate desc;
	
-- no of bookings in diff cities in diff months --

select city, month(newdate_of_booking) as months,count(newdate_of_booking) from oyo_hotel_stays 
inner join oyo_city
using (hotel_id)
group by city,months
order by city;

-- freq of early booking --

select	DATEDIFF(newcheck_in,newdate_of_booking) as days_before_check_in,count(1) as freq
from	oyo_hotel_stays
group by days_before_check_in
order by days_before_check_in;

-- frequency of bookings of no of rooms in Hotel --

select no_of_rooms, count(1) freq
from oyo_hotel_stays
group by no_of_rooms
order by no_of_rooms;

-- net revenue to company (due to some bookings cancelled)  & gross revenue to company --

select	city, sum(amount) gross_revenue , 
		sum(case when status in ('No Show' ,'Stayed') then amount end) as net_revenue
from	oyo_hotel_stays
inner join oyo_city
using (hotel_id)
group by city
order by city;

-- discount offered by different cities --

select	city, format(AVG(100.0*discount/price),'f1') as discount_offered
from	oyo_hotel_stays
inner join oyo_city
using (hotel_id)
group by city
order by discount_offered desc;

-- Insights 

-- 1. Banglore , gurgaon & delhi were popular in the bookings, whereas Kolkata is less popular in bookings
-- 2. Nature of Bookings:

-- • Nearly 50 % of the bookings were made on the day of check in only.
-- • Nearly 85 % of the bookings were made with less than 4 days prior to the date of check in.
-- • Very few no.of bookings were made in advance(i.e over a 1 month or 2 months).
-- • Most of the bookings involved only a single room.
-- • Nearly 80% of the bookings involved a stay of 1 night only.

-- 3. Oyo should acquire more hotels in the cities of Pune, kolkata & Mumbai. Because their average room rates are comparetively higher so more revenue will come.

-- 4. The % cancellation Rate is high on all 9 cities except pune ,so Oyo should focus on finding reasons about cancellation.


