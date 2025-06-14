DROP TABLE IF EXISTS Emp_Runrate_Report;

CREATE TABLE Emp_Runrate_Report (
    Employee_Id VARCHAR(50),
    Emp_Name VARCHAR(100),
    Project_code VARCHAR(50),
    Month VARCHAR(7),

    -- dis_P01
    dis_P01_Miles DECIMAL(10,2),
    dis_P01_Hrs DECIMAL(10,2),
    dis_P01_Runrate DECIMAL(10,2),

    -- aud_Dis (P01 Audit)
    aud_Dis_Miles DECIMAL(10,2),
    aud_Dis_Hrs DECIMAL(10,2),
    aud_Dis_Runrate DECIMAL(10,2),

    -- Rework_Dis (P01 Rework)
    Rework_Dis_Miles DECIMAL(10,2),
    Rework_Dis_Hrs DECIMAL(10,2),
    Rework_Dis_Runrate DECIMAL(10,2),

    -- dis_RCK
    dis_RCK_Miles DECIMAL(10,2),
    dis_RCK_Hrs DECIMAL(10,2),
    dis_RCK_Runrate DECIMAL(10,2),

    -- dis_Y2Y
    dis_Y2Y_Miles DECIMAL(10,2),
    dis_Y2Y_Hrs DECIMAL(10,2),
    dis_Y2Y_Runrate DECIMAL(10,2),

    -- dis_RWK
    dis_RWK_Miles DECIMAL(10,2),
    dis_RWK_Hrs DECIMAL(10,2),
    dis_RWK_Runrate DECIMAL(10,2),

    -- dis_A01
    dis_A01_Miles DECIMAL(10,2),
    dis_A01_Hrs DECIMAL(10,2),
    dis_A01_Runrate DECIMAL(10,2),

    -- Lcms_C01
    Lcms_C01_Miles DECIMAL(10,2),
    Lcms_C01_Hrs DECIMAL(10,2),
    Lcms_C01_Runrate DECIMAL(10,2),

    -- Lcms_RWK
    Lcms_RWK_Miles DECIMAL(10,2),
    Lcms_RWK_Hrs DECIMAL(10,2),
    Lcms_RWK_Runrate DECIMAL(10,2),

    -- Lcms_RCK
    Lcms_RCK_Miles DECIMAL(10,2),
    Lcms_RCK_Hrs DECIMAL(10,2),
    Lcms_RCK_Runrate DECIMAL(10,2),

    -- Lcms_A01
    Lcms_A01_Miles DECIMAL(10,2),
    Lcms_A01_Hrs DECIMAL(10,2),
    Lcms_A01_Runrate DECIMAL(10,2),

    -- Events_prod
    Events_prod_Miles DECIMAL(10,2),
    Events_prod_Hrs DECIMAL(10,2),
    Events_prod_Runrate DECIMAL(10,2),

    -- Events_aud
    Events_aud_Miles DECIMAL(10,2),
    Events_aud_Hrs DECIMAL(10,2),
    Events_aud_Runrate DECIMAL(10,2),

    -- Events_Y2Y
    Events_Y2Y_Miles DECIMAL(10,2),
    Events_Y2Y_Hrs DECIMAL(10,2),
    Events_Y2Y_Runrate DECIMAL(10,2),

    -- Events_Rework
    Events_Rework_Miles DECIMAL(10,2),
    Events_Rework_Hrs DECIMAL(10,2),
    Events_Rework_Runrate DECIMAL(10,2),

    -- Events_E01
    Events_E01_Miles DECIMAL(10,2),
    Events_E01_Hrs DECIMAL(10,2),
    Events_E01_Runrate DECIMAL(10,2),

    -- Events_RWK 
    Events_RWK_Miles DECIMAL(10,2),
    Events_RWK_Hrs DECIMAL(10,2),
    Events_RWK_Runrate DECIMAL(10,2),

    -- Events_RCK 
    Events_RCK_Miles DECIMAL(10,2),
    Events_RCK_Hrs DECIMAL(10,2),
    Events_RCK_Runrate DECIMAL(10,2),

    -- SHLD_prod
    SHLD_prod_Miles DECIMAL(10,2),
    SHLD_prod_Hrs DECIMAL(10,2),
    SHLD_prod_Runrate DECIMAL(10,2),

    -- SHLD_aud 
    SHLD_aud_Miles DECIMAL(10,2),
    SHLD_aud_Hrs DECIMAL(10,2),
    SHLD_aud_Runrate DECIMAL(10,2),

    -- SHLD_Y2Y
    SHLD_Y2Y_Miles DECIMAL(10,2),
    SHLD_Y2Y_Hrs DECIMAL(10,2),
    SHLD_Y2Y_Runrate DECIMAL(10,2),

    -- SHLD_Rework 
    SHLD_Rework_Miles DECIMAL(10,2),
    SHLD_Rework_Hrs DECIMAL(10,2),
    SHLD_Rework_Runrate DECIMAL(10,2),

    -- SHLD_RWK 
    SHLD_RWK_Miles DECIMAL(10,2),
    SHLD_RWK_Hrs DECIMAL(10,2),
    SHLD_RWK_Runrate DECIMAL(10,2),

    -- SHLD_RCK 
    SHLD_RCK_Miles DECIMAL(10,2),
    SHLD_RCK_Hrs DECIMAL(10,2),
    SHLD_RCK_Runrate DECIMAL(10,2),

    -- SHLD_S01
    SHLD_S01_Miles DECIMAL(10,2),
    SHLD_S01_Hrs DECIMAL(10,2),
    SHLD_S01_Runrate DECIMAL(10,2),

    -- Others_Rework
    Others_Rework_Miles DECIMAL(10,2),
    Others_Rework_Hrs DECIMAL(10,2),
    Others_Rework_Runrate DECIMAL(10,2),

    -- FQA
    FQA_Hrs DECIMAL(10,2),

    -- IPR
    IPR_Hrs DECIMAL(10,2),

    -- Meeting
    Meeting_Hrs DECIMAL(10,2),

    -- Training
    Training_Hrs DECIMAL(10,2),

    PRIMARY KEY (Employee_Id, Project_code, Month)
);



DELIMITER $$

DROP PROCEDURE IF EXISTS `roadware_pts`.`Get_Emp_Runrate_Report`$$

CREATE DEFINER=`pts`@`%` PROCEDURE `Get_Emp_Runrate_Report`(IN p_TargetMonth VARCHAR(7))
BEGIN
    -- Set session character set and collation to ensure consistent handling of literals and variables
    -- This is crucial to prevent implicit Latin1 interpretation.
    SET NAMES 'utf8' COLLATE 'utf8_general_ci';
    SET CHARACTER SET 'utf8';
    SET COLLATION_CONNECTION = 'utf8_general_ci';

    -- Convert input parameter immediately to ensure it's UTF8 for all subsequent uses
    SET @TargetMonth = CONVERT(p_TargetMonth USING utf8) COLLATE utf8_general_ci;
    SET @ThisMonthHR = CONVERT(DATE_FORMAT(STR_TO_DATE(@TargetMonth, '%Y-%m'), '%b-%y') USING utf8) COLLATE utf8_general_ci;

    -- Delete existing data for the target month.
   
    DELETE FROM Emp_Runrate_Report
    WHERE `Month` IN (@TargetMonth,@ThisMonthHR)

    -- *** OPTIMIZATION: Create a single combined and pre-filtered temporary table for process logs ***
    DROP TEMPORARY TABLE IF EXISTS temp_combined_processlog;
    CREATE TEMPORARY TABLE temp_combined_processlog (
        Employee_Id VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
        Emp_Name VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_general_ci,
        Project_code VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
        Activity_id VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci,
        Batch VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci, -- Assuming Batch can be longer
        Work_Time DECIMAL(10,2),
        Total_Chain DECIMAL(10,2),
        ProcessMonth VARCHAR(7) CHARACTER SET utf8 COLLATE utf8_general_ci
    );

    -- Insert data into the temporary table. 
    INSERT INTO temp_combined_processlog
    SELECT
        CONVERT(p.Employee_Id USING utf8),
        CONVERT(p.Emp_Name USING utf8),
        CONVERT(p.Project_code USING utf8),
        CONVERT(p.Activity_id USING utf8),
        CONVERT(p.Batch USING utf8),
        p.Work_Time,
        p.Total_Chain,
        CONVERT(DATE_FORMAT(p.DateOfProcess, '%Y-%m') USING utf8)
    FROM (
        SELECT * FROM processlog
        UNION ALL
        SELECT * FROM backup_processlog
    ) AS p -- Alias for combined processlog
    WHERE CONVERT(DATE_FORMAT(p.DateOfProcess, '%Y-%m') USING utf8) = @TargetMonth -- Compare against utf8 @TargetMonth
        AND CONVERT(p.Project_code USING utf8) != 'BREAK'; -- Convert Project_code to utf8 and compare to utf8 literal

    -- Add indexes to the temporary table for efficient joining
    CREATE INDEX idx_temp_processlog ON temp_combined_processlog (Employee_Id, Project_code, ProcessMonth, Activity_id, Batch);

    -- Drop and recreate the temporary table for base employees (now using the combined temp table)
    DROP TEMPORARY TABLE IF EXISTS base_employees;
    CREATE TEMPORARY TABLE base_employees AS
    SELECT
        temp.Employee_Id,
        MIN(temp.Emp_Name) AS Emp_Name,
        temp.Project_code,
        temp.ProcessMonth AS Month_YYYYMM
    FROM temp_combined_processlog AS temp
    GROUP BY temp.Employee_Id,temp.Project_code, temp.ProcessMonth;

    -- Insert into Emp_Runrate_Report
    INSERT INTO Emp_Runrate_Report (Employee_Id, Emp_Name, Project_code, `Month`)
    SELECT Employee_Id, Emp_Name, Project_code, Month_YYYYMM FROM base_employees;

    -- --- Update blocks: All subqueries for various metrics now use temp_combined_processlog ---
    -- The WHERE clauses here are simplified as temp_combined_processlog columns are already UTF8.
    -- String literals will implicitly be handled by MySQL for comparison against UTF8 columns.

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS dis_P01_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS dis_P01_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS dis_P01_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%P01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) p01
    ON r.Employee_Id = p01.Employee_Id
    AND r.Project_code = p01.Project_code
    AND r.`Month` = p01.ProcessMonth
    SET r.dis_P01_Miles = COALESCE(p01.dis_P01_Miles, 0.00),
        r.dis_P01_Hrs = COALESCE(p01.dis_P01_Hrs, 0.00),
        r.dis_P01_Runrate = COALESCE(p01.dis_P01_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS aud_Dis_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS aud_Dis_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS aud_Dis_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2'
            AND temp.Batch LIKE '%P01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) aud
    ON r.Employee_Id = aud.Employee_Id
    AND r.Project_code = aud.Project_code
    AND r.`Month` = aud.ProcessMonth
    SET r.aud_Dis_Miles = COALESCE(aud.aud_Dis_Miles, 0.00),
        r.aud_Dis_Hrs = COALESCE(aud.aud_Dis_Hrs, 0.00),
        r.aud_Dis_Runrate = COALESCE(aud.aud_Dis_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Rework_Dis_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Rework_Dis_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Rework_Dis_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '4'
            AND temp.Batch LIKE '%P01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) rwk
    ON r.Employee_Id = rwk.Employee_Id
    AND r.Project_code = rwk.Project_code
    AND r.`Month` = rwk.ProcessMonth
    SET r.Rework_Dis_Miles = COALESCE(rwk.Rework_Dis_Miles, 0.00),
        r.Rework_Dis_Hrs = COALESCE(rwk.Rework_Dis_Hrs, 0.00),
        r.Rework_Dis_Runrate = COALESCE(rwk.Rework_Dis_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS dis_RCK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS dis_RCK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS dis_RCK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Batch LIKE '%RCK%'
            AND temp.Batch NOT LIKE '%LCMS_RCK%'
            AND temp.Batch NOT LIKE '%Events_RCK%'
            AND temp.Batch NOT LIKE '%SHLD_RCK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) rck
    ON r.Employee_Id = rck.Employee_Id
    AND r.Project_code = rck.Project_code
    AND r.`Month` = rck.ProcessMonth
    SET r.dis_RCK_Miles = COALESCE(rck.dis_RCK_Miles, 0.00),
        r.dis_RCK_Hrs = COALESCE(rck.dis_RCK_Hrs, 0.00),
        r.dis_RCK_Runrate = COALESCE(rck.dis_RCK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS dis_Y2Y_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS dis_Y2Y_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS dis_Y2Y_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%Y2Y%'
            AND temp.Batch NOT LIKE '%Events_Y2Y%'
            AND temp.Batch NOT LIKE '%LCMS_Y2Y%'
            AND temp.Batch NOT LIKE '%SHLD_Y2Y%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) y2y
    ON r.Employee_Id = y2y.Employee_Id
    AND r.Project_code = y2y.Project_code
    AND r.`Month` = y2y.ProcessMonth
    SET r.dis_Y2Y_Miles = COALESCE(y2y.dis_Y2Y_Miles, 0.00),
        r.dis_Y2Y_Hrs = COALESCE(y2y.dis_Y2Y_Hrs, 0.00),
        r.dis_Y2Y_Runrate = COALESCE(y2y.dis_Y2Y_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS dis_RWK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS dis_RWK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS dis_RWK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%RWK%'
            AND temp.Batch NOT LIKE '%LCMS_RWK%'
            AND temp.Batch NOT LIKE '%Events_RWK%'
            AND temp.Batch NOT LIKE '%SHLD_RWK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) rwk_dis
    ON r.Employee_Id = rwk_dis.Employee_Id
    AND r.Project_code = rwk_dis.Project_code
    AND r.`Month` = rwk_dis.ProcessMonth
    SET r.dis_RWK_Miles = COALESCE(rwk_dis.dis_RWK_Miles, 0.00),
        r.dis_RWK_Hrs = COALESCE(rwk_dis.dis_RWK_Hrs, 0.00),
        r.dis_RWK_Runrate = COALESCE(rwk_dis.dis_RWK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS dis_A01_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS dis_A01_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS dis_A01_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2'
            AND temp.Batch LIKE '%A01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) a01_dis
    ON r.Employee_Id = a01_dis.Employee_Id
    AND r.Project_code = a01_dis.Project_code
    AND r.`Month` = a01_dis.ProcessMonth
    SET r.dis_A01_Miles = COALESCE(a01_dis.dis_A01_Miles, 0.00),
        r.dis_A01_Hrs = COALESCE(a01_dis.dis_A01_Hrs, 0.00),
        r.dis_A01_Runrate = COALESCE(a01_dis.dis_A01_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Lcms_C01_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Lcms_C01_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Lcms_C01_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%C01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) c01_lcms
    ON r.Employee_Id = c01_lcms.Employee_Id
    AND r.Project_code = c01_lcms.Project_code
    AND r.`Month` = c01_lcms.ProcessMonth
    SET r.Lcms_C01_Miles = COALESCE(c01_lcms.Lcms_C01_Miles, 0.00),
        r.Lcms_C01_Hrs = COALESCE(c01_lcms.Lcms_C01_Hrs, 0.00),
        r.Lcms_C01_Runrate = COALESCE(c01_lcms.Lcms_C01_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Lcms_RWK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Lcms_RWK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Lcms_RWK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%LCMS_RWK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) rwk_lcms
    ON r.Employee_Id = rwk_lcms.Employee_Id
    AND r.Project_code = rwk_lcms.Project_code
    AND r.`Month` = rwk_lcms.ProcessMonth
    SET r.Lcms_RWK_Miles = COALESCE(rwk_lcms.Lcms_RWK_Miles, 0.00),
        r.Lcms_RWK_Hrs = COALESCE(rwk_lcms.Lcms_RWK_Hrs, 0.00),
        r.Lcms_RWK_Runrate = COALESCE(rwk_lcms.Lcms_RWK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Lcms_RCK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Lcms_RCK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Lcms_RCK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Batch LIKE '%LCMS_RCK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) rck_lcms
    ON r.Employee_Id = rck_lcms.Employee_Id
    AND r.Project_code = rck_lcms.Project_code
    AND r.`Month` = rck_lcms.ProcessMonth
    SET r.Lcms_RCK_Miles = COALESCE(rck_lcms.Lcms_RCK_Miles, 0.00),
        r.Lcms_RCK_Hrs = COALESCE(rck_lcms.Lcms_RCK_Hrs, 0.00),
        r.Lcms_RCK_Runrate = COALESCE(rck_lcms.Lcms_RCK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Lcms_A01_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Lcms_A01_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Lcms_A01_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2'
            AND temp.Batch LIKE '%LCMS_A01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) a01_lcms
    ON r.Employee_Id = a01_lcms.Employee_Id
    AND r.Project_code = a01_lcms.Project_code
    AND r.`Month` = a01_lcms.ProcessMonth
    SET r.Lcms_A01_Miles = COALESCE(a01_lcms.Lcms_A01_Miles, 0.00),
        r.Lcms_A01_Hrs = COALESCE(a01_lcms.Lcms_A01_Hrs, 0.00),
        r.Lcms_A01_Runrate = COALESCE(a01_lcms.Lcms_A01_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_prod_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_prod_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_prod_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%Events%'
            AND temp.Batch NOT LIKE '%Events_Y2Y%'
            AND temp.Batch NOT LIKE '%Events_RCK%'
            AND temp.Batch NOT LIKE '%Events_RWK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) events_prod
    ON r.Employee_Id = events_prod.Employee_Id
    AND r.Project_code = events_prod.Project_code
    AND r.`Month` = events_prod.ProcessMonth
    SET r.Events_prod_Miles = COALESCE(events_prod.Events_prod_Miles, 0.00),
        r.Events_prod_Hrs = COALESCE(events_prod.Events_prod_Hrs, 0.00),
        r.Events_prod_Runrate = COALESCE(events_prod.Events_prod_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_aud_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_aud_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_aud_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2'
            AND temp.Batch LIKE '%Events%'
            AND temp.Batch NOT LIKE '%Events_RCK%'
            AND temp.Batch NOT LIKE '%Events_RWK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) events_aud
    ON r.Employee_Id = events_aud.Employee_Id
    AND r.Project_code = events_aud.Project_code
    AND r.`Month` = events_aud.ProcessMonth
    SET r.Events_aud_Miles = COALESCE(events_aud.Events_aud_Miles, 0.00),
        r.Events_aud_Hrs = COALESCE(events_aud.Events_aud_Hrs, 0.00),
        r.Events_aud_Runrate = COALESCE(events_aud.Events_aud_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_Y2Y_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_Y2Y_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_Y2Y_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%Events_Y2Y%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) events_y2y
    ON r.Employee_Id = events_y2y.Employee_Id
    AND r.Project_code = events_y2y.Project_code
    AND r.`Month` = events_y2y.ProcessMonth
    SET r.Events_Y2Y_Miles = COALESCE(events_y2y.Events_Y2Y_Miles, 0.00),
        r.Events_Y2Y_Hrs = COALESCE(events_y2y.Events_Y2Y_Hrs, 0.00),
        r.Events_Y2Y_Runrate = COALESCE(events_y2y.Events_Y2Y_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_Rework_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_Rework_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_Rework_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '4'
            AND temp.Batch LIKE '%Events%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) events_rework
    ON r.Employee_Id = events_rework.Employee_Id
    AND r.Project_code = events_rework.Project_code
    AND r.`Month` = events_rework.ProcessMonth
    SET r.Events_Rework_Miles = COALESCE(events_rework.Events_Rework_Miles, 0.00),
        r.Events_Rework_Hrs = COALESCE(events_rework.Events_Rework_Hrs, 0.00),
        r.Events_Rework_Runrate = COALESCE(events_rework.Events_Rework_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_E01_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_E01_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_E01_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2'
            AND temp.Batch LIKE '%E01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) e01_events
    ON r.Employee_Id = e01_events.Employee_Id
    AND r.Project_code = e01_events.Project_code
    AND r.`Month` = e01_events.ProcessMonth
    SET r.Events_E01_Miles = COALESCE(e01_events.Events_E01_Miles, 0.00),
        r.Events_E01_Hrs = COALESCE(e01_events.Events_E01_Hrs, 0.00),
        r.Events_E01_Runrate = COALESCE(e01_events.Events_E01_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_RWK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_RWK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_RWK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1' 
            AND temp.Batch LIKE '%Events_RWK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) events_rwk_specific
    ON r.Employee_Id = events_rwk_specific.Employee_Id
    AND r.Project_code = events_rwk_specific.Project_code
    AND r.`Month` = events_rwk_specific.ProcessMonth
    SET r.Events_RWK_Miles = COALESCE(events_rwk_specific.Events_RWK_Miles, 0.00),
        r.Events_RWK_Hrs = COALESCE(events_rwk_specific.Events_RWK_Hrs, 0.00),
        r.Events_RWK_Runrate = COALESCE(events_rwk_specific.Events_RWK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Events_RCK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Events_RCK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Events_RCK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Batch LIKE '%Events_RCK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) events_rck_specific
    ON r.Employee_Id = events_rck_specific.Employee_Id
    AND r.Project_code = events_rck_specific.Project_code
    AND r.`Month` = events_rck_specific.ProcessMonth
    SET r.Events_RCK_Miles = COALESCE(events_rck_specific.Events_RCK_Miles, 0.00),
        r.Events_RCK_Hrs = COALESCE(events_rck_specific.Events_RCK_Hrs, 0.00),
        r.Events_RCK_Runrate = COALESCE(events_rck_specific.Events_RCK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_prod_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_prod_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_prod_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%SHLD%'
            AND temp.Batch NOT LIKE '%SHLD_Y2Y%'
            AND temp.Batch NOT LIKE '%SHLD_RWK%' 
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) shld_prod
    ON r.Employee_Id = shld_prod.Employee_Id
    AND r.Project_code = shld_prod.Project_code
    AND r.`Month` = shld_prod.ProcessMonth
    SET r.SHLD_prod_Miles = COALESCE(shld_prod.SHLD_prod_Miles, 0.00),
        r.SHLD_prod_Hrs = COALESCE(shld_prod.SHLD_prod_Hrs, 0.00),
        r.SHLD_prod_Runrate = COALESCE(shld_prod.SHLD_prod_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_aud_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_aud_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_aud_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2'
            AND temp.Batch LIKE '%SHLD%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) shld_aud
    ON r.Employee_Id = shld_aud.Employee_Id
    AND r.Project_code = shld_aud.Project_code
    AND r.`Month` = shld_aud.ProcessMonth
    SET r.SHLD_aud_Miles = COALESCE(shld_aud.SHLD_aud_Miles, 0.00),
        r.SHLD_aud_Hrs = COALESCE(shld_aud.SHLD_aud_Hrs, 0.00),
        r.SHLD_aud_Runrate = COALESCE(shld_aud.SHLD_aud_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_Y2Y_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_Y2Y_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_Y2Y_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1'
            AND temp.Batch LIKE '%SHLD_Y2Y%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) shld_y2y
    ON r.Employee_Id = shld_y2y.Employee_Id
    AND r.Project_code = shld_y2y.Project_code
    AND r.`Month` = shld_y2y.ProcessMonth
    SET r.SHLD_Y2Y_Miles = COALESCE(shld_y2y.SHLD_Y2Y_Miles, 0.00),
        r.SHLD_Y2Y_Hrs = COALESCE(shld_y2y.SHLD_Y2Y_Hrs, 0.00),
        r.SHLD_Y2Y_Runrate = COALESCE(shld_y2y.SHLD_Y2Y_Runrate, 0.00);

    -- New/Corrected block for SHLD_Rework
    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_Rework_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_Rework_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_Rework_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '4' -- Activity ID for Rework
            AND temp.Batch LIKE '%SHLD%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) shld_rework
    ON r.Employee_Id = shld_rework.Employee_Id
    AND r.Project_code = shld_rework.Project_code
    AND r.`Month` = shld_rework.ProcessMonth
    SET r.SHLD_Rework_Miles = COALESCE(shld_rework.SHLD_Rework_Miles, 0.00),
        r.SHLD_Rework_Hrs = COALESCE(shld_rework.SHLD_Rework_Hrs, 0.00),
        r.SHLD_Rework_Runrate = COALESCE(shld_rework.SHLD_Rework_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_RWK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_RWK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_RWK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '1' -- Assuming production activity for this specific RWK
            AND temp.Batch LIKE '%SHLD_RWK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) shld_rwk_specific
    ON r.Employee_Id = shld_rwk_specific.Employee_Id
    AND r.Project_code = shld_rwk_specific.Project_code
    AND r.`Month` = shld_rwk_specific.ProcessMonth
    SET r.SHLD_RWK_Miles = COALESCE(shld_rwk_specific.SHLD_RWK_Miles, 0.00),
        r.SHLD_RWK_Hrs = COALESCE(shld_rwk_specific.SHLD_RWK_Hrs, 0.00),
        r.SHLD_RWK_Runrate = COALESCE(shld_rwk_specific.SHLD_RWK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_RCK_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_RCK_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_RCK_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Batch LIKE '%SHLD_RCK%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) shld_rck_specific
    ON r.Employee_Id = shld_rck_specific.Employee_Id
    AND r.Project_code = shld_rck_specific.Project_code
    AND r.`Month` = shld_rck_specific.ProcessMonth
    SET r.SHLD_RCK_Miles = COALESCE(shld_rck_specific.SHLD_RCK_Miles, 0.00),
        r.SHLD_RCK_Hrs = COALESCE(shld_rck_specific.SHLD_RCK_Hrs, 0.00),
        r.SHLD_RCK_Runrate = COALESCE(shld_rck_specific.SHLD_RCK_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS SHLD_S01_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS SHLD_S01_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS SHLD_S01_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '2' -- Activity ID for Audit/QA (assuming S01 is an audit type)
            AND temp.Batch LIKE '%S01%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) s01_shld
    ON r.Employee_Id = s01_shld.Employee_Id
    AND r.Project_code = s01_shld.Project_code
    AND r.`Month` = s01_shld.ProcessMonth
    SET r.SHLD_S01_Miles = COALESCE(s01_shld.SHLD_S01_Miles, 0.00),
        r.SHLD_S01_Hrs = COALESCE(s01_shld.SHLD_S01_Hrs, 0.00),
        r.SHLD_S01_Runrate = COALESCE(s01_shld.SHLD_S01_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Others_Rework_Hrs,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))), 2) AS Others_Rework_Miles,
            ROUND(SUM(CAST(temp.Total_Chain AS DECIMAL(10,3))) / NULLIF(SUM(temp.Work_Time) / 3600, 0), 2) AS Others_Rework_Runrate
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '97' -- Specific Activity ID for Others Rework
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) others_rework
    ON r.Employee_Id = others_rework.Employee_Id
    AND r.Project_code = others_rework.Project_code
    AND r.`Month` = others_rework.ProcessMonth
    SET r.Others_Rework_Miles = COALESCE(others_rework.Others_Rework_Miles, 0.00),
        r.Others_Rework_Hrs = COALESCE(others_rework.Others_Rework_Hrs, 0.00),
        r.Others_Rework_Runrate = COALESCE(others_rework.Others_Rework_Runrate, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS FQA_Hrs
        FROM temp_combined_processlog AS temp
        WHERE temp.Batch LIKE '%FQA%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) fqa
    ON r.Employee_Id = fqa.Employee_Id
    AND r.Project_code = fqa.Project_code
    AND r.`Month` = fqa.ProcessMonth
    SET r.FQA_Hrs = COALESCE(fqa.FQA_Hrs, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS IPR_Hrs
        FROM temp_combined_processlog AS temp
        WHERE temp.Batch LIKE '%IPR%'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) ipr
    ON r.Employee_Id = ipr.Employee_Id
    AND r.Project_code = ipr.Project_code
    AND r.`Month` = ipr.ProcessMonth
    SET r.IPR_Hrs = COALESCE(ipr.IPR_Hrs, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Meeting_Hrs
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '99'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) meeting
    ON r.Employee_Id = meeting.Employee_Id
    AND r.Project_code = meeting.Project_code
    AND r.`Month` = meeting.ProcessMonth
    SET r.Meeting_Hrs = COALESCE(meeting.Meeting_Hrs, 0.00);

    UPDATE Emp_Runrate_Report r
    LEFT JOIN (
        SELECT
            temp.Employee_Id,
            temp.Project_code,
            temp.ProcessMonth,
            ROUND(SUM(temp.Work_Time) / 3600, 2) AS Training_Hrs
        FROM temp_combined_processlog AS temp
        WHERE temp.Activity_id = '7'
            AND temp.Project_code != 'BREAK'
        GROUP BY temp.Employee_Id, temp.Project_code, temp.ProcessMonth
    ) training
    ON r.Employee_Id = training.Employee_Id
    AND r.Project_code = training.Project_code
    AND r.`Month` = training.ProcessMonth
    SET r.Training_Hrs = COALESCE(training.Training_Hrs, 0.00);

    -- Final update to convert Month column to Mon-YY format for display
    UPDATE Emp_Runrate_Report
    SET `Month` = @ThisMonthHR
    WHERE `Month` = @TargetMonth;

END$$

DELIMITER ;


-- calling
Call Get_Emp_Runrate_Report('2024-05');

SELECT *
FROM Emp_Runrate_Report
WHERE
Month = 'May-24';
