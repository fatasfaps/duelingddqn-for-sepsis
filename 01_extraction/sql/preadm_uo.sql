CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.preadm_uo AS
SELECT
    oe.icustay_id,
    UNIX_SECONDS(TIMESTAMP(oe.charttime)) AS charttime,
    oe.itemid,
    oe.value,
    TIMESTAMP_DIFF(ic.intime, oe.charttime, MINUTE) AS datediff_minutes
FROM physionet-data.mimiciii_clinical.outputevents AS oe
JOIN physionet-data.mimiciii_clinical.icustays AS ic
  ON oe.icustay_id = ic.icustay_id
WHERE oe.itemid IN (40060, 226633)
ORDER BY oe.icustay_id, charttime, oe.itemid;
