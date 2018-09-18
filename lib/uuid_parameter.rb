# frozen_string_literal: true

require 'uuid_parameter/uuid_version4_validator'

# == UUIDParameter
#
# UUIDParameter module provides support for UUIDs in models.  It takes care of
# generating (if one was not provided), validating, and keeping this UUID
# intact, protecting the :uuid field from being changed once set.  Models
# including the UUIDParameter module will use their :uuid rather than their :id
# for URLs.
#
module UUIDParameter
  extend ActiveSupport::Concern
  included do
    validates_with UUIDVersion4Validator

    before_validation :assign_uuid, on: :create
    before_save :keep_existing_uuid

    def to_param
      uuid.to_s
    end

    private

    def assign_uuid
      self.uuid ||= SecureRandom.uuid
    end

    def keep_existing_uuid
      self.uuid = uuid_was if existing_uuid_changed?
    end

    def existing_uuid_changed?
      !new_record? && uuid_changed?
    end
  end
end
