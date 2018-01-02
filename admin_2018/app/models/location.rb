# TODO Delete me when done
class Location < ApplicationRecord
  include Enableable
  include Sequenceable
  include Sluggable

  slug_from :name

  has_many :fake_things
end
