class AddDebugEnabledToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :debug_user, :default => false
    end
  end
end
