class Icomoon2Sass::Archive
  attr_reader :files

  EXTRACTABLE_PATTERN = /(fonts\/.*|selection\.js|style\.css)/

  def font_files
    @_font_files ||= @files.reject {|key| !key.match(/fonts/) }
  end

  def metadata_file
    @_metadata_file ||= @files.reject {|key| !key.match(/\.json/) }.values.first
  end
end

