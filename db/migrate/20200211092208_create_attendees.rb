class CreateAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :attendees do |t|
      t.references :meeting, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
