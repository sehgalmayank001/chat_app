class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :conversation
      t.integer :messager_type
      t.text :body

      t.timestamps
    end
  end
end
