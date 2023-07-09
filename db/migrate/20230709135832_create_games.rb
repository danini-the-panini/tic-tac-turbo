class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :player_o, null: true, foreign_key: { to_table: :players }
      t.references :player_x, null: true, foreign_key: { to_table: :players }
      t.string :board_data, null: false, default: ' '*9
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
