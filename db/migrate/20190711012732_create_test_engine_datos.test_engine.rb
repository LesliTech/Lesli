# This migration comes from test_engine (originally 20190710191222)
class CreateTestEngineDatos < ActiveRecord::Migration[5.2]
  def change
    create_table :test_engine_datos do |t|

      t.timestamps
    end
  end
end
