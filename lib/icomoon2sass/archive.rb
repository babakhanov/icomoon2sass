class Icomoon2Sass::Archive
  attr_reader :files

  EXTRACTABLE_PATTERN = /(fonts\/.*|selection\.json|style\.css|demo-files\/.*|demo\.html)/

  def font_files
    @_font_files ||= @files.reject {|key| !key.match(/fonts/) }
  end

  def metadata_file
    @_metadata_file ||= @files.reject {|key| !key.match(/\.json/) }.values.first
  end

  def demo_files
    @_demo_files ||= begin
      demo_files = @files.reject {|key| !key.match(/(\.html|\.css|demo-files)/) }
      demo_files['demo-files/style.css'] = demo_files.delete('style.css')
      demo_files
    end
  end

  def session_file
    @_session_file ||= @files.reject {|key| !key.match(/\.json/) }.values.first
  end

end

