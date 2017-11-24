module Admin
  class LocationsController < ::Admin::BaseController
    include AdminCrud
    include AdminEnableable
    include AdminSequenceable

    protected

    def permitted_params
      params.require(:location).permit(:name, :slug)
    end
  end
end
