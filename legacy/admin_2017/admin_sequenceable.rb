# Requires SimpleCrud be included as well
module AdminSequenceable
  extend ActiveSupport::Concern

  def promote!
    resource = find_one
    resource.promote!
    yield resource
  end

  def demote!
    resource = find_one
    resource.demote!
    yield resource
  end
end