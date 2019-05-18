require 'test_helper'

class Website::PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @website_page = website_pages(:one)
  end

  test "should get index" do
    get website_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_website_page_url
    assert_response :success
  end

  test "should create website_page" do
    assert_difference('Website::Page.count') do
      post website_pages_url, params: { website_page: {  } }
    end

    assert_redirected_to website_page_url(Website::Page.last)
  end

  test "should show website_page" do
    get website_page_url(@website_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_website_page_url(@website_page)
    assert_response :success
  end

  test "should update website_page" do
    patch website_page_url(@website_page), params: { website_page: {  } }
    assert_redirected_to website_page_url(@website_page)
  end

  test "should destroy website_page" do
    assert_difference('Website::Page.count', -1) do
      delete website_page_url(@website_page)
    end

    assert_redirected_to website_pages_url
  end
end
