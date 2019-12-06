class Todo < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :title
    validates :due_at, allow_nil: true
    validates :completed_at, allow_nil: true
  end

  scope :active, -> { where(completed_at: nil) }
  scope :overdue, -> { active.where('due_at <= ?', Time.current) }
  scope :completed, -> { where.not(completed_at: nil) }

  def overdue?
    return false if !due_at || completed_at

    due_at <= Time.current
  end

  def active?
    completed_at.nil?
  end

  def completed?
    !active?
  end

  def status
    return 'completed' if completed?
    return 'overdue' if overdue?

    'active'
  end
end
