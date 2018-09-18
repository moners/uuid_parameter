# frozen_string_literal: true

module UUIDParameter
  # Validate a UUID v4: it must be correctly formatted and cannot change.
  # This latter responsibility is defined in the UUIDParameter model concern.
  class UUIDVersion4Validator < ActiveModel::Validator
    # Note the static '4' in the third group: that's the UUID version.
    UUID_V4_REGEX = %r[\A[a-f0-9]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}\z]

    def validate(record)
      unless UUID_V4_REGEX.match?(record.uuid)
        record.errors.add(:uuid, 'must be a valid random UUID (v4)')
      end
    end
  end
end
