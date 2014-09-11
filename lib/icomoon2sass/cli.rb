require 'thor'
require 'thor/group'
require 'icomoon2sass'

class Icomoon2Sass::CLI < Thor::Group
  include Thor::Actions

  argument :source

  class_option :'font-path', type: :string, default: './', desc: 'Destination path for font files'
  class_option :'sass-path', type: :string, default: './', desc: 'Destination path for Sass files'
  class_option :scss, type: :boolean, default: false, desc: 'Use the SCSS syntax'
  class_option :compatible, aliases: '-c', type: :boolean, default: false, desc: 'Generate code compatible with Sass 3.2'
  class_option :oocss, type: :boolean, default: false, desc: 'Generate OOCSS-style classes'
  class_option :'demo-path', type: :string, default: false, desc: 'Destination path for demo.html'
  class_option :'session-path', type: :string, default: false, desc: 'Destination path for selection.json'

  def start

    begin
      Icomoon2Sass.run! source, options['font-path'], options['sass-path'], options

    rescue Exception => e
      say_status(e, '', :red)

    end

    return

  end
end

