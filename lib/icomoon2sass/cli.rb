require 'thor'
require 'thor/group'
require 'icomoon2sass/zip'
require 'icomoon2sass/dir'

class Icomoon2Sass::CLI < Thor::Group
  include Thor::Actions

  argument :icomoon

  class_option :'font-path', type: :string, default: './', desc: 'Destination path for font files'
  class_option :'sass-path', type: :string, default: './', desc: 'Path to Sass project'
  class_option :syntax, type: :string, default: 'sass', desc: 'Sass syntax, Sass or SCSS'
  class_option :format, type: :string, default: 'static', desc: 'variable format, \'static\' or \'dynamic\''

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

    puts Icomoon2Sass.icons files
  end
end

