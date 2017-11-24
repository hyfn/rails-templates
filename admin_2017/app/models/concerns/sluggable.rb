module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug
  end

  def self.slugify_string(str)
    str.downcase.parameterize(separator: '-')
  end

  module ClassMethods
    attr_reader :sluggable_attribute
    def slug_from(attr_name)
      @sluggable_attribute = attr_name
    end
  end

  def generate_slug
    slug_attr = send(self.class.sluggable_attribute)
    if slug_attr.present? && !slug.present?
      self.slug = Sluggable.slugify_string(slug_attr)
    end
  end
end
