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

    # => Option :locale_param_check_type
    #
    # 이 옵션은 `params[:locale]` 로 인식된 문자열에 대하여 신뢰성을 검사하는 방법을
    # 지정합니다. 이 옵션이 `:strong` 심볼이 설정 된 경우, +강타입+ 검사를 실행하며,
    # `config.available_locales` 에서 지정된 locale 문자열만을 허용합니다.
    # 반대로 이 옵션에 `:week` 심볼이 설정 된 경우, +약타입+ 검사를 실행하며,
    # `/` 문자열이 포함되지 않는 한 어떠한 문자열이라 할 지라도 에러를 발생하지 않습니다.
    # 단, '약타입 검사'의 경우에는 `config.available_locales` 에서 지정된 locale 문자열
    # 이외의 값에 대하여 `config.default_locale` 에서 지정된 기본 locale 을 적용받습니다.
    #
    # 경고: 만일 이 옵션에 `:week` 심볼을 사용한다면, production 환경 '이외의 환경'에서만
    # 사용할 것을 강하게 권장합니다.
    #
    # This option specifies how to check reliability for strings recognized
    # as `params[:locale]`. If this option is set to the `:strong` symbol,
    # it runs the +StrongType+ check and only accepts the locale string
    # specified in `config.available_locales`. Conversely, if the `:week` symbol
    # is set for this option, it will run the +WeekType+ check, and no string
    # will produce an error unless the `/` string is included.
    # However, in case of weak type checking, default locale specified in
    # `config.default_locale` is applied to values other than locale string
    # specified in `config.available_locales`.
    #
    # WARNING: If you use the `:week` symbol with this option, it is strongly
    # recommended that you use it only in 'non-production environments'.
    #
    #
    #   config.locale_param_check_type = :string (default) or :week
    #
    #
    attr_writer :locale_param_check_type
    def locale_param_check_type
      @locale_param_check_type ||= :strong
    end

    # => Option :undefined_slug_match
    #
    # 이 옵션은 `params[:locale]` 에서 미리 정의되지 않은 문자열이 인식된 경우
    # 접근을 허용할 수 있도록 하는 대체 문자열 패턴(regex)을 지정합니다.
    # 이 옵션은 `:locale_param_check_type` 에서 설정된 방법보다 우선하여 적용됩니다.
    #
    # This option set an additional string pattern(regex) to allow access
    # if an undefined string is recognized in `params[:locale]`.
    # This option overrides the method set by `:locale_param_check_type`.
    #
    #
    #   config.undefined_slug_match = '.*' (default is nil)
    #
    #   # => scope '(:locale)', locale: /.*/ do ... end
    #
    #
    attr_writer :undefined_slug_match
    def undefined_slug_match
      @undefined_slug_match ||= nil
    end

    # protected

    def locale_dir(root)
      Dir["#{root}/#{load_path}"]
    end

    def available_locales_regexp
      Regexp.new(regexp_conditions_for_param)
    end

    private

    def regexp_conditions_for_param
      return undefined_slug_match if undefined_slug_match

      case locale_param_check_type
      when :strong
        available_locales.map(&:to_s).join('|')
      when :week
        '((?!\/).)*'
      else
        available_locales.map(&:to_s).join('|')
      end
    end
  end
end
