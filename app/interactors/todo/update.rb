class Todo::Update
  include Interactor

  def call
    todo = context.todo

    return context.fail!(message: "todo not found") unless todo

    todo.update(context.todo_params)
  end
end
