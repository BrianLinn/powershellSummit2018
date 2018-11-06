#$seconds = 600
#1..$seconds |
#ForEach-Object { $percent = $_ * 100 / $seconds; 
# Write-Progress -Activity "Restarting in" -SecondsRemaining ($seconds - $psitem)# -PercentComplete $percent;
#Start-Sleep -Seconds 1
#}
#
$databases = Get-DbaDatabase -SqlInstance $ENV:COMPUTERNAME 

$databases.ForEach{
    $id = $databases.IndexOf($psitem)
$id
    Write-Progress -Activity "Backing up database $($psitem.Name) on instance $($psitem.computername)\$($psitem.instancename) Number $id of $($databases.count) " -PercentComplete ($id * 100 /$databases.count)
    Start-Sleep -Seconds 1
}