require 'test_helper'

class Core::AttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @core_attachment = core_attachments(:one)
  end

  test "should get index" do
    get core_attachments_url
    assert_response :success
  end

  test "should get new" do
    get new_core_attachment_url
    assert_response :success
  end

  test "should create core_attachment" do
    assert_difference('Core::Attachment.count') do
      post core_attachments_url, params: { core_attachment: {  } }
    end

    assert_redirected_to core_attachment_url(Core::Attachment.last)
  end

  test "should show core_attachment" do
    get core_attachment_url(@core_attachment)
    assert_response :success
  end

  test "should get edit" do
    get edit_core_attachment_url(@core_attachment)
    assert_response :success
  end

  test "should update core_attachment" do
    patch core_attachment_url(@core_attachment), params: { core_attachment: {  } }
    assert_redirected_to core_attachment_url(@core_attachment)
  end

  test "should destroy core_attachment" do
    assert_difference('Core::Attachment.count', -1) do
      delete core_attachment_url(@core_attachment)
    end

    assert_redirected_to core_attachments_url
  end
end
