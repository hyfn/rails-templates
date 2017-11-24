# TODO Delete me when done
class FakeThing < ApplicationRecord
  include Enableable
  include Sequenceable
  include Sluggable

  mount_uploader :image, BasicUploader

  slug_from :name
  scope_sequence_with :location

  belongs_to :location
end
