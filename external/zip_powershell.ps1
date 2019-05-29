# пример из https://stackoverflow.com/questions/43122000/how-can-i-zip-two-arrays-in-powershell
# https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.zip?redirectedfrom=MSDN&view=netframework-4.5 

$one = @('A', 'B','C')
$two = @('a', 'b', 'c')
$func = { param ($a, $b)  ('{0} {1}' -f $a , $b)}
[Linq.Enumerable]::Zip($one, $two, [Func[Object, Object, Object[]]]$func)
<#
A a
B b
C c
#>

