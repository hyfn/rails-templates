module Admin
  module Source
    extend ActiveSupport::Concern

    # Want to make sure admins only come to the admin CMS through the
    # heroku app domain, allowing us to use their SSL.
    def ensure_admin_domain
      if Rails.env.production?
        raise ActiveRecord::RecordNotFound unless request.domain == 'herokuapp.com'
      end
    end
  end
end
