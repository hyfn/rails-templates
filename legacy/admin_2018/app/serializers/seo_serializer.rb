class SeoSerializer
  attr_accessor :record

  def initialize(record)
    @record = record
  end

  def to_params
    {
      title: fetch_attr_val(:seo_title, :title, :name),
      description: fetch_attr_val(:seo_description, :subtitle, :description),
      og_title: fetch_attr_val(:seo_og_title, :seo_title, :title, :name),
      og_description: fetch_attr_val(:seo_og_description, :seo_description),
      og_image: fetch_attr_val(:seo_og_image, :seo_og_image_fallback),
      twitter_card: fetch_attr_val(:seo_twitter_card),
      twitter_title: fetch_attr_val(:seo_twitter_title, :set_title, :title, :name),
      twitter_description: fetch_attr_val(:seo_twitter_description, :seo_description),
      twitter_image_src: fetch_attr_val(:seo_twitter_image_src, :seo_twitter_image_src_fallback),
    }
  end

  protected

  # run through each attribute name in order, return the first one that isn't blank
  def fetch_attr_val(*args)
    args.each do |attr_name|
      if record.respond_to?(attr_name) && record.send(attr_name).present?
        return record.send(attr_name)
      end
    end
    nil
  end
end
