# TODO Delete me when done
class FakeThing < ApplicationRecord
  include Enableable
  include Sequenceable
  include Sluggable

  # TODO add a carrierwave replacement...

  slug_from :name
  scope_sequence_with :location

  belongs_to :location
end
