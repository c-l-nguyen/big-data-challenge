-- only a small fraction of reviews are Vine reviews
select vine, count(*) as total_count
from sw_vine_table
group by vine;

-- the reviews with the most helpful and total votes are
-- mostly not Vine reviews (only 1 Vine review out of 7)
-- and it is not even the review with the highest number of
-- helpful votes
select total_votes from sw_vine_table
order by total_votes desc
limit 5;

select * from sw_vine_table
where total_votes > 1200;

-- Vine reviews don't have to be positive...but most are
select star_rating, count(*)
from sw_vine_table
where vine='Y'
group by star_rating;

-- there are some very old reviews in the dataset so let's set 
-- a date cutoff point for more recent reviews that are more useful
select distinct review_date
from sw_review_id_table
order by review_date
limit 5;

-- define 2010 to be cutoff year for useful reviews
drop table if exists recent_reviews;
create temp table recent_reviews as
select a.*, b.customer_id, b.review_date
from sw_vine_table as a
left join sw_review_id_table as b
on a.review_id=b.review_id
where DATE_PART('year',b.review_date) >= 2010;

--  just for viewing data in temp table
select * from recent_reviews
limit 50;

-- seems that Vine reviews are voted more helpful than non-Vine reviews
-- must count only total_votes > 0 due to division
select vine, sum(helpful_votes)/sum(total_votes)::float as helpful_percent from (
	select *
	from recent_reviews
	where total_votes > 0
) as a
group by vine;

-- The average number of total votes is very similar between non-Vine
-- and Vine reviews (6.27 vs 6.25) when they exist.
-- When 0 votes are included, average number of total votes drop
-- (3.15 vs 3.72) but are still vert similar to each other.
select vine, avg(total_votes)::float as avg_total_votes from 
(
	select *
	from recent_reviews
-- 	where total_votes > 0
) as a
group by vine;

-- Little difference between average star ratings for Vine and
-- non-Vine reviews (3.8 vs 3.7 stars)
select vine, avg(star_rating)::float as avg_star_rating from (
	select *
	from recent_reviews
) as a
group by vine;

-- a fair number of customers had 5 or less software purchases but are still
-- part of the Vine program? Seems fishy
select customer_count, count(*) from
(
	select a.customer_count, b.*
	from vg_customers as a
	left join recent_reviews as b
	on a.customer_id = b.customer_id
	where b.vine='Y'
) as tbl
group by customer_count;
