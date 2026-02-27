CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.microbio AS
SELECT
  subject_id,
  hadm_id,
  UNIX_SECONDS(TIMESTAMP(charttime)) AS charttime,
  UNIX_SECONDS(TIMESTAMP(chartdate)) AS chartdate
FROM physionet-data.mimiciii_clinical.microbiologyevents;
