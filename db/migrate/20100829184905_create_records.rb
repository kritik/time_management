class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.date :date
      t.decimal :start, :precision => 2, :scale => 2
      t.decimal :duration, :precision => 2, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end
