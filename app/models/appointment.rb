class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: "User", foreign_key: :doctor_id
  belongs_to :time_slot

  after_create :notify_patient

  def notify_patient
    AppointmentReminderMailer.appointment_reminder(self).deliver_later(wait_until: time_slot.start_time - 30.minutes)
  end
end
