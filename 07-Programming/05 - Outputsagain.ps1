function Get-TestData 
{
  # define the first-class citizen
  [string[]]$visible = 'ID','Date','User'
  $info = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet',$visible)


  [PSCustomObject]@{
      # wrap anything you'd like to return
      ID = 1
      Random = Get-Random
      Date = Get-Date
      Text = 'Hello'
      BIOS = Get-WmiObject -Class Win32_BIOS
      User = $env:username
    } |
    # add the first-class citizen info to your object
    Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $info -PassThru
  
}

Get-TestData

Get-TestData  | Select *