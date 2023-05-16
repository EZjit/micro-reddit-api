# frozen_string_literal: true

class OneWordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, message: 'must be one word') unless value.to_s.squish.split.size == 1
  end
end
