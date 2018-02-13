class AddDefaultValueToTaskChecked < ActiveRecord::Migration[5.1]
  def change
    change_column :tasks, :checked, :boolean, default: false
  end
end
