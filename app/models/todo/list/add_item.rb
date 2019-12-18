class Todo::List::AddItem < Micro::Case
  flow self.call!

  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    todo_params = Todo::Params.to_save(params)

    todo = user.todos.create(todo_params)

    Success { { todo: todo} }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
