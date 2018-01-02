module Admin
  class FakeThingsController < BaseController
    include Crud
    include Enableable
    include Sequenceable

    protected

    def permitted_params
      params.require(:fake_thing).permit(:name, :slug, :location_id, :image, :image_cache)
    end
  end
end
