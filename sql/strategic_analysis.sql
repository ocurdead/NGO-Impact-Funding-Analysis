--Strategic Analysis

--compare operation monitoring to program impact
WITH monthly_impact AS (
    SELECT
        month,
        month_number,
        SUM(beneficiaries_reached) AS beneficiaries
    FROM program_impact
    GROUP BY month, month_number
)

SELECT
    o.month,
    o.data_quality_score_pct,
    o.staff_count,
    o.volunteers,
    i.beneficiaries
FROM operations_monitoring o
JOIN monthly_impact i
ON o.month = i.month
ORDER BY o.month_number;

--which program delivier highest impact relative to funding?
SELECT
    f.program_funded,
    SUM(f.funding_received_usd) AS total_funding_received,
    SUM(f.funding_used_usd) AS total_funding_used,
    SUM(p.beneficiaries_reached) AS total_beneficiaries,
    ROUND(
        SUM(p.beneficiaries_reached)::numeric /
        NULLIF(SUM(f.funding_used_usd),0),
        4
    ) AS beneficiaries_per_dollar
FROM donor_track f
JOIN program_impact p
    ON f.program_id = p.program_id
GROUP BY f.program_funded
ORDER BY beneficiaries_per_dollar DESC;

--Does spending more of the budget lead to better outcomes?
SELECT
    d.program_funded,
    ROUND(AVG(d.funding_utilization_pct)::numeric,2) AS utilization_pct,
    ROUND(AVG(p.satisfaction_rate_pct),2) AS avg_satisfaction
FROM donor_track d
JOIN program_impact p
ON d.program_id = p.program_id
GROUP BY d.program_funded
ORDER BY utilization_pct DESC;