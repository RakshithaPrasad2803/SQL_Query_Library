USE [OK25_00270918_Distress_Batch001_new_test]
GO

-- Get IDDistressType for Trans_point
DECLARE @TransTypeName NVARCHAR(100) = 'Trans_point';
DECLARE @TransTypeID INT = (
    SELECT IDDistressType 
    FROM distress.DistressTypes 
    WHERE DistressTypeName = @TransTypeName
);

-- Insert only if Trans_point is missing within the same region
INSERT INTO distress.DistressRecords (
    IDDistressType,
    IDSeverity,
    IDSession,
    DistanceStamp,
    Length,
    StartX,
    EndX,
    IsManual
)
SELECT
    @TransTypeID,
    dr.IDSeverity,
    dr.IDSession,
    dr.DistanceStamp + (dr.Length / 2.0),
    0.0,
    (dr.StartX + dr.EndX) / 2.0,
    (dr.StartX + dr.EndX) / 2.0,
    1
FROM distress.DistressRecords dr
JOIN distress.DistressTypes dt ON dr.IDDistressType = dt.IDDistressType
WHERE dt.DistressTypeName IN ('Transverse', 'JCP_Trans')
AND NOT EXISTS (
    SELECT 1 
    FROM distress.DistressRecords tp
    WHERE 
        tp.IDSession = dr.IDSession
        AND tp.IDDistressType = @TransTypeID
        AND tp.StartX BETWEEN dr.StartX AND dr.EndX
        AND tp.DistanceStamp BETWEEN dr.DistanceStamp AND (dr.DistanceStamp + dr.Length)
);

-- Log result
DECLARE @InsertedCount INT = @@ROWCOUNT;
PRINT CONCAT('Inserted ', @InsertedCount, ' Trans_point records into distress.DistressRecords');
