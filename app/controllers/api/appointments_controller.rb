module Api
  class AppointmentsController < ApplicationController
    before_action :authenticated_user!

    def create
      return unauthorized_response unless current_user.has_role?(:patient)

      time_slot = TimeSlot.available.find_by(id: params[:time_slot_id])

      if time_slot && time_slot.start_time > Time.current
        appointment = current_user.appointments.new(
          time_slot: time_slot,
          doctor_id: time_slot.doctor_id, 
          patient_id: current_user.id
        )

        if time_slot_within_doctor_slots?(time_slot) && appointment.valid?
          appointment.save
          render json: { success: true, appointment: appointment }, status: :created
        else
          render json: { success: false, errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { success: false, message: "Invalid or unavailable time slot" }, status: :unprocessable_entity
      end
    end

    private

    def time_slot_within_doctor_slots?(time_slot)
      if time_slot.doctor.time_slots.exists?(id: time_slot.id)
        true
      else
        appointment.errors.add(:time_slot, "is not within the available time slots.")
        false
      end
    end

    def unauthorized_response
      render json: { success: false, message: "Unauthorized" }, status: :unauthorized
    end
  end
end
