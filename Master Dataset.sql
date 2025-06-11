-- Master Dataset
with cte_brand as
(
  select
     a.safegraph_brand_id
    ,a.parent_safegraph_brand_id
    ,a.brand_name
    ,b.brand_name as parent_brand_name
    ,a.naics_code
    ,a.top_category
    ,a.sub_category
    ,a.stock_exchange
    ,a.stock_symbol
  from
  `group-7-fa24-mgmt58200-final.safegraph.brands` a
  left join
  `group-7-fa24-mgmt58200-final.safegraph.brands` b
  on
  a.parent_safegraph_brand_id = b.safegraph_brand_id
)

,cte_master_data as
(
	select 
		 a.safegraph_place_id
		,coalesce(a.location_name,b.location_name) as location_name
		,c.safegraph_brand_id
		,c.brand_name
		,c.parent_safegraph_brand_id
		,c.parent_brand_name
		,c.naics_code
		,c.top_category
		,c.sub_category
		,c.stock_exchange
		,c.stock_symbol
		,b.latitude
		,b.longitude
		,coalesce(a.postal_code,b.postal_code) as postal_code
		,coalesce(a.street_address,b.street_address) as street_address
		,e.county
		,coalesce(a.city,b.city) as city
		,coalesce(a.region,b.region,e.state) as state
		,a.date_range_start
		,a.date_range_end
		,a.median_dwell
		,a.raw_visit_counts
		,a.raw_visitor_counts
		,a.visits_by_day -- Sum of this is raw_visit_counts
		,a.popularity_by_day -- Sum of this is raw_visit_counts
		,a.popularity_by_hour
	from
	`group-7-fa24-mgmt58200-final.safegraph.visits` a
	left join
	`group-7-fa24-mgmt58200-final.safegraph.places` b
	on
	a.safegraph_place_id = b.safegraph_place_id
	left join
	cte_brand c
	on
	coalesce(a.safegraph_brand_ids,b.safegraph_brand_ids) = c.safegraph_brand_id
	left join
	`group-7-fa24-mgmt58200-final.safegraph.cbg_demographics` d
	on
	a.poi_cbg = d.cbg
	left join
	`group-7-fa24-mgmt58200-final.safegraph.cbg_fips` e
	on
	left(a.poi_cbg,5) = concat(e.state_fips,e.county_fips)
)

,cte_restaurant_data as
(
	select
		*
	from
	cte_master_data
	where
	lower(top_category) like '%restaurant%'
)

select
	*
from
cte_restaurant_data
limit 100;

