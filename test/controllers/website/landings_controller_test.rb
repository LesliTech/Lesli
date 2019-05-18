require 'test_helper'

class Website::LandingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @website_landing = website_landings(:one)
  end

  test "should get index" do
    get website_landings_url
    assert_response :success
  end

  test "should get new" do
    get new_website_landing_url
    assert_response :success
  end

  test "should create website_landing" do
    assert_difference('Website::Landing.count') do
      post website_landings_url, params: { website_landing: {  } }
    end

    assert_redirected_to website_landing_url(Website::Landing.last)
  end

  test "should show website_landing" do
    get website_landing_url(@website_landing)
    assert_response :success
  end

  test "should get edit" do
    get edit_website_landing_url(@website_landing)
    assert_response :success
  end

  test "should update website_landing" do
    patch website_landing_url(@website_landing), params: { website_landing: {  } }
    assert_redirected_to website_landing_url(@website_landing)
  end

  test "should destroy website_landing" do
    assert_difference('Website::Landing.count', -1) do
      delete website_landing_url(@website_landing)
    end

    assert_redirected_to website_landings_url
  end
end
