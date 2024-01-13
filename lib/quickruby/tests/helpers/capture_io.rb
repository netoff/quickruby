def capture_io
  require 'stringio'

  captured_stdout, captured_stderr = StringIO.new, StringIO.new

  orig_stdout, orig_stderr = $stdout, $stderr
  $stdout, $stderr  = captured_stdout, captured_stderr

  yield

  [captured_stdout.string, captured_stderr.string]
ensure
  $stdout = orig_stdout
  $stderr = orig_stderr
end
