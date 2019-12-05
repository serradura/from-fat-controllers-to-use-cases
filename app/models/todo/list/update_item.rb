class Todo::List::UpdateItem < Micro::Case
  attributes :user, :todo_id, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters
  validates :todo_id, numericality: { only_integer: true }

  def call!
    todo_params = Todo::Params.to_save(params)

    todo = user.todos.find_by(id: todo_id&.strip)

    return Failure(:todo_not_found) unless todo

    todo.update(todo_params)

    todo_as_json = Todo::Serialization.as_json(todo)

    return Success { { todo: todo_as_json } } if todo.valid?

    Failure(:invalid_todo) { { errors: todo_as_json } }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
