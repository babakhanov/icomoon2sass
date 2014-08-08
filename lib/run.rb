require 'icomoon2sass'


ARGV << '--help' if ARGV.empty?


help_message = <<-EOT
Usage: icomoon2sass path/to/icomoon(.zip) [OPTIONS]

OPTIONS
  --font-path=DIR,  destination path for font files, defaults to the current directory
  --sass-path=DIR,  path to Sass project, defaults to the current directory
  --syntax=SYNTAX,  Sass syntax, Sass or SCSS, defaults to 'sass'
  --format=FORMAT,  variable format, 'static' or 'dynamic', defaults to 'static'

FORMAT
  The 'static' format is compatible with Sass 3.2 and up, and generates Sass like this:

    $github-icon: \'\\28\'
    $twitter-icon: \'\\29\'
    $gear-icon: \'\\e002\'

    ...

    %github-icon
      content: $github-icon

    %twitter-icon
      content: $twitter-icon

    %gear-icon
      content: $gear-icon


  The 'dynamic' placeholder format is only compatible with Sass 3.3 and up, and
  generates Sass like this:

    $icons: (
      github: \'\\28\',
      twitter: \'\\29\',
      gear: \'\\e002\',
      ...
    )

    @each $placeholder, $content in $icons
      %icon-\#{$placeholder}
        @each $value in $content
          content: $value


  In addition to compatiblity, the two formats have other pros/cons: the static format
  gives you easy access to the internals of each icon's placholder, at the expense of
  vorbosity; the dynamic format dramatically DRYs up your code, but doesn't allow easy
  access to individual placeholders and--depending on your build environment--may
  affect compile time performance.

EOT

command = ARGV[0]

if !(command.nil? || command == '--help')
  Icomoon2Sass::CLI.start
  

elsif command == '--help'
  puts help_message

else
  puts "Error: Command '#{command}' not recognized"
  if %x{rake #{command} --dry-run 2>&1 } && $?.success?
    puts "Did you mean: `$ rake #{command}` ?\n\n"
  end
  puts help_message
  exit(1)
end

