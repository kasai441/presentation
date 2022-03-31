# frozen_string_literal: true

class Study < ApplicationRecord
  def get_list
    ready_x_months
  end
end
