# frozen_string_literal: true

require 'rails'

module UUIDParameter
  class Engine < ::Rails::Engine; end

  class Railtie < ::Rails::Railtie # :nodoc:
    config.uuid_parameter = ActiveSupport::OrderedOptions.new

    initializer 'uuid_parameter-i18n' do |app|
      UUIDParameter::Railtie.instance_eval do
        pattern = pattern_from app.config.i18n.available_locales

        add("config/locale/#{pattern}.yml")
      end
    end

    protected

    def self.add(pattern)
      files = Dir[File.join(__dir__, '../..', pattern)]
      I18n.load_path.concat(files)
    end

    def self.pattern_from(args)
      array = Array(args || [])
      array.blank? ? '*' : "#{array.join(',')}"
    end
  end
end
