class Todo::List::AddItem < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    todo_params = Todo::Params.to_save(params)

    todo = user.todos.create(todo_params)

    todo_as_json = Todo::Serialization.as_json(todo)

    return Success { { todo: todo_as_json } } if todo.persisted?

    Failure(:invalid_todo) { { errors: todo_as_json } }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
