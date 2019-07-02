# frozen_string_literal: true

# => 'config/initializers/locale_router.rb'
#
# LocaleRouter.configuration(Rails) do |config|
#
#   # Examples with Default Value
#   config.available_locales = %w[en]
#   config.default_locale = :en
#   config.auto_follow_access_header = false
#   config.auto_prepend_before_action = false
#   config.load_path = 'config/locales/**/*.{rb,yml}'
#
# end
#
module LocaleRouter
  def self.config=(config)
    @@locale_config = config
  end

  def self.config
    @@locale_config
  end

  class Config
    attr_writer :available_locales
    def available_locales
      @available_locales ||= %w[en]
    end

    attr_writer :default_locale
    def default_locale
      @default_locale ||= available_locales.first.to_sym
    end

    # => Option :auto_follow_access_header
    #
    # 이 옵션의 값이 true 이면, Client Browser 의
    # Access-Header 의 locale 설정이 최우선으로 적용됩니다.
    #
    # If this value is set true, the Client Browser's
    # Access-Header locale setting takes precedence.
    #
    #
    #   <Boolean> config.auto_follow_access_header = true (default)
    #
    #
    attr_writer :auto_follow_access_header
    def auto_follow_access_header
      @auto_follow_access_header ||= @auto_follow_access_header.nil?
    end

    # => Option :auto_follow_access_header
    #
    # 만약 이 값이 true 이면, module 이 include 된 컨트롤러에
    # `prepend_before_action :set_locale_context`를 적용합니다.
    #
    # If this value is set true,
    # the `prepend_before_action :set_locale_context` is applied
    # to the controller the module included.
    #
    #
    #   <Boolean> config.auto_prepend_before_action = true (default)
    #
    #
    attr_writer :auto_prepend_before_action
    def auto_prepend_before_action
      @auto_prepend_before_action ||= @auto_prepend_before_action.nil?
    end

    # => Option :load_path
    #
    # 이 옵션은 locale 번역 파일의 경로를 지정합니다.
    # Rails.root 로부터 상대경로를 참조하며, "/config/application.rb" 에서
    # `config.i18n.load_path` 를 추가하는 것과 같습니다.
    #
    # This option specifies the path to the locale translation file.
    # It refers to the relative path from Rails.root,
    # This is equivalent to adding `config.i18n.load_path`
    # in "/config/application.rb"
    #
    #
    #   config.load_path = 'config/locales/**/*.{rb,yml}' (default)
    #
    #
    attr_writer :load_path
    def load_path
      @load_path ||= 'config/locales/**/*.{rb,yml}'
    end

    # protected

    def locale_dir(root)
      Dir["#{root}/#{load_path}"]
    end

    def available_locales_regexp
      Regexp.new(available_locales.map(&:to_s).join('|'))
    end
  end
end
