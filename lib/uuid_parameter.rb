# frozen_string_literal: true

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

# TODO: #2 move this to the right place... But where?
I18n.load_path += Dir[File.join(__dir__, '../config/locale/*.yml')]

require 'uuid_parameter/railtie'
require 'uuid_parameter/concern'
