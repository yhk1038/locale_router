# LocaleRouter

Automatically detect client locale with your simple configuration.  
(Limited support on Rails now)

Thread-Safe `I18n.locale` controls support. 

## Example

1. Make configuration:

    ```ruby
    # config/initializers/locale_router.rb
     
    LocaleRouter.configuration(Rails) do |config|
     
      # Examples with Default Value
      
      config.available_locales = %w[ko en th vn cn]  # ['en'] is default
      
      config.default_locale = :en                    # :en is default
      
      config.auto_follow_access_header = false       # false is default
      
      config.auto_prepend_before_action = false      # false is default
      
      config.load_path = 'config/locales/**/*.{rb,yml}'
     
    end
     
    ```

1. Wrap router:  
  The `locale_detect` method is available in `router.rb`:

    ```ruby
    Rails.application.routes.draw do
      ...
      locale_detect do
        # your router here
      end
      ...
    end
    ```

   - The `locale_detect` is same with this:
    ```ruby
    scope '(:locale)', locale: /regexp_of_available_locales_in_your_config/ do
      ...
    end
    ```

1. Include `LocaleRouter` module in your controller:  
    You can easily set the locale used for i18n in a before-action (before-filter supported):
    
    ```ruby
    class LocaleController < ApplicationController
      include LocaleRouter
    
      # If your config set 'config.auto_prepend_before_action = true',
      # you don't need to add 'before_action' line manually
        
      before_action :set_locale_context
      
      ...
    end
    ```

1. That's all :) Run `rails server`  
  You can check applied `LocaleRouter`  
  Enjoy your code!


## Config options

You can controls some options on your config in `config/initializers/locale_router.rb`:

1. `config.available_locales = Array`
   - If not set, `['en']` is default.

1. `config.default_locale = Symbol or String`
   - Default is **first element** of your `config.available_locales`

1. `config.auto_follow_access_header = Boolean`
   - **If true**, this module assumes that **the language setting of the client's browser is the most important language** and applies it to the locale.
   
   - **If not**, then the default_locale set in config is assumed to be the default locale and, **if possible, the inline parameter settings are applied** to the locale.

1. `config.auto_prepend_before_action = Boolean`
   - If true, the method recognizing locale (`:set_locale_context`) is **automatically** applied as `prepend_before_action`.
     ```ruby
     class LocaleController < ApplicationController
       include LocaleRouter
     ```
     
   - Set this option to false if you want to **manually control** when to run the setting locale method via `before_action`.
     ```ruby
     class LocaleController < ApplicationController
       include LocaleRouter
       
       before_action :set_locale_context
     ```

1. `config.load_path`
   - Define your locale directory path (relative start with rails root)
   
   - Default is `'config/locales/**/*.{rb,yml}'`



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_accept_language', '~> 2.1.1'
gem 'locale_router'
```

And then execute:

    $ bundle


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/locale_router. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LocaleRouter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/locale_router/blob/master/CODE_OF_CONDUCT.md).
