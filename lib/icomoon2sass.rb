require 'icomoon2sass/version'
require 'icomoon2sass/cli'
require 'json'
require 'erb'

module Icomoon2Sass
  # Your code goes here...

  EXTRACTABLE_PATTERN = /(fonts\/.*|selection\.js|style\.css)/


  class Icons
    attr_reader :icons

    def initialize(files)
      @icons = {}

      json = JSON.parse(files.files['selection.json'])

      json['icons'].each do |icon|
        @icons[icon['properties']['name']] = {
          character: [icon['properties']['code']].pack('U'),
          codepoint: '\%0x' % icon['properties']['code'].ord
        }

      end

      return @icons
    end
  end


  class Sass

    def initialize(icons, syntax = 'sass', compatible = false)
      # puts icons.icons
      # puts syntax
      # puts compatible

      if compatible
        output = send("#{syntax}_variable_list_template".to_sym, icons.icons)
        output += "\n\n"
        output += send("#{syntax}_placeholder_list_template".to_sym, icons.icons)
        puts output

      else
        output = send("#{syntax}_map_template".to_sym, icons.icons)
        output += "\n\n"
        output += send("#{syntax}_loop_template".to_sym)
      end
    end

    private

      def sass_map_template(icons)
        list = []
        icons.each do |icon, contents|
          list.push "#{icon}: '#{contents[:codepoint]}'"
        end

        tmpl = "$icons: (
  <%= list.join(\",\n  \") %>
)"

        renderer = ERB.new(tmpl)
        renderer.result(binding)
      end

      def scss_map_template(icons)
        "#{sass_map_template(icons)};"
      end

      def sass_loop_template
        '@each $placeholder, $content in $icons
  %#{$placeholder}-icon
    @each $value in $content
      content: $value'
      end

      def scss_loop_template
        '@each $placeholder, $content in $icons {
  %#{$placeholder}-icon {
    @each $value in $content {
      content: $value;
    }
  }
}'
      end

      def sass_variable_list_template(icons)
        tmpl = "<% icons.each do |icon, content|
%><%= \"$\#{icon}-icon: '\#{content[:codepoint]}'\"
%>
<% end %>"

        renderer = ERB.new(tmpl)
        renderer.result(binding)
      end

      def scss_variable_list_template(icons)
        sass_variable_list_template(icons).gsub("\n", ";\n")
      end

      def sass_placeholder_list_template(icons)
        tmpl = "<% icons.each do |icon, content|
%>%<%= \"\#{icon}-icon\" %>
  content: <%= \"$\#{icon}-icon\" %>

<% end %>"

        renderer = ERB.new(tmpl)
        renderer.result(binding)
      end

      def scss_placeholder_list_template(icons)
        tmpl = "<% icons.each do |icon, content|
%>%<%= \"\#{icon}-icon\" %> {
  content: <%= \"$\#{icon}-icon\" %>;
}

<% end %>"

        renderer = ERB.new(tmpl)
        renderer.result(binding)
      end
  end
end

