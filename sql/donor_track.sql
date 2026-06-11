--donor tracking funding 

-- Total Funding Received - 871500
SELECT 
SUM(funding_received_usd) AS total_funding
FROM donor_track;

--Which funding sources contribute the most?
SELECT
funding_source_type,
SUM(funding_received_usd) AS total_funding
FROM donor_track
GROUP BY funding_source_type
ORDER BY total_funding DESC;

--Who are our biggest donors?
SELECT
donor_name,
SUM(funding_received_usd) AS total_funding
FROM donor_track
GROUP BY donor_name
ORDER BY total_funding DESC;

--Which programs use their funding most effectively?
SELECT
program_funded,
ROUND(AVG(funding_utilization_pct)::numeric, 2) AS utilization_pct
FROM donor_track
GROUP BY program_funded
ORDER BY utilization_pct DESC;

