begin
  # pure Ruby https://github.com/janlelis/clipboard 	
  require 'clipboard'
  # dependency
  require 'ffi'
  $USE_CLIPBOARD = true
rescue LoadError => e
  puts ('Ignoring gem load error ' + e.to_s)	
  $USE_CLIPBOARD = false
end
require 'pp'
if $USE_CLIPBOARD
  Clipboard.copy(<<-EOF
  FOO
  BAR
  EOF
  )
  $stderr.puts ('Example 1:' + Clipboard.paste.encode('UTF-8') )
  Clipboard.copy("FOO\nBAR")
  $stderr.puts ('Example 2:' + Clipboard.paste.encode('UTF-8') )
  Clipboard.copy("тест что ё")
  $stderr.puts ('Example 3:' + Clipboard.paste.encode('UTF-8') )
else
  $stderr.puts 'Test skipped'	
end

