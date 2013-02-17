class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :name, :string, :null => false

      t.timestamps
    end

    add_index :users, :name, :unique => true
  end
end
