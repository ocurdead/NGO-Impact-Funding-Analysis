--operation monitoring

--data quality trend
SELECT
    month,
    data_quality_score_pct,

    data_quality_score_pct -
    LAG(data_quality_score_pct) OVER (
        ORDER BY month_number
    ) AS score_change,

    CASE
        WHEN (
            data_quality_score_pct -
            LAG(data_quality_score_pct) OVER (
                ORDER BY month_number
            )
        ) > 0 THEN 'Improved'

        WHEN (
            data_quality_score_pct -
            LAG(data_quality_score_pct) OVER (
                ORDER BY month_number
            )
        ) < 0 THEN 'Declined'

        ELSE 'No Change'
    END AS monthly_trend

FROM operations_monitoring
ORDER BY month_number;

--What percentage of the year was the NGO operating under low, medium, or high risk?
SELECT
    operational_risk_level,
    COUNT(*) AS months_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS pct_of_year

FROM operations_monitoring
GROUP BY operational_risk_level;