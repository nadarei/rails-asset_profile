Why you want it
---------------

    $ bundle exec rake assets:precompile:profile RAILS_GROUPS=assets
    application.js                                              6663ms
    new_project.js                                              367ms
    vendor.js                                                   966ms
    application.css                                             8579ms
    styleguide-extras.css                                       271ms
    styleguide.css                                              429ms
    Compilation finished in 17765ms.

How to use it
-------------

``` ruby
# Gemfile
gem 'rails-asset_profile', github: 'nadarei/rails-asset_profile', branch: 'master'
```

Caveats
-------

This generates identical digest and non-digest assets to do things faster.
This, for most cases, is usually fine.

If you're affected by this, just regenerate them properly with Rails's `rake
assets:precompile` :-)

Acknowledgements
----------------

Uses code directly taken from [sprockets-rails].

[sprockets-rails]: https://github.com/rails/sprockets-rails

License
-------

MIT.
