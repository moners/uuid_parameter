# frozen_string_literal: true

module UUIDParameter
  # Validate a UUID v4: it must be correctly formatted and cannot change.
  # This latter responsibility is defined in the UUIDParameter model concern.
  class UUIDVersion4Validator < ActiveModel::Validator
    def validate(record)
      record.errors.add(:uuid, :not_a_uuid_v4) unless UUID_V4_REGEX.match?(record.uuid)
    end
  end
end
