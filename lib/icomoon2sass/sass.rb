require 'erb'
require 'sass'

class Icomoon2Sass::Sass
  attr_reader :code, :syntax

  def initialize(icons, syntax = 'sass', compatible = false)
    @syntax = syntax

    if compatible
      @code = sass_convert 'sass', syntax, template('list', icons.icons)
      
    else
      @code = sass_convert 'sass', syntax, template('map', icons.icons)
    end
  end

  private

    def template(format, icons)
      tmpl = File.read("lib/icomoon2sass/templates/#{format}.sass.erb")
  
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

