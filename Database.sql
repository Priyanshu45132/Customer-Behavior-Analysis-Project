 create database customer_behaviour;
 use customer_behaviour;
 
 select * from customer_dataset limit 10;
 
 # Total revenue genrated by male vs female customer
 select sum(case when gender='Male' then purchase_amount else 0 end) as Male_Revenue, sum(case when gender='Female' then purchase_amount 
 else 0 end) as Female_Revenue from customer_dataset;
 
 select gender, sum(purchase_amount) as Revenue from customer_dataset group by gender order by Revenue desc;
 
 # which customer used a discount but still spent more than the average purchase amount
 select customer_id, sum(purchase_amount) as Amount,(select round(avg(purchase_amount),2) from customer_dataset) as Average,discount_applied from customer_dataset where discount_applied = "Yes" group by customer_id having sum(purchase_amount)
 >(select avg(purchase_amount) from customer_dataset) order by Amount desc;
 
 # which are the top 5 products with the highest average review rating
 select item_purchased as Product, round(avg(review_rating),2) as Average_Rating from customer_dataset group by item_purchased
 order by  Average_Rating desc limit 5 ;
 
 # compare the average purchase amounts between standard and express shippning
  select avg(case when shipping_type='Standard' then purchase_amount end) as Standard, avg(case when shipping_type='Express'
  then purchase_amount  end) as Express from customer_dataset;
  # Do subscribe customers spend more? Compare average spend and total revenue between subscribers and non- subscribers.
   select subscription_status,count(customer_id) as total_customers,round(avg(purchase_amount),2) as avg_spend, round(sum(purchase_amount),2) as  total_revenue from customer_dataset
   group by subscription_status order by total_revenue,avg_spend desc;
  
  # Which 5 product have the highest percentage of purchase with discounts applied?
   
  select item_purchased, round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2) as discount from customer_dataset
  group by item_purchased order by discount desc limit 5;
  
  # Segmenet customer into new, returning and loyal based on thier total number of previous purchase and show the count of each segment
  with customer_type as ( select customer_id, previous_purchases , case when previous_purchases =1 then 'New' when previous_purchases between
  2 and 10 then 'Returning' Else 'Loyal' end as customer_segment from customer_dataset)
  select customer_segment, count(*) as Number_of_Previous_Purchases from customer_type group by customer_segment;
  
  # What are the top 3 most purchased products within each category
  with product_count as (select category, item_purchased, count(*) as cu_count from customer_dataset group by category ,item_purchased)
  select * from(select category, item_purchased, cu_count,row_number() Over(partition by category  order by  cu_count desc) as ranking from product_count) as t where ranking<4;

# Are customers who are repeat buyers (more then 5 previous_purchase) also likely to subscribe
select subscription_status, count(customer_id) as Repeat_buyers from customer_dataset where previous_purchases > 5 group by subscription_status order by 
Repeat_buyers desc ;

# What is the  revenue contribution of each age group
select age_group, sum(purchase_amount) as Revenue from customer_dataset group by age_group order by Revenue desc;



select * from customer_dataset;