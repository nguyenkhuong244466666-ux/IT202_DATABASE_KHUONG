SELECT *
FROM Drivers
WHERE status = 'AVAILABLE'
AND trust_score >= GREATEST(0, :min_trust_score)
ORDER BY distance_km ASC, trust_score DESC;