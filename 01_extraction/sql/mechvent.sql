CREATE OR REPLACE TABLE `skripsi-fatas-mimic3.mimic3.mechvent` AS
SELECT
  icustay_id,
  UNIX_SECONDS(TIMESTAMP(charttime)) AS charttime,

  -- Mechanical ventilation flag
  MAX(
    CASE
      WHEN itemid IS NULL OR value IS NULL THEN 0
      WHEN itemid = 720 AND value != 'Other/Remarks' THEN 1
      WHEN itemid = 467 AND value = 'Ventilator' THEN 1
      WHEN itemid IN (
        445, 448, 449, 450, 1340, 1486, 1600, 224687,
        639, 654, 681, 682, 683, 684, 224685, 224684, 224686,
        218, 436, 535, 444, 459, 224697, 224695, 224696, 224746, 224747,
        221, 1, 1211, 1655, 2000, 226873, 224738, 224419, 224750, 227187,
        543,
        5865, 5866, 224707, 224709, 224705, 224706,
        60, 437, 505, 506, 686, 220339, 224700,
        3459,
        501, 502, 503, 224702,
        223, 667, 668, 669, 670, 671, 672,
        157, 158, 1852, 3398, 3399, 3400, 3401, 3402, 3403, 3404, 8382, 227809, 227810,
        224701
      ) THEN 1
      ELSE 0
    END
  ) AS MechVent,

  -- Extubated
  MAX(
    CASE
      WHEN itemid IS NULL OR value IS NULL THEN 0
      WHEN itemid = 640 AND value IN ('Extubated', 'Self Extubation') THEN 1
      ELSE 0
    END
  ) AS Extubated,

  -- Self-extubated
  MAX(
    CASE
      WHEN itemid IS NULL OR value IS NULL THEN 0
      WHEN itemid = 640 AND value = 'Self Extubation' THEN 1
      ELSE 0
    END
  ) AS SelfExtubated

FROM `physionet-data.mimiciii_clinical.chartevents`
WHERE value IS NOT NULL
  AND itemid IN (
    640,
    720,
    467,
    445, 448, 449, 450, 1340, 1486, 1600, 224687,
    639, 654, 681, 682, 683, 684, 224685, 224684, 224686,
    218, 436, 535, 444, 459, 224697, 224695, 224696, 224746, 224747,
    221, 1, 1211, 1655, 2000, 226873, 224738, 224419, 224750, 227187,
    543,
    5865, 5866, 224707, 224709, 224705, 224706,
    60, 437, 505, 506, 686, 220339, 224700,
    3459,
    501, 502, 503, 224702,
    223, 667, 668, 669, 670, 671, 672,
    157, 158, 1852, 3398, 3399, 3400, 3401, 3402, 3403, 3404, 8382, 227809, 227810,
    224701
  )
GROUP BY icustay_id, charttime
ORDER BY icustay_id, charttime;
