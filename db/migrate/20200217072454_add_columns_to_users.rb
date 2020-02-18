class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :external_id, :string
  	add_column :users, :department, :string
  	add_column :users, :project, :string
  	add_column :users, :emp_id, :string
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  end

end
