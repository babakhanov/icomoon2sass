require 'icomoon2sass/version'
require 'icomoon2sass/cli'
require 'json'

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

    return icons
  end
end

