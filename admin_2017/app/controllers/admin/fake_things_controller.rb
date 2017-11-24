module Admin
  class FakeThingsController < BaseController
    include AdminCrud
    include AdminEnableable
    include AdminSequenceable

    protected

    def permitted_params
      params.require(:fake_thing).permit(:name, :slug, :location_id, :image, :image_cache)
    end
  end
end
