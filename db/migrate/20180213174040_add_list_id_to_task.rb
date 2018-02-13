class AddListIdToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :listId, :integer
  end
end
