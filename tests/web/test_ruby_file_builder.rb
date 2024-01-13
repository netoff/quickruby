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