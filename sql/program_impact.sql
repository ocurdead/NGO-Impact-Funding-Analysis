--program impact view 

CREATE VIEW vw_program_impact_metrics AS
SELECT
    *,
    ROUND(
        female_beneficiaries::numeric /
        NULLIF(beneficiaries_reached,0),
        4
    ) AS female_ratio,

    ROUND(
        children_supported::numeric /
        NULLIF(beneficiaries_reached,0),
        4
    ) AS child_support_pct,

    ROUND(
        refugees_supported::numeric /
        NULLIF(beneficiaries_reached,0),
        4
    ) AS refugee_support_pct,

    ROUND(
        cases_resolved::numeric /
        NULLIF(beneficiaries_reached,0),
        4
    ) AS case_resolution_rate

FROM program_impact;

--impact: How many people did the NGO serve? -> 16590
SELECT
SUM(beneficiaries_reached) AS total_beneficiaries
FROM program_impact;

--Which programs create the largest reach?
SELECT
program,
SUM(beneficiaries_reached) AS beneficiaries
FROM program_impact
GROUP BY program
ORDER BY beneficiaries DESC;

--Which regions receive the greatest impact?
SELECT
region,
SUM(beneficiaries_reached) AS beneficiaries
FROM program_impact
GROUP BY region
ORDER BY beneficiaries DESC;

--Which programs are delivering the best beneficiary experience?
SELECT
program,
ROUND(AVG(satisfaction_rate_pct),2) AS avg_satisfaction
FROM program_impact
GROUP BY program
ORDER BY avg_satisfaction DESC;

--Which target groups receive the most support?
SELECT
    target_group,
    SUM(beneficiaries_reached) AS total_beneficiaries,
    ROUND(AVG(satisfaction_rate_pct)::numeric, 2) AS avg_satisfaction
FROM program_impact
GROUP BY target_group
ORDER BY total_beneficiaries DESC, avg_satisfaction DESC;

--Which target group receives the most successful interventions relative to the number of people served?
SELECT
    target_group,
    SUM(beneficiaries_reached) AS beneficiaries,
    SUM(cases_resolved) AS cases_resolved,
	ROUND(
        SUM(cases_resolved)::numeric /
        NULLIF(SUM(beneficiaries_reached),0)*100,
        2
	) AS resolution_rate_pct
FROM program_impact
GROUP BY target_group
ORDER BY beneficiaries DESC;

--Female Participation Analysis
SELECT
    program,
    SUM(female_beneficiaries) AS female_beneficiaries,
    SUM(beneficiaries_reached) AS total_beneficiaries,
    ROUND(
        SUM(female_beneficiaries)::numeric
        / SUM(beneficiaries_reached) * 100,
        2
    ) AS female_participation_pct
FROM program_impact
GROUP BY program
ORDER BY female_participation_pct DESC;

--Quarterly Growth Analysis
SELECT
    quarter,
    SUM(beneficiaries_reached) AS beneficiaries,

    SUM(beneficiaries_reached)
    -
    LAG(SUM(beneficiaries_reached))
    OVER (ORDER BY quarter)
    AS growth_vs_previous_quarter

FROM program_impact
GROUP BY quarter
ORDER BY quarter;
