require 'base64'

# origin: https://stackoverflow.com/questions/47635181/execute-powershell-commands-from-ruby
command = %{get-WmiObject -class Win32_Process  -filter 'name="explorer.exe"'|select-object -property ProcessName}
# encoded_cmd = Base64.strict_encode64(command.encode('utf-16le'))
result = %x|powershell.exe -encodedCommand #{Base64.strict_encode64(command.encode('utf-16le'))}|
puts result