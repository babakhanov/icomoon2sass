require 'zip'

class Icomoon2Sass::Zip < Icomoon2Sass::Archive

  def initialize(zip_file)
    @files = {}

    Zip::File.open(zip_file) do |z|
      z.each do |entry|
        @files[entry.name] = z.get_input_stream(entry).read if extractable? entry
      end
    end
  end

  private

    def extractable?(entry)
      return EXTRACTABLE_PATTERN.match(entry.name) && entry.ftype == :file
    end

end

