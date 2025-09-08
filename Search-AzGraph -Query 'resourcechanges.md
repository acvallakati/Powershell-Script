#path for running the command C:\

Search-AzGraph -Query 'resourcechanges
| extend targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType), changeTime = todatetime(properties.changeAttributes.timestamp)
| where changeTime > ago(7d) and changeType == "Create"
| project  targetResourceId, changeType, changeTime
| join ( Resources | extend targetResourceId=id) on targetResourceId
| order by changeTime desc
| project changeTime, changeType, id, resourceGroup, type, tags'
Out-File C:\ARM\test12345.csv