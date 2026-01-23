[cmdletbinding(defaultparametersetname='path')]
param(
[parameter()]
[string] $path = ("C:\"),
[parameter()]
[int64] $size = 1gb
)

get-childitem -path $path -erroraction silentlycontinue -recurse | where-object -filterscript {$_.length -gt $size}
