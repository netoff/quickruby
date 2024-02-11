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

# test "using unsupported tags raises an error" do
#   exception = begin
#     Quickruby::Build::Web::RubyFile.run(<<-RUBY)
#       asdf do
#         r1 "Hello, World!"
#       end
#     RUBY
#   rescue => e
#     e
#   end
#
#   assert exception.message, "invalid HTML tag `asdf`"
# end
#
# test "using classes on HTML elements" do
#   html = Quickruby::Build::Web::RubyFile.run(<<-RUBY)
#     div class: "container" do
#       div.p_1 "Single clas"
#       div.p_2.p_3 "Multiple classes"
#     end
#   RUBY
#
#   assert html, "<div class='container'>"
#   assert html, "<div class='p-1'>"
#   assert html, "<div class='p-2 p-3'>"
# end
#
# test "using classes on HTML elements" do
#   html = Quickruby::Build::Web::RubyFile.run(<<-RUBY)
#     div do
#       div
#     end
#   RUBY
#
#
#   puts ">#{html}<"
#   assert html, "<div></div>"
# end
