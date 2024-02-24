-- CODEX CHALLENGE --
--------------------------------------------------------------------------------------------------------------
-- 1. Demographic Insights (examples)
-- a. Who prefers energy drink more? (male/female/non-binary?)
SELECT Gender, COUNT(Gender) AS Total_respondents
FROM dim_respondents
GROUP BY Gender
ORDER BY Total_respondents DESC;
-----------------------------------------------------------------------------------------------------------
-- b. Which age group prefers energy drinks more?
SELECT AGE, COUNT(AGE) AS Total_respondents
FROM dim_respondents
GROUP BY AGE
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- c.Which type of marketing reaches the most Youth (15-30)?
SELECT Marketing_channels, age, COUNT(Marketing_channels) AS Total_Reach
FROM fact_survey_responses sr 
JOIN dim_respondents dr
ON sr.Respondent_ID = dr.Respondent_ID
WHERE AGE BETWEEN "15-18" AND "19-30"
GROUP BY Marketing_channels, AGE
ORDER BY AGE, Total_Reach DESC;
--------------------------------------------------------------------------------------------------------------
-- 2 Consumer Preferences:
-- a. What are the preferred ingredients of energy drinks among respondents?
SELECT Ingredients_expected, COUNT(Ingredients_expected) AS Total_respondents
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- b. What packaging preferences do respondents have for energy drinks?
SELECT Packaging_preference, COUNT(Packaging_preference) AS Total_respondents
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- 3. Competition Analysis:
-- a. Who are the current market leaders?
SELECT Current_brands, COUNT(Current_brands) AS Total_respondents
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- b. What are the primary reasons consumers prefer those brands over ours?
SELECT Reasons_for_choosing_brands, COUNT(Reasons_for_choosing_brands) AS Total_respondents 
FROM fact_survey_responses
WHERE Current_brands<>"Codex"
GROUP BY Reasons_for_choosing_brands
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- 4. Marketing Channels and Brand Awareness:
-- a. Which marketing channel can be used to reach more customers?
SELECT Marketing_channels, COUNT(Marketing_channels) AS Total_Reach
FROM fact_survey_responses sr
JOIN dim_respondents dr
ON sr.Respondent_ID = dr.Respondent_ID
GROUP BY Marketing_channels
ORDER BY Total_Reach DESC;
--------------------------------------------------------------------------------------------------------------
-- b. How effective are different marketing strategies and channels in reaching our customers?
with cte_1 as(select Marketing_channels,count(f.respondent_id) AS yes_respondents
from fact_survey_responses sr
where Heard_before="yes"
group by Marketing_channels
order by yes_respondents),
cte_2 as(select Marketing_channels,count(f.respondent_id) AS Total_respondents
from fact_survey_responses sr
group by Marketing_channels
order by Total_respondents)
select *, round((yes_respondents/Total_respondents)*100,2) Reach_pct
from cte_1 join cte_2 on cte_1.marketing_channels=cte_2.marketing_channels
order by Reach_pct;
--------------------------------------------------------------------------------------------------------------
-- 5. Brand Penetration:
-- a. What do people think about our brand? (overall rating)
SELECT Brand_perception, COUNT(Brand_perception) AS Total_respondents
FROM fact_survey_responses sr
JOIN dim_respondents dr
ON sr.Respondent_ID = dr.Respondent_ID
WHERE Current_brands = "CodeX"
GROUP BY Brand_perception
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- b. Which cities do we need to focus more on?
SELECT City, Brand_perception, Count(*)
FROM fact_survey_responses sr
JOIN dim_respondents dr ON sr.Respondent_ID = dr.Respondent_ID
JOIN dim_cities dc ON dc.City_ID = dr.City_ID
WHERE Current_brands = "CodeX" and Brand_perception = "Neutral" or Brand_perception = "Negative"
GROUP BY City, Brand_perception
ORDER BY City;
--------------------------------------------------------------------------------------------------------------
-- 6. Purchase Behavior:
-- a. Where do respondents prefer to purchase energy drinks?
SELECT Purchase_location, COUNT(Purchase_location) AS Total_respondents
FROM fact_survey_responses
GROUP BY Purchase_location
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- b. What are the typical consumption situations for energy drinks among respondents?
SELECT Typical_consumption_situations, COUNT(Typical_consumption_situations) AS Total_respondents
FROM fact_survey_responses
GROUP BY Typical_consumption_situations
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- c. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
SELECT Price_range, Limited_edition_packaging, COUNT(*) AS Total_respondents
FROM fact_survey_responses
GROUP BY Price_range, Limited_edition_packaging
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- 7. Product Development
-- a. Which area of business should we focus more on our product development?(Branding/taste/availability)
SELECT Reasons_for_choosing_brands, COUNT(Reasons_for_choosing_brands) AS Total_respondents
FROM fact_survey_responses
GROUP BY Reasons_for_choosing_brands
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- Recommendations
-- What immediate improvements can we bring to the product?
SELECT Improvements_desired, COUNT(Improvements_desired) AS Total_respondents
FROM fact_survey_responses
WHERE Current_brands = "CodeX"
GROUP BY Improvements_desired
ORDER BY Total_respondents DESC;
--------------------------------------------------------------------------------------------------------------
-- What should be the ideal price of our product?
SELECT Price_range, COUNT(Price_range) AS Total_respondents
FROM fact_survey_responses
WHERE Current_brands = "CodeX"
GROUP BY Price_range
ORDER BY Total_respondents DESC;





