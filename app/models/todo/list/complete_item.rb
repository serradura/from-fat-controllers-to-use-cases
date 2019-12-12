class Todo::List::CompleteItem < Micro::Case
  flow Todo::List::FindItem,
       self.call!,
       Todo::Serialize::AsJson

  attribute :todo

  validates :todo, type: Todo

  def call!
    todo.completed_at = Time.current unless todo.completed?

    todo.save if todo.completed_at_changed?

    Success { attributes }
  end
end
