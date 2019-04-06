# lender - dynamic view templates, powered by liquid

[![Version](https://img.shields.io/github/tag/anamba/lender.svg?maxAge=360)](https://github.com/anamba/lender/releases/latest)
[![Build Status](https://travis-ci.org/anamba/lender.svg?branch=master)](https://travis-ci.org/anamba/lender)
[![License](https://img.shields.io/github/license/anamba/lender.svg)](https://github.com/anamba/lender/blob/master/LICENSE)

A thin wrapper around liquid, for use with Crystal web frameworks.

Primary use case is to allow reading templates from disk (or database), instead of compiling them into the executable. This adds flexibility at the cost of opening up access vulnerabilities if an attacker is able to edit view templates, either through normal operation or by gaining access to the filesystem (or database).

Along those lines, while the macro could help to populate the context object, we are choosing not to do that, to ensure that exposing data to the renderer is a conscious choice on the part of the developer.

As the Liquid::Context object is basically just a hash of `JSON::Any`s, the developer is encouraged to think of the controller as a JSON API, and the view as a consumer of that API.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lender:
       github: anamba/lender
   ```

2. Run `shards install`

## Basic Usage

```crystal
require "lender"
include Lender

# lender_context needs to be defined before calling lender_string or lender macros
# can be a local var, method or macro (the name just needs to be defined)
lender_context = Liquid::Context.new

lender_string("asdf")                     # => "asdf"
lender_context.set("example", "fdsa")
lender_string("asdf {{ example }}")       # "asdf fdsa"

# lender_context and lender_base_path need to be defined prior to calling lender macro
lender_base_path = "src/views/mycontroller"

lender("index.html")                      # "This is a  view."
lender_context.set("myvar", "cool")
lender("index.html")                      # "This is a cool view."
```

## Framework Usage

It is not necessary or recommended to use dynamic templates for everything. Pulling in compiled partials is easy (Amber example):
```crystal
lender_context.set("my_partial", render(partial: "_my_partial.ecr"))
```

Dropping a liquid template into a compiled layout is also relatively straightforward (Amber example):

In your ApplicationController:
```crystal
CONTENT_MARKER = "<<<<<CONTENT>>>>>" # some kind of unique string that we can search/replace
```

Create a new view that displays the marker (e.g. `layouts/placeholder.ecr`):
```crystal
<%= CONTENT_MARKER %>
```

In your controller action, render that view and replace the marker with your rendered liquid template:
```crystal
render("layouts/placeholder.ecr").sub(CONTENT_MARKER, lender("my_view_template.html"))
```

## Contributing

1. Fork it (<https://github.com/anamba/lender/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Aaron Namba](https://github.com/anamba) - creator and maintainer
