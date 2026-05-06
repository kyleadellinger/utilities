
# notes to get available assemblies:
$Assemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
"$Assemblies loaded: {0:n0}" -f $Assemblies.Count
