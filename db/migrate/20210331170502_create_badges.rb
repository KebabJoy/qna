class CreateBadges < ActiveRecord::Migration[6.1]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :img_url
      t.belongs_to :user
      t.belongs_to :question

      t.timestamps
    end
  end
end
