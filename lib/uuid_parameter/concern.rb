# frozen_string_literal: true

module UUIDParameter
  extend ActiveSupport::Concern

  # Note the static '4' in the third group: that's the UUID version.
  UUID_V4_REGEX = %r[\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}\z]

  class InvalidRandomUUIDError < ActiveModel::Errors; end

  included do
    validates :uuid,
              presence: true,
              uniqueness: true,
              # format: { with: UUID_V4_REGEX, message: :not_a_uuid_v4 }
              with: :uuid4_validator
    

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

    def uuid4_validator
      errors.add(:uuid, :invalid_random_uuid, message: :not_a_uuid_v4) unless uuid =~ UUID_V4_REGEX
    end
  end
end
