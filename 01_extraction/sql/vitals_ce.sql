CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.ce90100 AS
WITH numbered AS (
  SELECT DISTINCT
      icustay_id,
      UNIX_SECONDS(TIMESTAMP(charttime)) AS charttime,
      itemid,
      CASE
          WHEN value = 'None' THEN CAST(0 AS FLOAT64)
          WHEN value = 'Ventilator' THEN CAST(1 AS FLOAT64)
          WHEN value = 'Cannula' THEN CAST(2 AS FLOAT64)
          WHEN value = 'Nasal Cannula' THEN CAST(2 AS FLOAT64)
          WHEN value = 'Face Tent' THEN CAST(3 AS FLOAT64)
          WHEN value = 'Aerosol-Cool' THEN CAST(4 AS FLOAT64)
          WHEN value = 'Trach Mask' THEN CAST(5 AS FLOAT64)
          WHEN value = 'Hi Flow Neb' THEN CAST(6 AS FLOAT64)
          WHEN value = 'Non-Rebreather' THEN CAST(7 AS FLOAT64)
          WHEN value = '' THEN CAST(8 AS FLOAT64)
          WHEN value = 'Venti Mask' THEN CAST(9 AS FLOAT64)
          WHEN value = 'Medium Conc Mask' THEN CAST(10 AS FLOAT64)
          ELSE CAST(valuenum AS FLOAT64)
      END AS valuenum,
      ROW_NUMBER() OVER (ORDER BY charttime) AS rn,
      COUNT(*) OVER() AS total_rows
  FROM physionet-data.mimiciii_clinical.chartevents
  WHERE value IS NOT NULL
    AND itemid IN (
        467, 470,471,223834,227287,194,224691,226707,226730,581,580,
        224639,226512,198,228096,211,220045,220179,225309,6701,6,227243,
        224167,51,455,220181,220052,225312,224322,6702,443,52,456,8368,
        8441,225310,8555,8440,220210,3337,224422,618,3603,615,220277,646,
        834,3655,223762,223761,678,220074,113,492,491,8448,116,1372,1366,
        228368,228177,626,223835,3420,160,727,190,220339,506,505,224700,
        224686,224684,684,224421,224687,450,448,445,224697,444,224695,535,
        224696,543,3083,2566,654,3050,681,2311
    )
)
SELECT icustay_id, charttime, itemid, valuenum
FROM numbered
WHERE rn BETWEEN FLOOR(total_rows/10)*9 + 1 AND FLOOR(total_rows/10)*11
ORDER BY charttime;
