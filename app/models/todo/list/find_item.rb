class Todo::List::FindItem < Micro::Case
  attributes :user, :todo_id

  validates :user, type: User
  validates :todo_id, numericality: { only_integer: true }

  def call!
    todo = user.todos.find_by(id: todo_id&.strip)

    return Success { { todo: todo } } if todo

    Failure(:todo_not_found)
  end
end
