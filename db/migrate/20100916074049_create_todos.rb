class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.date :date
      t.decimal :time

      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
