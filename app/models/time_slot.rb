class TimeSlot < ApplicationRecord
	belongs_to :doctor, class_name: "User", foreign_key: :doctor_id

	validates :start_time, :end_time, presence: true
	validate :validates_start_end_time
  validate :validates_availabilty


  scope :available, -> { where.not(id: Appointment.select(:time_slot_id)) }
  scope :upcoming, -> { where('start_time > ?', Time.current) }

  private

  def validates_start_end_time
    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def validates_availabilty
    conflicting_slots = doctor.time_slots.where(for_date: for_date)
                                       .where.not(id: id)
                                       .where("start_time < ? AND end_time > ?", end_time, start_time)

    if conflicting_slots.exists?
      errors.add(:base, "This time slot overlaps with existing availability")
    end
  end
end
