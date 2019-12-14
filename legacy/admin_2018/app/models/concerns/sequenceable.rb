module Sequenceable
  extend ActiveSupport::Concern

  included do
    before_validation :set_default_sequence
  end

  def set_default_sequence
    self.seq ||= (self.class.maximum(:seq) || 0) + 1
  end

  def promote!
    other = self.class.unscoped.order(seq: :desc).where('seq < ?', seq).sequence_scoped(self).first # rubocop:disable Rails/FindBy
    return unless other
    self.class.transaction do
      other_sequence = other.seq
      other.update_columns(seq: self.seq)
      update_columns(seq: other_sequence)
    end
  end

  def demote!
    other = self.class.unscoped.order(seq: :asc).where('seq > ?', seq).sequence_scoped(self).first # rubocop:disable Rails/FindBy
    return unless other
    self.class.transaction do
      other_sequence = other.seq
      other.update_columns(seq: self.seq)
      update_columns(seq: other_sequence)
    end
  end

  module ClassMethods
    attr_reader :sequence_scope_attributes
    def scope_sequence_with(*attr_names)
      @sequence_scope_attributes = attr_names
    end

    def in_sequence
      order('seq ASC NULLS LAST')
    end

    def sequence_scoped(obj)
      if sequence_scope_attributes.blank?
        where(nil)
      else
        where(
          (sequence_scope_attributes.presence || []).each_with_object({}) do |attr, hash|
            hash[attr] = obj.send(attr)
          end
        )
      end
    end
  end
end
