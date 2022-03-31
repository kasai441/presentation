# frozen_string_literal: true

require 'rails_helper'

describe StudiesController, type: :system do
  before do
    visit root_url
  end
  it 'is valid with get_chart_list_service' do
    expect(page).to have_content 'Ruby on Rails'
  end
end
