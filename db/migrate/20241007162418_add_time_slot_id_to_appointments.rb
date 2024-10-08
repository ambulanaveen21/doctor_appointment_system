class AddTimeSlotIdToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :time_slot_id, :integer
  end
end
