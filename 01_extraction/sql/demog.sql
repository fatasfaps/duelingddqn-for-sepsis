CREATE OR REPLACE TABLE skripsi-fatas-mimic3.mimic3.demog AS
SELECT
    ad.subject_id,
    ad.hadm_id,
    i.icustay_id,

    UNIX_SECONDS(TIMESTAMP(ad.admittime)) AS admittime,
    UNIX_SECONDS(TIMESTAMP(ad.dischtime)) AS dischtime,

    ROW_NUMBER() OVER (PARTITION BY ad.subject_id ORDER BY i.intime ASC) AS adm_order,

    CASE
        WHEN i.first_careunit='NICU'  THEN 5
        WHEN i.first_careunit='SICU'  THEN 2
        WHEN i.first_careunit='CSRU'  THEN 4
        WHEN i.first_careunit='CCU'   THEN 6
        WHEN i.first_careunit='MICU'  THEN 1
        WHEN i.first_careunit='TSICU' THEN 3
    END AS unit,

    UNIX_SECONDS(TIMESTAMP(i.intime)) AS intime,
    UNIX_SECONDS(TIMESTAMP(i.outtime)) AS outtime,
    i.los,

    -- age in years, capped at 90
    CASE
        WHEN TIMESTAMP_DIFF(i.intime, p.dob, DAY) / 365.242 > 89
        THEN 90
        ELSE FLOOR(TIMESTAMP_DIFF(i.intime, p.dob, DAY) / 365.242)
    END AS age,

    UNIX_SECONDS(TIMESTAMP(p.dob)) AS dob,
    UNIX_SECONDS(TIMESTAMP(p.dod)) AS dod,

    p.expire_flag,

    CASE WHEN p.gender='M' THEN 1 WHEN p.gender='F' THEN 2 END AS gender,

    -- died in hosp if recorded DOD is within 24h of discharge
    CAST(TIMESTAMP_DIFF(p.dod, ad.dischtime, SECOND) <= 24*3600 AS INT64) AS morta_hosp,

    -- died within 90 days of ICU admission
    CAST(TIMESTAMP_DIFF(p.dod, i.intime, SECOND) <= 90*24*3600 AS INT64) AS morta_90,

    -- Elixhauser comorbidity sum
    (congestive_heart_failure + cardiac_arrhythmias + valvular_disease +
     pulmonary_circulation + peripheral_vascular + hypertension + paralysis +
     other_neurological + chronic_pulmonary + diabetes_uncomplicated +
     diabetes_complicated + hypothyroidism + renal_failure + liver_disease +
     peptic_ulcer + aids + lymphoma + metastatic_cancer + solid_tumor +
     rheumatoid_arthritis + coagulopathy + obesity + weight_loss +
     fluid_electrolyte + blood_loss_anemia + deficiency_anemias +
     alcohol_abuse + drug_abuse + psychoses + depression) AS elixhauser

FROM physionet-data.mimiciii_clinical.admissions ad
JOIN physionet-data.mimiciii_clinical.icustays i ON ad.hadm_id = i.hadm_id
JOIN physionet-data.mimiciii_clinical.patients p ON p.subject_id = i.subject_id
JOIN physionet-data.mimiciii_derived.elixhauser_quan elix ON elix.hadm_id = ad.hadm_id

ORDER BY subject_id ASC, intime ASC;
