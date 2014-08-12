require 'thor'
require 'thor/group'
require 'icomoon2sass'

class Icomoon2Sass::CLI < Thor::Group
  include Thor::Actions

  argument :icomoon

  class_option :'font-path', type: :string, default: './', desc: 'Destination path for font files'
  class_option :'sass-path', type: :string, default: './', desc: 'Destination path for Sass files'
  class_option :scss, type: :boolean, default: false, desc: 'Use the SCSS syntax'
  class_option :compatible, aliases: '-c', type: :boolean, default: false, desc: 'Generate code compatible with Sass 3.2'
  class_option :oocss, type: :boolean, default: false, desc: 'Generate OOCSS-style classes'

  def start

    if icomoon.end_with? '.zip'
      say_status('Reading zip file.', '', :green)

      files = Icomoon2Sass::Zip.new icomoon

    elsif Dir.exists? icomoon
      say_status('Reading directory.', '', :blue)

      files = Icomoon2Sass::Dir.new icomoon

    else
      return say_status('WTF?!', 'I have no idea what I\'m doing.', :red)

    end

    return say_status('You seem to be missing \'selection.json\'.', '', :red) unless files.files['selection.json']


    font = Icomoon2Sass::Font.new files.metadata_file

    syntax = options['scss'] ? 'scss' : 'sass'

    compatible = options['compatible'] || false

    sass = Icomoon2Sass::Sass.new font, syntax, compatible


    # Save the Sass file
    create_file "#{options['sass-path']}/_icons.#{sass.syntax}", sass.code

    if options['oocss']
      create_file "#{options['sass-path']}/_oocss_icons.#{sass.syntax}", sass.oocss
    end

    files.font_files.each do |filename, content|
      create_file "#{options['font-path']}/#{filename.sub('fonts/', '')}", content
    end

  end
end

