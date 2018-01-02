module SeoHelper
  def seo_tags(page_slug = nil, custom_attributes = {}, additional_schema = [])
    static_defaults = {
      og_type: 'website',
      og_url: url_for(host: ENV['APPLICATION_HOST']),
      twitter_card: 'summary_large_image',
      image: bucket_image_url('test/2.jpg'),   # TODO change me for reals
      logo: bucket_image_url('test/2.jpg'),   # TODO change me for reals
    }

    seo_attrs = static_defaults.with_indifferent_access
      .merge(compact_hash(I18n.t('global.seo')))

    if page_slug
      seo_attrs = seo_attrs.merge(compact_hash(I18n.t("#{page_slug}.seo")))
    end
    seo_attrs = seo_attrs.merge(compact_hash(custom_attributes))

    # fallback to generic tags for social-specific ones
    # TODO: this should probably done in conjunction with each merge
    seo_attrs = seo_attrs.reverse_merge(
      og_title: seo_attrs[:title],
      twitter_title: seo_attrs[:title],
      og_description: seo_attrs[:description],
      twitter_description: seo_attrs[:description],
      og_image: seo_attrs[:image],
      twitter_image_src: seo_attrs[:image],
      twitter_creator: seo_attrs[:twitter_creator],
    )

    schema_json = [
      {
        "@context": 'http://schema.org',
        "@type": 'Corporation',
        name: I18n.t('global.schema_json.name'),
        logo: static_defaults[:logo],
        image: static_defaults[:image],
        description: I18n.t('homepage.seo.description', default: I18n.t('global.seo.description')),
        url: I18n.t('global.schema_json.url'),
        email: I18n.t('global.schema_json.email'),
        sameAs: I18n.t('global.schema_json.url')
      }, {
        "@context": 'http://schema.org',
        "@type": 'WebSite',
        name: I18n.t('global.schema_json.name'),
        url: I18n.t('global.schema_json.url'),
      }
    ].concat(additional_schema)

    render 'shared/seo', attrs: seo_attrs, schema_json: schema_json
  end

  protected

  def compact_hash(hsh)
    hsh.delete_if { |_, v| v.blank? }
  end
end
