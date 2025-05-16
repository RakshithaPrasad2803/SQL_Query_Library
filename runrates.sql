SET @input_date = '2025-04-01';

SELECT 
    Employee_Id,
    Emp_Name,
    SUM(runrate) AS Total_runrate
FROM roadware_pts.employeedailyreport
WHERE DateOfProcess = @input_date
GROUP BY Employee_Id, Emp_Name, DateOfProcess;



SET @input_date = '2024-04-02';

SELECT 
    Project_Code,
    SUM(runrate) AS total_project_runrate
FROM roadware_pts.employeedailyreport
WHERE DateOfProcess = @input_date
GROUP BY Project_Code, DateOfProcess;
 