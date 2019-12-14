module CanonicalDomain
  extend ActiveSupport::Concern

  def ensure_canonical_domain
    if Rails.env.production? && request.domain == 'herokuapp.com' && ENV['FORCE_CANONICAL_REDIRECT'] == 'true'
      redirect_path = "https://#{ENV['APPLICATION_HOST']}#{request.path}"
      redirect_path += "?#{request.query_string}" if request.query_string.present?
      redirect_to redirect_path, status: 301
    end
  end
end
