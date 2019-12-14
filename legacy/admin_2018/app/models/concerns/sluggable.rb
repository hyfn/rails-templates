module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug
    validate :validate_slug
  end

  def self.slugify_string(str, model, scope_conditions=nil)
    slug_prefix = str.downcase.parameterize(separator: '-')
    # all logic below makes sure you're not creating a duplicate slug

    existing_slugs = model.where(scope_conditions).where("slug like '#{slug_prefix}%'").pluck('slug')
    if existing_slugs.empty?
      slug_prefix
    else
      max = existing_slugs.map do |s|
        s[slug_prefix.length..-1].to_i.abs # extract suffix, convert suffix to integer or 0 if not numeric str (doing abs because suffix starts with '-' (dash or negative sign)
      end.max
      "#{slug_prefix}-#{max + 1}"
    end
  end

  module ClassMethods
    attr_reader :sluggable_attribute, :sluggable_scope
    def slug_from(attr_name, scope = nil)
      @sluggable_attribute = attr_name
      @sluggable_scope = scope
      if sluggable_scope
        validates :slug, uniqueness: { scope: sluggable_scope }, presence: true
      else
        validates :slug, uniqueness: true, presence: true
      end
    end
  end

  def validate_slug
    # regex based off of one from source of https://apidock.com/rails/ActiveSupport/Inflector/parameterize
    unless /\A[a-z0-9\-_]+\Z/.match(slug)
      self.errors[:slug] << "should only contain lower case alphanumeric characters, '-', or '_'"
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
      self.slug = Sluggable.slugify_string(slug_attr, self.class, slug_scope_conditions)
    end
  end

  def to_param
    slug
  end

  private

  def slug_scope_conditions
    if self.class.sluggable_scope
      self.class.sluggable_scope.each_with_object({}) do |elem, obj|
        obj[elem] = send(elem)
      end
    else
      nil
    end
  end
end
