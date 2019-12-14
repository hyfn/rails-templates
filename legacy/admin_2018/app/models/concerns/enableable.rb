module Enableable
  extend ActiveSupport::Concern

  included do
    validates :enabled, inclusion: [true, false]
  end

  def enable!
    update_attributes!(enabled: true)
  end

  def disable!
    update_attributes!(enabled: false)
  end

  module ClassMethods
    def enabled
      where(enabled: true)
    end

    def disabled
      where(enabled: false)
    end
  end
end
