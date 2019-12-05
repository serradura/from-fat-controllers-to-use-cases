class Todo::List::CompleteItem < Micro::Case
  attributes :user, :todo_id

  validates :user, type: User
  validates :todo_id, numericality: { only_integer: true }

  def call!
    todo = user.todos.find_by(id: todo_id&.strip)

    return Failure(:todo_not_found) unless todo

    todo.completed_at = Time.current unless todo.completed?

    todo.save if todo.completed_at_changed?

    Success { { todo: Todo::Serialization.as_json(todo) } }
  end
end
