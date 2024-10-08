class RemoveColumnFromAppoinments < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :[], :string
  end
end
