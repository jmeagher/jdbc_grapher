require 'test_helper'

class JdbcControllerTest < ActionController::TestCase
  test "should get get_data" do
    get :get_data
    assert_response :success
  end

end
