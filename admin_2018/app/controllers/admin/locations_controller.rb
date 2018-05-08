module Admin
  class LocationsController < ::Admin::BaseController
    include Crud
    include Enableable
    include Sequenceable

    protected

    def permitted_params
      params.require(:location).permit(:name, :slug)
    end
  end
end
