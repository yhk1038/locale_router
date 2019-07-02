# frozen_string_literal: true

require 'active_support/concern'

module LocaleRouter
  module Checker
    extend ActiveSupport::Concern

    def include(base)
      base.send :include, ClassMethods
    end

    module ClassMethods
      def production?
        Rails.env == 'production'
      end
    end

    def production?
      self.class.production?
    end

    # class << self
    #   def production?
    #     Rails.env == 'production'
    #   end
    # end
  end
end
