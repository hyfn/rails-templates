module Admin
  class BaseController < ApplicationController
    include Source

    skip_before_action :ensure_canonical_domain
    before_action :ensure_admin_domain
    before_action :authenticate_admin_user!

    layout 'admin'
  end
end
