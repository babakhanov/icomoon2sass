require 'json'

class Icomoon2Sass::Font
  attr_reader :icons, :font_family

  def initialize(metadata)
    @icons = {}

    json = JSON.parse(metadata)

    @font_family = json['preferences']['fontPref']['metadata']['fontFamily']    

    json['icons'].each do |icon|
      @icons[icon['properties']['name'].gsub(/[[:punct:]\s]/, '-')] = {
        character: [icon['properties']['code']].pack('U'),
        codepoint: '\%0x' % icon['properties']['code'].ord
      }

    end

  end
end

