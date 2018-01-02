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
    slug_attr = nil
    if self.class.sluggable_attribute.class.in? [String, Symbol]
      slug_attr = send(self.class.sluggable_attribute)
    else
      slug_attr = self.class.sluggable_attribute.call(self)
    end
    if slug_attr.present? && !slug.present?
      self.slug = Sluggable.slugify_string(slug_attr)
    end
  end

  def to_param
    slug
  end
end
