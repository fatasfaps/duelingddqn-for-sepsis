CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.preadm_fluid AS

WITH mv AS (
    SELECT
        ie.icustay_id,
        SUM(ie.amount) AS sum_mv
    FROM physionet-data.mimiciii_clinical.inputevents_mv ie
    JOIN physionet-data.mimiciii_clinical.d_items ci
      ON ie.itemid = ci.itemid
    WHERE ie.itemid IN (30054,30055,30101,30102,30103,30104,30105,30108,
                        226361,226363,226364,226365,226367,226368,226369,
                        226370,226371,226372,226375,226376,227070,227071,227072)
    GROUP BY icustay_id
),

cv AS (
    SELECT
        ie.icustay_id,
        SUM(ie.amount) AS sum_cv
    FROM physionet-data.mimiciii_clinical.inputevents_cv ie
    JOIN physionet-data.mimiciii_clinical.d_items ci
      ON ie.itemid = ci.itemid
    WHERE ie.itemid IN (30054,30055,30101,30102,30103,30104,30105,30108,
                        226361,226363,226364,226365,226367,226368,226369,
                        226370,226371,226372,226375,226376,227070,227071,227072)
    GROUP BY icustay_id
)

SELECT
    ic.icustay_id,
    CASE
        WHEN mv.sum_mv IS NOT NULL THEN mv.sum_mv
        WHEN cv.sum_cv IS NOT NULL THEN cv.sum_cv
        ELSE NULL
    END AS inputpreadm
FROM physionet-data.mimiciii_clinical.icustays ic
LEFT JOIN mv
    ON ic.icustay_id = mv.icustay_id
LEFT JOIN cv
    ON ic.icustay_id = cv.icustay_id
ORDER BY icustay_id;
