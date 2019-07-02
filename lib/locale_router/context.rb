# frozen_string_literal: true

require 'active_support/concern'

module LocaleRouter
  module Context
    extend ActiveSupport::Concern

    included do
      if LocaleRouter.config.auto_prepend_before_action
        if respond_to?(:prepend_before_action)
          prepend_before_action :set_locale_context
        else
          prepend_before_filter :set_locale_context
        end
      end
    end

    def set_locale_context
      in_locale_setting_process do
        if LocaleRouter.config.auto_follow_access_header
          set_locale_with_access_header
        else
          set_locale_over_access_header
        end

        set_locale_from_inline_param if locale_params
      end
    end

    def default_url_options(options = {})
      { locale: I18n.locale }.merge options
    end

    private

    def locale_params
      params[:locale].presence
    end

    def valid_locale_params?
      I18n.available_locales.map(&:to_s).include?(locale_params)
    end

    def in_locale_setting_process
      locale_setting_start_log
      yield
      locale_setting_final_log
    end

    def locale_setting_start_log
      logger.debug "* Default application locale: '#{I18n.default_locale}'".yellow
    end

    def locale_setting_final_log
      logger.debug "* Locale set to '#{I18n.locale}' on Final\n".yellow
    end

    def set_locale_with_access_header
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}".yellow
      logger.debug "* Locale reset to '#{I18n.locale}' from Access-Header".yellow
    end

    def set_locale_over_access_header
      I18n.locale = I18n.default_locale
      logger.debug "* Locale reset to '#{I18n.locale}' from default locale config".yellow
    end

    def set_locale_from_inline_param
      I18n.locale = locale_params
      logger.debug "* Locale reset to '#{I18n.locale}' from inline parameters".yellow
    end
  end
end
