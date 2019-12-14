class PagesController < BaseController
  def home
    cache_for default_expiry
  end

  def about
    cache_for default_expiry
  end
end
