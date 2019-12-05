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

  def self.where_status(status)
    case status&.strip&.downcase
    when Status::ACTIVE then Todo.active
    when Status::OVERDUE then Todo.overdue
    when Status::COMPLETED then Todo.completed
    else Todo.all
    end
  end

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
    return Status::COMPLETED if completed?
    return Status::OVERDUE if overdue?

    Status::ACTIVE
  end
end
