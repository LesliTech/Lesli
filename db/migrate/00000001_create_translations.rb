class CreateTranslations < ActiveRecord::Migration[6.0]
    def change
        create_table :translations do |t|
            t.string    :file
            t.timestamps
        end
        create_table :translation_strings do |t|
            t.string    :entry
            t.string    :lang_en
            t.json      :lang_en_j
            t.string    :lang_es
            t.string    :lang_de
            t.timestamps
        end
        add_reference :translation_strings, :translations, foreign_key: true
    end
end
