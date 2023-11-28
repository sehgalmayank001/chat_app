class CreateConversation < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :profile
      t.string :user_name
      
      t.timestamps
    end
  end
end
