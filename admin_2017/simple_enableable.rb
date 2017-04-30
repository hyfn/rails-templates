# Requires SimpleCrud be included as well
module SimpleEnableable
  extend ActiveSupport::Concern

  def enable!
    resource = find_one
    resource.update!(enabled: true)
    yield resource
  end

  def disable!
    resource = find_one
    resource.update!(enabled: false)
    yield resource
  end
end