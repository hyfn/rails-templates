module Admin
  class SessionsController < ApplicationController
    # include AdminSource
    # before_action :ensure_admin_domain

    layout false

    def new; end

    def create
      if params[:password] == ENV['ADMIN_PASSWORD']
        session[:logged_in] = true
        redirect_to session.delete(:return_to) || admin_root_path
      else
        @error = true
        render action: "new"
      end
    end

    def destroy
      session[:logged_in] = nil
      redirect_to [:new, :admin, :sessions]
    end
  end
end
