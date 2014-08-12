require 'icomoon2sass/cli'


ARGV << '--help' if ARGV.empty?


help_message = <<-EOT
Usage: icomoon2sass path/to/icomoon(.zip) [OPTIONS]

OPTIONS
  --font-path PATH  Destination path for font files, defaults to current directory
  --sass-path PATH  Destination path for Sass files, defaults to current directory
  --scss            Use the SCSS syntax
  -c, --compatible  Generate code compatible with Sass 3.2


OUTPUT
  By default icomoon2sass generates Sass code in the indented Sass syntax. Further,
  the default generated code is only compaitble with Sass 3.3+.

    $icons: (
        github: \'\\28\',
        twitter: \'\\29\',
        gear: \'\\e002\',
        ...
    )

    @each $placeholder, $content in $icons
      %\#{$placeholder}-icon
        @each $value in $content
          content: $value

  Sass 3.2 doesn't support hash-like maps, so if you're still using 3.2, you'll need
  to set the '-c' flag, which will generate code like this:

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

OOCSS

  By default, icomoon2sass only generates Sass placeholder selectors. If you need
  literal CSS classes pass the '--oocss' flag, and icomoon2sass will generate a
  second Sass file, '_oocss_icons.sass', containing CSS classes for each icon.

    @each $placeholder, $content in $icons
      .\#{$placeholder}-icon:before
        @extend %\#{$placeholder}-icon

  Or, for Sass 3.2, something like this:

    .github-icon:before
      @extend %github-icon

    .twitter-icon:before
      @extend %twitter-icon

    .gear-icon:before
      @extend %gear-icon
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

