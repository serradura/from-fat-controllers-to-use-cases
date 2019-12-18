class Todo::List::ActivateItem < Micro::Case
  flow Todo::List::FindItem,
       self.call!

  attribute :todo

  validates :todo, type: Todo

  def call!
    todo.completed_at = nil unless todo.active?

    todo.save if todo.completed_at_changed?

    Success { attributes }
  end
end
