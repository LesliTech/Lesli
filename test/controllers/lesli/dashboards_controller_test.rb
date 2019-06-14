require 'test_helper'

class Lesli::DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesli_dashboard = lesli_dashboards(:one)
  end

  test "should get index" do
    get lesli_dashboards_url
    assert_response :success
  end

  test "should get new" do
    get new_lesli_dashboard_url
    assert_response :success
  end

  test "should create lesli_dashboard" do
    assert_difference('Lesli::Dashboard.count') do
      post lesli_dashboards_url, params: { lesli_dashboard: {  } }
    end

    assert_redirected_to lesli_dashboard_url(Lesli::Dashboard.last)
  end

  test "should show lesli_dashboard" do
    get lesli_dashboard_url(@lesli_dashboard)
    assert_response :success
  end

  test "should get edit" do
    get edit_lesli_dashboard_url(@lesli_dashboard)
    assert_response :success
  end

  test "should update lesli_dashboard" do
    patch lesli_dashboard_url(@lesli_dashboard), params: { lesli_dashboard: {  } }
    assert_redirected_to lesli_dashboard_url(@lesli_dashboard)
  end

  test "should destroy lesli_dashboard" do
    assert_difference('Lesli::Dashboard.count', -1) do
      delete lesli_dashboard_url(@lesli_dashboard)
    end

    assert_redirected_to lesli_dashboards_url
  end
end
