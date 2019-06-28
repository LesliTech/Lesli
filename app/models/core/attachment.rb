class Core::Attachment < ApplicationRecord
    mount_uploader :file, Core::AttachmentsUploader
end
