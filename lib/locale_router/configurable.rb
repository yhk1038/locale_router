# frozen_string_literal: true

require 'locale_router/config'

module LocaleRouter
  module Configurable
    def configuration(rails)
      rails.application.configure do
        LocaleRouter.config = Config.new
        yield(LocaleRouter.config) if block_given?

        config.middleware.use ::I18n::Middleware
        config.i18n.available_locales = LocaleRouter.config.available_locales
        config.i18n.default_locale = LocaleRouter.config.default_locale
        config.i18n.load_path += LocaleRouter.config.locale_dir(rails.root)
      end
    end
  end

  module ActionDispatch::Routing
    class Mapper
      def locale_detect(root: nil)
        regexp = LocaleRouter.config.available_locales_regexp
        scope '(/:locale)', locale: regexp do
          if root
            LocaleRouter.config.available_locales.each do |locale|
              match "/#{locale}", to: root, via: :get, defaults: { locale: locale.to_s }
            end
          end
          yield
        end
      end
    end
  end
end
