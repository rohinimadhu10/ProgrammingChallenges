---1. Write a query to get the sum of impressions by day.
SELECT 
    date,
    SUM(impressions) AS total_impressions
FROM 
    marketing_data
GROUP BY 
    date
---

---2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

SELECT 
    state,
    SUM(revenue) AS total_revenue
FROM 
    website_revenue
GROUP BY 
    state
ORDER BY 
    total_revenue DESC
LIMIT 3;

--- The third best state is Ohio, and it generated $37577 

---3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

SELECT
    campaign_info.name AS campaign_name,
    SUM(marketing_data.cost) AS total_cost,
    SUM(marketing_data.impressions) AS total_impressions,
    SUM(marketing_data.clicks) AS total_clicks,
    SUM(website_revenue.revenue) AS total_revenue
FROM 
    campaign_info
LEFT JOIN 
    marketing_data ON campaign_info.id = marketing_data.campaign_id
LEFT JOIN
    website_revenue ON campaign_info.id = website_revenue.campaign_id
GROUP BY 
    campaign_info.name;
---

---4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?

WITH 
    CTE AS (
        SELECT
            campaign_info.name,
            website_revenue.state,
            marketing_data.conversions

        FROM 
            campaign_info
        INNER JOIN
            website_revenue on campaign_info.id = website_revenue.campaign_id
        INNER JOIN
            marketing_data ON campaign_info.id = marketing_data.campaign_id)

SELECT
    state,
    SUM(conversions) as total_conversions
FROM 
    CTE
WHERE
    name = "Campaign5"
GROUP BY
    state;

--- The state with the most revenue is Georgia, with 3342 conversions.

---5. In your opinion, which campaign was the most efficient, and why?

WITH
    CTE AS(
        SELECT
        campaign_info.name,
        CAST(marketing_data.cost AS FLOAT) as cost,
        CAST(marketing_data.impressions AS FLOAT) as impressions,
        CAST(marketing_data.clicks AS FLOAT) as clicks,
        CAST(marketing_data.conversions AS FLOAT) as conversions,
        CAST(website_revenue.revenue AS FLOAT) as revenue
 

	FROM
        campaign_info
	INNER JOIN
        website_revenue on campaign_info.id = website_revenue.campaign_id
	INNER JOIN
        marketing_data ON campaign_info.id = marketing_data.campaign_id),

    CTE2 AS(
        SELECT
        name,
        SUM(cost) as total_cost,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(conversions) as total_conversions,
        SUM(revenue) AS total_revenue

    FROM 
        CTE
    GROUP BY 
        name)

SELECT 
    name,
    ROUND(total_cost,2) as total_cost,
    ROUND(total_revenue,2) AS total_revenue,
    total_revenue - total_cost as total_profit,
    ROUND(total_cost/total_clicks, 2) AS cost_per_click,
    ROUND((total_revenue - total_cost) / total_cost) * 100 as ROI,
    ROUND(total_clicks/total_impressions,2) * 100 as click_through_rate,
    ROUND(total_conversions/total_clicks,2) * 100 as conversion_rate
FROM CTE2

/*To determine the most efficient campaign, I conducted feature engineering and created the metrics total profit, cost per click,
 ROI (return on investment), click through rate, and conversion rate. After assessing the results of these metrics, it is my opinion that campaign 3 is the most effective.
 Cost per click, total profit, and ROI gives us a good sense on how cost effective each campaign is. 
 When we look at the results from the query above, we see that campaign 3 has the highest
 profit, but it has a higher cost per click and lower ROI. While high cost per clicks and low ROI is usually unfavorable,
 the values are relatively similar to those of the other campaigns, leading me to believe that they are not significantly low
 and the extremely high profit is enough to make up for these unfavorable values. Moreover, campaign three has the highest conversion rate and third 
 highest click through rate. The high click through rate tells us that this campaign effectively captures users' attention,
 while the high conversion rate tells us that this campaign is efficiently turning viewers into consumers.
 The significantly high profit brought in by campaign three as well as the high click through rate and conversion
 rate lead me to believe that this is the most effective campaign. */

---6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

SELECT
    CASE
        WHEN DAYNAME(date) = 'Sunday' THEN 'Sunday'
        WHEN DAYNAME(date) = 'Monday' THEN 'Monday'
        WHEN DAYNAME(date) = 'Tuesday' THEN 'Tuesday'
        WHEN DAYNAME(date) = 'Wednesday' THEN 'Wednesday'
        WHEN DAYNAME(date) = 'Thursday' THEN 'Thursday'
        WHEN DAYNAME(date) = 'Friday' THEN 'Friday'
        WHEN DAYNAME(date) = 'Saturday' THEN 'Saturday'
    END AS day_of_week,
    AVG(clicks) AS avg_clicks
FROM
    marketing_data
GROUP BY
    day_of_week
ORDER BY
    avg_clicks DESC
LIMIT 1;