-- Get ID for Trans_point
DECLARE @TransTypeName NVARCHAR(100) = 'Trans_point';
DECLARE @TransTypeID INT = (
    SELECT IDDistressType 
    FROM distress.DistressTypes 
    WHERE DistressTypeName = @TransTypeName
);

-- Find all Transverse/JCP_Trans without Trans_point
SELECT 
    dr.IDDistressRecord,
    dr.IDSession,
    dbo.fn_GetCollectedChainage(dr.IDSession, dr.DistanceStamp) AS StartChainage,
    dbo.fn_GetCollectedChainage(dr.IDSession, dr.DistanceStamp + dr.Length) AS EndChainage,
    dr.DistanceStamp,
    dr.Length

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
)
ORDER BY dr.IDSession, StartChainage;
