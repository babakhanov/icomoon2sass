class Icomoon2Sass::Dir < Icomoon2Sass::Archive

  def initialize(directory)
    @files = {}

    Dir.glob("#{directory}/**/*", File::FNM_DOTMATCH) do |file|
      next if ['.','..','.DS_Store'].include? file

      @files[file.sub("#{directory}/", '')] = File.read(file) if extractable? file
    end

  end

  private

    def extractable?(entry)
      return EXTRACTABLE_PATTERN.match(entry) && File.file?(entry)
    end

end

