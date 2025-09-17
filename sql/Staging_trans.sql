ALTER TABLE [dbo].[CANDIDAT]
ADD annee_scolaire VARCHAR(20);

UPDATE c
SET c.annee_scolaire = RIGHT(i.anne_scolaire, 4)
FROM [dbo].[CANDIDAT] c
JOIN [dbo].[BENEFICIAIRE] b ON c.id = b.id_candidat
JOIN (
    SELECT 
        BENEFICIAIRE_ID, 
        MIN(ANNEE_SCOLAIRE) AS anne_scolaire
    FROM 
        [dbo].[INSCRIPTION]
    GROUP BY 
        BENEFICIAIRE_ID
) i ON b.id = i.BENEFICIAIRE_ID;


UPDATE dbo.candidat
SET annee_scolaire = CAST(annee_rand AS VARCHAR)
FROM (
    SELECT 
        id,
        ABS(CHECKSUM(NEWID())) % (2023 - 1990) + 1990 AS annee_rand
    FROM dbo.candidat
    WHERE annee_scolaire IS NULL
) AS T
WHERE dbo.candidat.id = T.id;




--------------------------------------------------filiere----------------------------------------
ALTER TABLE [dbo].[Filiere] ADD is_new BIT;


WITH Randomized AS (
  SELECT *,
         ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn,
         COUNT(*) OVER () AS total
  FROM [dbo].[Filiere]
)
UPDATE Randomized
SET is_new = 1
WHERE rn <= total * 0.2;
