SET @Month := '2025-02';     
SET @Batch := '%P01%';        
SELECT 
    Employee_Id,
    Emp_Name, 
    Project_code,
    Activity_ID, 
    round(SUM(Total_chain),2) as Miles,
    ROUND(SUM(work_time) / 3600, 2) AS Hours,
    ROUND(SUM(Total_chain) / NULLIF(ROUND(SUM(work_time) / 3600, 2), 0), 2) AS RunRate
FROM processlog
WHERE 
    DATE_FORMAT(DateOfProcess, '%Y-%m') = @Month
    AND Batch LIKE @Batch
and Activity_Id not in ('98','99')
and
GROUP BY 
    Employee_ID, Emp_Name, Project_code, Activity_ID, DATE_FORMAT(DateOfProcess, '%Y-%m')
ORDER BY RunRate DESC;