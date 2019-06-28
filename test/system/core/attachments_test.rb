require "application_system_test_case"

class Core::AttachmentsTest < ApplicationSystemTestCase
  setup do
    @core_attachment = core_attachments(:one)
  end

  test "visiting the index" do
    visit core_attachments_url
    assert_selector "h1", text: "Core/Attachments"
  end

  test "creating a Attachment" do
    visit core_attachments_url
    click_on "New Core/Attachment"

    click_on "Create Attachment"

    assert_text "Attachment was successfully created"
    click_on "Back"
  end

  test "updating a Attachment" do
    visit core_attachments_url
    click_on "Edit", match: :first

    click_on "Update Attachment"

    assert_text "Attachment was successfully updated"
    click_on "Back"
  end

  test "destroying a Attachment" do
    visit core_attachments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Attachment was successfully destroyed"
  end
end
