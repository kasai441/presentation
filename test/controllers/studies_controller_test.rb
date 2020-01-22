require 'test_helper'

class StudiesControllerTest < ActionDispatch::IntegrationTest
  test "should get chart" do
    get studies_chart_url
    assert_response :success
  end

end
