# frozen_string_literal: true

module UUIDParameter
  class Railtie < ::Rails::Railtie
    config.uuid_parameter = ActiveSupport::OrderedOptions.new

    initializer 'uuid_parameter.set_locales' do |app|
      app.config.i18n.load_paths << File.expand_path('../locale', __DIR__)
      app.config.i18n.available_locales = [:en, :fr].freeze
    end
  end
end
