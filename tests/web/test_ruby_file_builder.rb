test "it supports simple html tags" do
  html = Quickruby::Build::Web::RubyFile.run(<<-RUBY)
    html do
      head do
        title "Hello, World!"
      end
      body do
        h1 "Hello, World!"
      end
    end
  RUBY

  assert html, "<html>"
  assert html, "<head><title>Hello, World!</title></head>"
  assert html, "<body><h1>Hello, World!</h1></body>"
  assert html, "</html>"
end

test "using unsupported tags raises an error" do
  exception = begin
    Quickruby::Build::Web::RubyFile.run(<<-RUBY)
      asdf do 
        r1 "Hello, World!"
      end
    RUBY
  rescue => e
    e
  end

  assert exception.message, "invalid HTML tag `asdf`"
end
