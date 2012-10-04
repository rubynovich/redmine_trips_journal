class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.column :user_id, :integer
      t.column :project_id, :integer
      t.column :trip_on, :date
      t.column :trip_start_time, :time
      t.column :trip_end_time, :time
      t.column :comments, :string
      t.column :issue_id, :integer
      t.column :estimated_time_id, :integer
      t.column :updated_on, :datetime
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :trips
  end
end
