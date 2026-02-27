CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.vaso_cv AS

SELECT
    icustay_id,
    itemid,
    UNIX_SECONDS(TIMESTAMP(charttime)) AS charttime,
    CASE
        WHEN itemid IN (30120,221906,30047) AND rateuom='mcgkgmin' THEN ROUND(CAST(rate AS FLOAT64),3) -- norad
        WHEN itemid IN (30120,221906,30047) AND rateuom='mcgmin' THEN ROUND(CAST(rate/80 AS FLOAT64),3) -- norad
        WHEN itemid IN (30119,221289) AND rateuom='mcgkgmin' THEN ROUND(CAST(rate AS FLOAT64),3) -- epi
        WHEN itemid IN (30119,221289) AND rateuom='mcgmin' THEN ROUND(CAST(rate/80 AS FLOAT64),3) -- epi
        WHEN itemid IN (30051,222315) AND rate > 0.2 THEN ROUND(CAST(rate*5/60 AS FLOAT64),3) -- vasopressin, U/h
        WHEN itemid IN (30051,222315) AND rateuom='Umin' AND rate <= 0.2 THEN ROUND(CAST(rate*5 AS FLOAT64),3) -- vasopressin
        WHEN itemid IN (30051,222315) AND rateuom='Uhr' THEN ROUND(CAST(rate*5/60 AS FLOAT64),3) -- vasopressin
        WHEN itemid IN (30128,221749,30127) AND rateuom='mcgkgmin' THEN ROUND(CAST(rate*0.45 AS FLOAT64),3) -- phenyl
        WHEN itemid IN (30128,221749,30127) AND rateuom='mcgmin' THEN ROUND(CAST(rate*0.45/80 AS FLOAT64),3) -- phenyl
        WHEN itemid IN (221662,30043,30307) AND rateuom='mcgkgmin' THEN ROUND(CAST(rate*0.01 AS FLOAT64),3) -- dopa
        WHEN itemid IN (221662,30043,30307) AND rateuom='mcgmin' THEN ROUND(CAST(rate*0.01/80 AS FLOAT64),3) -- dopa
        ELSE NULL
    END AS rate_std
FROM physionet-data.mimiciii_clinical.inputevents_cv
WHERE itemid IN (30128,30120,30051,221749,221906,30119,30047,30127,221289,222315,221662,30043,30307)
  AND rate IS NOT NULL
ORDER BY icustay_id, itemid, charttime;
