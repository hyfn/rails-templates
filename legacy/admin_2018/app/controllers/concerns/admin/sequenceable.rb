# Requires Admin::Crud be included as well
module Admin::Sequenceable
  extend ActiveSupport::Concern

  def promote
    resource = find_one
    resource.promote!
    if block_given?
      yield resource
    else
      redirect_to({ action: :index }, notice: "Reordered successfully")
    end
  end

  def demote
    resource = find_one
    resource.demote!
    if block_given?
      yield resource
    else
      redirect_to({ action: :index }, notice: "Reordered successfully")
    end
  end

  ## TODO test me
  # def reorder_all
  #   self.class.resource_class.transaction do
  #     params[:ordered_ids].each_with_index do |id, index|
  #       @market.retailers.find(id).update_attributes!(seq: index)
  #     end
  #   end
  #   if block_given?
  #     yield
  #   else
  #     redirect_to({ action: :index }, notice: "Reordered successfully")
  #   end
  # end
end
