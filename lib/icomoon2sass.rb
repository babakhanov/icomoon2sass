require 'icomoon2sass/version'
require 'icomoon2sass/archive'
require 'icomoon2sass/zip'
require 'icomoon2sass/dir'
require 'icomoon2sass/font'
require 'icomoon2sass/sass'
require 'icomoon2sass/utilities'
require 'hash'

module Icomoon2Sass

  def self.run!(source, font_path, sass_path, options = {})
    defaults = {
      scss: false,
      compatible: false,
      oocss: false,
      demo_path: options[:"demo-path"],
      session_path: options[:"session-path"]
    }

    options = defaults.merge options.symbolize_keys

    utilities = Icomoon2Sass::Utilities.new

    if source.end_with? '.zip'
      files = Icomoon2Sass::Zip.new source

    elsif Dir.exists? source
      files = Icomoon2Sass::Dir.new source

    else
      raise 'Source must be either a directory or .zip file!'

    end

    raise 'Source must contain \'selection.json\'.' unless files.files['selection.json']

    font = Icomoon2Sass::Font.new files.metadata_file

    syntax = options[:scss] ? 'scss' : 'sass'

    compatible = options[:compatible] || false

    sass = Icomoon2Sass::Sass.new font, syntax, compatible


    # Save the Sass file
    utilities.create_file "#{sass_path}/_icons.#{sass.syntax}", sass.code

    if options[:oocss]
      utilities.create_file "#{sass_path}/_oocss_icons.#{sass.syntax}", sass.oocss
    end

    files.font_files.each do |filename, content|
      utilities.create_file "#{font_path}/#{filename.sub('fonts/', '')}", content
    end

    if options[:demo_path]
      files.demo_files.each do |filename, content|
        utilities.create_file "#{options[:demo_path]}/#{filename}", content
      end

      files.font_files.each do |filename, content|
        utilities.create_file "#{options[:demo_path]}/demo-files/fonts/#{filename.sub('fonts/', '')}", content
      end

      utilities.gsub_file "#{options[:demo_path]}/demo.html", /href="style.css">/, 'href="demo-files/style.css">'
    end

    if options[:session_path]
      utilities.create_file "#{options[:session_path]}/session.json", files.session_file
    end
  end

end

