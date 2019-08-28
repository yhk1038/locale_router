# frozen_string_literal: true

require 'rails'

require 'locale_router/version'
require 'locale_router/configurable'
require 'locale_router/checker'
require 'locale_router/context'

module LocaleRouter
  extend LocaleRouter::Configurable

  class Error < StandardError; end

  def self.included(base)
    if LocaleRouter.config.auto_follow_access_header
      base.send :include, ::HttpAcceptLanguage::AutoLocale
    end
    base.send :include, LocaleRouter::Checker
    base.send :include, LocaleRouter::Context
  end
end
