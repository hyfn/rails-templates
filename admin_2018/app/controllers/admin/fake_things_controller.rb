class Admin::FakeThingsController < Admin::BaseController
  include Crud
  include Enableable
  include Sequenceable

  protected

  def permitted_params
    # params.require(:fake_thing).permit(:name, :slug, :location_id, :image)
    params.require(:fake_thing).permit(:name, :slug, :location_id)
  end
end
