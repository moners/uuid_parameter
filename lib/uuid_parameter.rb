# frozen_string_literal: true

require 'uuid_parameter/uuid_version4_validator'

# TODO: move this to the right place... But where?
I18n.load_path << File.expand_path("locale/en.yml", __dir__)

# == UUIDParameter
#
# UUIDParameter module provides support for UUIDs in models.  It takes care of
# generating (if one was not provided), validating, and keeping this UUID
# intact, protecting the :uuid field from being changed once set.  Models
# including the UUIDParameter module will use their :uuid rather than their :id
# for URLs.
#
# class User < ActiveRecord::Base
#   include UUIDParameter
# end
#
# user = User.new
# user.uuid         # => nil
# user.save         # => true
# user.uuid         # => some UUID was generated
# user.uuid = 'foo'
# user.save         # => true
# user.uuid         # => original UUID is preserved
#
# user = User.create(uuid: '8bb96d58-2efd-45df-833b-119971a19fea')
# user.update_attribute(uuid: '00000000-aaaa-45df-cccc-119971a19fea') # => true
# user.reload.uuid  # => '8bb96d58-2efd-45df-833b-119971a19fea' (unchanged)
# user.to_param     # => '8bb96d58-2efd-45df-833b-119971a19fea'
#
module UUIDParameter
  extend ActiveSupport::Concern

  # Note the static '4' in the third group: that's the UUID version.
  UUID_V4_REGEX = %r[\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}\z]

  included do
    validates_with UUIDVersion4Validator

    before_validation :assign_uuid
    before_save :recover_uuid

    def to_param
      uuid.to_s
    end

    private

    def assign_uuid
      self.uuid ||= SecureRandom.uuid
    end

    def existing_uuid_changed?
      !new_record? && !uuid_was.nil? && uuid_changed?
    end

    def recover_uuid
      self.uuid = uuid_was if existing_uuid_changed?
      reset_uuid! unless UUID_V4_REGEX.match?(self.uuid)
    end

    def reset_uuid!
      self.uuid = nil
      assign_uuid
    end
  end
end
