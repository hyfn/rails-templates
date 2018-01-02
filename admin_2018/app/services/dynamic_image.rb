module DynamicImage
  HELPER_PARAM_MAP = {
    w: :w,
    h: :h,
    version: :v,
    quality: :q,
    gravity: :g,
    format: :f,
  }.freeze

  def self.url_helper(url, opts = {})
    query = HELPER_PARAM_MAP
      .reduce({}) { |h, (k, v)| h.merge(v => opts[k]) }
      .merge(u: url)
    url(query)
  end

  def self.hmac(query)
    str = query.sort_by { |k, _| k }.map { |k, v| "#{k}=#{v}" }.join('&')
    OpenSSL::HMAC.hexdigest('SHA256', ENV['IMAGE_RESIZE_SECRET'], str)
  end

  def self.url(query)
    query = query.reject { |_, v| v.nil? }
    ENV['IMAGE_RESIZE_URL'] + '?' + query.merge(t: hmac(query)).to_query
  end
end
