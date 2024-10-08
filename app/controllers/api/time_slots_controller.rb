module Api
  class TimeSlotsController < ApplicationController
    before_action :authenticated_user!

    def index
      doctors = User.joins(:time_slots)
                    .joins("INNER JOIN users_roles ON users_roles.user_id = users.id")
                    .joins("INNER JOIN roles ON roles.id = users_roles.role_id")
                    .where(roles: { name: "doctor" })

      # If a query for doctor's name is provided, filter the doctors
      if params[:query].present?
        doctors = doctors.where("users.first_name ILIKE :query OR users.last_name ILIKE :query", query: "%#{params[:query]}%")
      end

      available_slots = doctors.map { |doctor| doctor_time_slot(doctor) }

      render json: { success: true, doctors: available_slots }, status: :ok
    end

    def create
      return unauthorized_response unless current_user.has_role?(:doctor)
      time_slot = current_user.time_slots.new(time_slot_params)

      if time_slot.save
        render json: { success: true, time_slot: time_slot }, status: :created
      else
        render json: { success: false, errors: time_slot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def time_slot_params
      params.require(:time_slot).permit(:for_date, :start_time, :end_time)
    end

    def doctor_time_slot(doctor)
      {
        doctor_name: "#{doctor.first_name} #{doctor.last_name}",
        slots: doctor.time_slots.where("for_date >= ?", Date.today),
        next_available_slot: doctor.time_slots.where("for_date >= ?", Date.today).order(:start_time).first
      }
    end

    def unauthorized_response
      render json: { success: false, message: "Unauthorized" }, status: :unauthorized
    end
  end
end
