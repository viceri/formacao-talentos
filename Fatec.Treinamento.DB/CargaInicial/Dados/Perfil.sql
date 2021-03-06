USE [Treinamento]
GO



SET NOCOUNT ON

MERGE INTO [dbo].[Perfil] AS Target
USING (VALUES
  (1,'Administrador')
 ,(2,'Usuario')
 ,(3,'Instrutor')
) AS Source ([Id],[Nome])
ON (Target.[Id] = Source.[Id])
WHEN MATCHED AND (
	NULLIF(Source.[Nome], Target.[Nome]) IS NOT NULL OR NULLIF(Target.[Nome], Source.[Nome]) IS NOT NULL) THEN
 UPDATE SET
  [Nome] = Source.[Nome]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([Id],[Nome])
 VALUES(Source.[Id],Source.[Nome])
WHEN NOT MATCHED BY SOURCE THEN 
 DELETE
;
GO
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [dbo].[Perfil]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[dbo].[Perfil] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
GO
SET NOCOUNT OFF
GO
