class AddFosdemStandFields < ActiveRecord::Migration[5.2]
  def change

    create_table :booth_themes do |t|
      t.string :name

      t.timestamps
    end

    add_column :booths, :duration, :int
    add_column :booths, :logo_url, :string
    add_column :booths, :contact_mail, :string
    add_column :booths, :source_url, :string
    add_column :booths, :requirements, :text
    add_reference :booths, :booth_themes, foreign_key: true

  end
end
