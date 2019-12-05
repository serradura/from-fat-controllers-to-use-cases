class Todo::List::DeleteItem < Micro::Case
  attributes :user, :todo_id

  validates :user, type: User
  validates :todo_id, numericality: { only_integer: true }

  def call!
    todo = user.todos.find_by(id: todo_id&.strip)

    return Failure(:todo_not_found) unless todo

    todo.destroy

    Success { { todo: Todo::Serialization.as_json(todo) } }
  end
end
