class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :reset_password_token
      t.string :username
      t.integer :role
      t.string :password_digest
      t.boolean :active
      t.datetime :reset_password_token_expires_at
      t.timestamps
    end
  end
end