class CreateCoreAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :core_attachments do |t|
      t.string :file
      t.timestamps
    end
  end
end
