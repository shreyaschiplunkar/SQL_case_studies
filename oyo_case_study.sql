use oyo;

create table oyo_case_study(
		booking_id integer not null,
        customerid bigint,
        status text,
        check_in text,
        check_out text,
        no_of_rooms integer,
        hotel_id integer,
        amount float,
        discount integer,
        date_of_booking text,
        hotel_city text,
        No_of_days integer,
        Room_rate integer);
        
select * from oyo_case_study;

select count(*) from oyo_case_study;

select count(distinct(hotel_city)) from oyo_case_study;

# No of hotels in diff cities, in descsending order

select count(hotel_id),hotel_city from oyo_case_study group by hotel_city order by count(hotel_id) desc;

#avg room rate by city

SET SQL_SAFE_UPDATES = 0;
alter table oyo_case_study add column rate float;
update oyo_case_study set rate =round(if(no_of_rooms=1,(amount/no_of_days),(amount/no_of_days)/no_of_rooms),2)  ;

select count(rate) from oyo_case_study;
select round(avg(rate),2) as avg_rate,hotel_city from oyo_case_study
group by hotel_city order by avg_rate desc;

