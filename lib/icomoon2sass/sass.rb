require 'erb'
require 'sass'

class Icomoon2Sass::Sass
  attr_reader :code, :syntax

  def initialize(icons, syntax = 'sass', compatible = false)
    @syntax = syntax

    if compatible
      @code = sass_convert 'sass', syntax, list_template(icons.icons)
      
    else
      @code = sass_convert 'sass', syntax, map_template(icons.icons)
    end
  end

  private

    def map_template(icons)
      list = []
      icons.each do |icon, contents|
        list.push "#{icon}: '#{contents[:codepoint]}'"
      end

      tmpl = '$icons: (
<%= list.join(",\n  ") %>
)
      
@each $placeholder, $content in $icons
  %#{$placeholder}-icon
    @each $value in $content
      content: $value

'

      renderer = ERB.new(tmpl)
      renderer.result(binding)
    end

    def list_template(icons)
      tmpl = '<% icons.each do |icon, content|
%><%= "$#{icon}-icon: \'#{content[:codepoint]}\'"
%>
<% end %>

<% icons.each do |icon, content|
%>%<%= "#{icon}-icon" %>
  content: <%= "$#{icon}-icon" %>

<% end %>

'

      renderer = ERB.new(tmpl)
      renderer.result(binding)
    end


    def sass_convert(from_syntax, to_syntax, sass)
      return sass if from_syntax == to_syntax

      begin
        Sass::Engine.new(sass, {:from => from_syntax.to_sym, :to => to_syntax.to_sym, :syntax => from_syntax.to_sym}).to_tree.send("to_#{to_syntax}").chomp
      rescue Sass::SyntaxError => e
        sass
      end
    end

end

