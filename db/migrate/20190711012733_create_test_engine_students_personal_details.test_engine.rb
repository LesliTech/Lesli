# This migration comes from test_engine (originally 20190710191659)
class CreateTestEngineStudentsPersonalDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :test_engine_students_personal_details do |t|

      t.timestamps
    end
  end
end
