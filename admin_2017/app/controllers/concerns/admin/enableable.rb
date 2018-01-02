# Requires SimpleCrud be included as well
module Admin
  module Enableable
    extend ActiveSupport::Concern

    def enable
      resource = find_one
      resource.enable!
      if block_given?
        yield resource
      else
        redirect_to({ action: :index }, notice: "Enabled")
      end
    end

    def disable
      resource = find_one
      resource.disable!
      if block_given?
        yield resource
      else
        redirect_to({ action: :index }, notice: "Disabled")
      end
    end
  end
end
