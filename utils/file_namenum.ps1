# setting the mockup environment
$statedir = $env:TEMP

$last_run_report = 'last_run_report.yaml'
$filename_mask = ('{0}.*' -f $last_run_report)
pushd $statedir
write-host ('Mocking {0} {1}' -f $last_run_report, "${root_path}\${last_run_report}")
write-output '' | out-file -FilePath "${statedir}\${last_run_report}"
popd

# actual code


if (test-path -path $statedir) {
  pushd $statedir
  if (test-path -path $last_run_report) {
    $file_count = @( Get-ChildItem -Name "$last_run_report.*" -ErrorAction 'Stop').count
    [Console]::Error.WriteLine(('Copy ' + $last_run_report + ' ' + "${last_run_report}.$($file_count + 1 )"))
    copy-item $last_run_report -Destination "${last_run_report}.$($file_count + 1 )" -force
  }
  popd
}
