CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.uo AS
SELECT
    icustay_id,
    UNIX_SECONDS(TIMESTAMP(charttime)) AS charttime,
    itemid,
    value
FROM physionet-data.mimiciii_clinical.outputevents
WHERE icustay_id IS NOT NULL
  AND value IS NOT NULL
  AND itemid IN (
      40055,43175,40069,40094,40715,40473,40085,40057,40056,
      40405,40428,40096,40651,226559,226560,227510,226561,227489,
      226584,226563,226564,226565,226557,226558
  )
ORDER BY icustay_id, charttime, itemid;
