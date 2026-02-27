CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.labs_le AS
WITH xx AS (
  SELECT DISTINCT
      subject_id,
      hadm_id,
      icustay_id,
      intime,
      outtime
  FROM physionet-data.mimiciii_clinical.icustays
)
SELECT
    xx.icustay_id,
    UNIX_SECONDS(TIMESTAMP(f.charttime)) AS timestp,
    f.itemid,
    f.valuenum
FROM xx
INNER JOIN physionet-data.mimiciii_clinical.labevents AS f
    ON f.hadm_id = xx.hadm_id
   AND f.charttime >= TIMESTAMP_SUB(xx.intime, INTERVAL 1 DAY)
   AND f.charttime <= TIMESTAMP_ADD(xx.outtime, INTERVAL 1 DAY)
WHERE f.itemid IN (
    50971,50822,50824,50806,50931,51081,50885,51003,51222,50810,51301,50983,50902,50809,51006,
    50912,50960,50893,50808,50804,50878,50861,51464,50883,50976,50862,51002,50889,50811,
    51221,51279,51300,51265,51275,51274,51237,50820,50821,50818,50802,50813,50882,50803
)
AND f.valuenum IS NOT NULL
ORDER BY f.hadm_id, timestp, f.itemid;
