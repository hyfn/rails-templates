class ApplicationController < ActionController::Base
  include PaginationMethods
  include CanonicalDomain

  before_action :ensure_canonical_domain

  protect_from_forgery with: :exception

  def cache_for(cache_time = nil)
    request.session_options[:skip] = true
    expires_in(cache_time || default_expiry, public: true)
  end

  def default_expiry
    if ENV['DEFAULT_EXPIRY_IN_SEC']
      ENV['DEFAULT_EXPIRY_IN_SEC'].to_i.seconds
    else
      1.minute
    end
  end
end
