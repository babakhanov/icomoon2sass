require 'json'

class Icomoon2Sass::Icons
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

