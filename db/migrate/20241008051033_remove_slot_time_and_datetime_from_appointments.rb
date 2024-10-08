class RemoveSlotTimeAndDatetimeFromAppointments < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :slot_time, :string
    remove_column :appointments, :datetime, :string
  end
end
