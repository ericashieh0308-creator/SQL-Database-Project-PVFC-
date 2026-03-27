Q1. Find number of doctors who work at hospitals in New York state.
SELECT COUNT(DISTINCT d.doc_id) AS no_of_doctors
FROM yh_doctor d
JOIN yh_hospital h
    ON d.hos_id = h.hos_id
WHERE h.h_state = 'New York';


Q2. Find doctor id who has treated more than 3 diseases. Arrange result in ascending order of doctor id.
SELECT doc_id
FROM yh_doc_dis_pat
GROUP BY doc_id
HAVING COUNT(DISTINCT disease_id) > 3
ORDER BY doc_id;


Q3. Find doctor id, first name, and last name for doctors who have treated more than 3 diseases. Arrange result in descending order of doctor id.
SELECT d.doc_id, d.d_fname, d.d_lname
FROM yh_doctor d
WHERE d.doc_id IN (
    SELECT doc_id
    FROM yh_doc_dis_pat
    GROUP BY doc_id
    HAVING COUNT(DISTINCT disease_id) > 3
)
ORDER BY d.doc_id DESC;


Q4. Find patient id, first name, last name, month and year of birth for patients born after year 2006. Arrange the result in ascending order of first name.
SELECT pat_id,
       p_fname,
       p_lname,
       DATE_FORMAT(dob, '%M') AS birth_month,
       DATE_FORMAT(dob, '%Y') AS birth_year
FROM yh_patient
WHERE YEAR(dob) > 2006
ORDER BY p_fname;


Q5. Find disease id and doctor id wise number of treatments for groups where the number of treatments is more than three.
SELECT disease_id,
       doc_id,
       COUNT(*) AS no_of_treatments
FROM yh_doc_dis_pat
GROUP BY disease_id, doc_id
HAVING COUNT(*) > 3;


Q6. Find number of patients grouped by marital status and blood group. Arrange results in ascending order of marital status and descending order of blood group.
SELECT marital_status,
       blood_grp,
       COUNT(*) AS no_of_patients
FROM yh_patient
GROUP BY marital_status, blood_grp
ORDER BY marital_status ASC,
         blood_grp DESC;


Q7. Create an in-line view (subquery in FROM clause).
SELECT d.doc_id,
       d.d_fname,
       d.d_lname,
       t.total_treatments
FROM yh_doctor d
JOIN (
    SELECT doc_id,
           COUNT(*) AS total_treatments
    FROM yh_doc_dis_pat
    GROUP BY doc_id
) t
    ON d.doc_id = t.doc_id
ORDER BY t.total_treatments DESC;


Q8. Write a SQL using ROLLUP function.
SELECT marital_status,
       blood_grp,
       COUNT(*) AS no_of_patients
FROM yh_patient
GROUP BY marital_status, blood_grp WITH ROLLUP;


Q9. Write a query using RANK function.
SELECT t.doc_id,
       t.total_treatments,
       RANK() OVER (ORDER BY t.total_treatments DESC) AS treatment_rank
FROM (
    SELECT doc_id,
           COUNT(*) AS total_treatments
    FROM yh_doc_dis_pat
    GROUP BY doc_id
) t;


Q10. Write a query using CASE statement.
SELECT pat_id,
       p_fname,
       p_lname,
       ROUND(DATEDIFF(CURDATE(), dob) / 365) AS age,
       CASE
           WHEN DATEDIFF(CURDATE(), dob) / 365 > 60 THEN 'Senior'
           WHEN DATEDIFF(CURDATE(), dob) / 365 BETWEEN 18 AND 60 THEN 'Adult'
           ELSE 'Child'
       END AS age_group
FROM yh_patient;
