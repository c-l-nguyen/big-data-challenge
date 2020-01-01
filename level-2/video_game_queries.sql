-- only a small fraction of reviews are Vine reviews
select vine, count(*) as total_count
from vg_vine_table
group by vine;

-- the reviews with the most helpful and total votes 
-- are not Vine reviews (and also very negative)
select * from vg_vine_table
where total_votes > 9000;

-- Vine reviews don't have to be positive...but most are
select star_rating, count(*)
from vg_vine_table
where vine='Y'
group by star_rating;

-- there are some very old reviews in the dataset so let's set 
-- a date cutoff point for more recent reviews that are more useful
select distinct review_date
from vg_review_id_table
order by review_date
limit 5;

-- define 2010 to be cutoff year for useful reviews
drop table if exists recent_reviews;
create temp table recent_reviews as
select a.*, b.customer_id, b.review_date
from vg_vine_table as a
left join vg_review_id_table as b
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

-- Slightly more average total votes for non-Vine reviews than Vine
-- (6.4 vs. 5.5), but not a significant difference when votes exist.
-- When 0 votes are included, Vine reviews have more votes (2.7 vs 3.3) 
-- so it seems that Vine reviews get voted on more frequently
select vine, avg(total_votes)::float as avg_total_votes from 
(
	select *
	from recent_reviews
-- 	where total_votes > 0
) as a
group by vine;

-- basically no difference between average star ratings for Vine and
-- non-Vine reviews (both are 4.1 stars)
select vine, avg(star_rating)::float as avg_star_rating from (
	select *
	from recent_reviews
) as a
group by vine;

-- a fair number of customers had 5 or less video game purchases but are still
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
