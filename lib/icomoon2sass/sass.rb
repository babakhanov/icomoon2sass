require 'erb'
require 'sass'

class Icomoon2Sass::Sass
  attr_reader :code, :syntax

  def initialize(font, syntax = 'sass', compatible = false)
    @font = font
    @syntax = syntax
    
    @format = compatible ? 'list' : 'map'
    
    @code = sass_convert 'sass', syntax, template(@format)
  end

  def oocss
    sass_convert 'sass', syntax, template("oocss_#{@format}")
  end

  private

    def template(tmpl)
      icons = @font.icons
      font_family = @font.font_family

      renderer = ERB.new File.read("#{File.dirname(__FILE__)}/templates/#{tmpl}.sass.erb")
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

