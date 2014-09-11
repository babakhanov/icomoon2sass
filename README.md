# Icomoon2Sass

A gem that makes using [IcoMoon](http://icomoon.io) even better!

## Installation

`gem install icomoon2sass`


## Usage

#### From the command line:

Pass a path to a zip file downloaded from IcoMoon:

`icomoon2sass path/to/icomoon.zip [OPTIONS]`

Or the path to an unzipped directory:

`icomoon2sass path/to/icomoon [OPTIONS]`


#### From a Ruby script

`icomoon2sass` can also be called from a Ruby script like so:

```ruby
Icomoon2Sass.run! source, font_path, sass_path, options
```

Rakefile example:

```ruby
require 'icomoon2sass`

desc 'My Icomoon to Sass task'
task :icomoon do
  Icomoon2Sass.run! './icomoon', './fonts', './sass', {compatible: true}
end
```


### OPTIONS

#### Command line options

```
  --font-path PATH      Destination path for font files, defaults to current directory
  --sass-path PATH      Destination path for Sass files, defaults to current directory
  --scss                Use the SCSS syntax
  -c, --compatible      Generate code compatible with Sass 3.2
  --oocss               Generate OOCSS-style classes
  --demo-path PATH      Copy demo.html from SOURCE to PATH/demo.html
                        If omitted, the demo file will be ignored
  --session-path PATH   Copy selection.json from SOURCE to PATH/selection.json
                        If omitted, the demo file will be ignored
```

#### Ruby options

The `options` argument to `Icomoon2Sass::run!` accepts a hash with any of the following keys:

```
  scss          Boolean     Use the SCSS syntax
  compatible    Boolean     Generate code compatible with Sass 3.2
  oocss         Boolean     Generate OOCSS-style classes
  demo_path     Boolean/path   If truthy, copy demo.html to the specified path
  session_path  Boolean/path   If truthy, copy selection.json to the specified path
```

The default value for all options is `false`.




### OUTPUT
By default `icomoon2sass` generates Sass code in the indented Sass syntax. Further, the default generated code is only compatible with Sass 3.3+.

```sass
$icons: (
  github: '\28',
  twitter: '\29',
  gear: '\e002',
  ...
)

@each $placeholder, $content in $icons
  %#{$placeholder}-icon
    @each $value in $content
      content: $value
```


Sass 3.2 doesn't support hash-like maps, so if you're still using 3.2, you'll need to set the `-c` flag (or pass `compatible: true` in the `options` argument to `run!`), which will generate code like this:

```sass
$github-icon: '\28'
$twitter-icon: '\29'
$gear-icon: '\e002'

...

%github-icon
  content: $github-icon

%twitter-icon
  content: $twitter-icon

%gear-icon
  content: $gear-icon
```


#### OOCSS

By default, `icomoon2sass` only generates [Sass placeholder selectors](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#placeholder_selectors_). If you need literal CSS classes pass the `--oocss` flag, and `icomoon2sass` will generate a second Sass file, `_oocss_icons.sass`, containing CSS classes for each icon.

```sass
@each $placeholder, $content in $icons
  .#{$placeholder}-icon:before
    @extend %#{$placeholder}-icon
```

Or, for Sass 3.2, something like this:

```sass
.github-icon:before
  @extend %github-icon

.twitter-icon:before
  @extend %twitter-icon

.gear-icon:before
  @extend %gear-icon
```

