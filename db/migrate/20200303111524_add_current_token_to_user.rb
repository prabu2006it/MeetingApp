class AddCurrentTokenToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :current_token, :string
  	change_column :users, :role, :string
  end
end
