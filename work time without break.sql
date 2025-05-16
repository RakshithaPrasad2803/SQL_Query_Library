SET @date_var = '2025-03-28';

SELECT 
    p.Employee_Id,
    p.Emp_Name,
    MIN(p.Start_time) AS Start_Time,
    MAX(p.End_time) AS End_Time,
    ROUND(SUM(p.Work_Time) / 3600, 2) AS Work_Time

FROM processlog p
JOIN status s ON p.Status_ID = s.Status_ID
WHERE p.DateOfProcess = @date_var
  AND s.Status_Type != 'BREAK'
  AND p.Start_time IS NOT NULL
  AND p.End_time IS NOT NULL
GROUP BY p.Employee_Id, p.Emp_Name, p.DateOfProcess
ORDER BY Work_Time DESC;