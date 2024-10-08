class AppointmentReminderMailer < ApplicationMailer
	def appointment_reminder(appointment)
    @appointment = appointment
    mail(to: @appointment.patient.email, subject: 'Appointment Reminder')
  end
end
