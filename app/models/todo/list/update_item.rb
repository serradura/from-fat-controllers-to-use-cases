class Todo::List::UpdateItem < Micro::Case
  flow Todo::List::FindItem,
       self.call!

  attributes :todo, :params

  validates :todo, type: Todo
  validates :params, type: ActionController::Parameters

  def call!
    todo_params = Todo::Params.to_save(params)

    todo.update(todo_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
