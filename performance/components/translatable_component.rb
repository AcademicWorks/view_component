# frozen_string_literal: true

class Performance::TranslatableComponent < ViewComponent::Base
  include ViewComponent::Translatable

  def initialize(key)
    @key = key
  end

  def self.virtual_path
    "/translatable_component"
  end
end
