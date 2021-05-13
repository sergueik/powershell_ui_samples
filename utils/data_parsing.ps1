
# based on https://qna.habr.com/q/987631
# more verbose but somewhat simpler grep style pipeline and  default select-string
write-output 'test # 1'
netstat.exe -ano -p TCP |
  select-string  'ESTABLISHED' |
  select-string -allmatches '127.0.0.1:2222','[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}:22' |
  convertfrom-string |
  format-list

write-output 'test # 2'
$netstat_output = netstat.exe -ano -p TCP

# NOTE: no white space allowed between he variable name and the index operator '['
#
$netstat_output_columns = $netstat_output[3..$netstat_output.count] | convertfrom-string | select p2,p4,p5
$selected_columns = $netstat_output_columns | where-object {$_.p5 -eq 'ESTABLISHED' -and $_.P4 -match '[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}:22'}
# for learning purpose:
# NOTE: replacing pipeline with straight where-object with arguments
# leads to falures to filter the data - every line is picked
# and shows a horrible performance
# [scriptblock]$filter = { $_.p5 -eq 'ESTABLISHED' -and $_.P4 -match '[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}:22'}
# $selected_columns = where-Object -InputObject $netstat_output_columns -filterscript $filter
# further syntax sugar apparently needed
# see also
# https://serverfault.com/questions/1033443/powershell-pass-filterscript-to-where-object-as-variable
if ($selected_columns -ne $null) {
  write-output ('ssh connections')
  write-output $selected_columns | format-list
} else {
  write-output ('no ssh connections')
}

# TODO: flexible column names are not supported ?
# try to use column name
# 'p5' => 'state'
write-output 'test # 3'

$netstat_output = netstat.exe -ano -p TCP

$netstat_output_columns = $netstat_output[3..$netstat_output.count] | convertfrom-string | select a2,a3,a4,a5
$selected_columns = $netstat_output_columns | where-object {$_.a5 -eq 'ESTABLISHED' -and $_.a4 -match '[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}:22'}

if ($selected_columns -ne $null) {
  write-output ('ssh connections')
  write-output $selected_columns | format-list
} else {
  write-output ('no ssh connections')
}
