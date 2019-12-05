class Todo::Destroy
  include Interactor

  def call
    user = context.user
    todo = context.todo

    return context.fail!(message: "user not found") unless user
    return context.fail!(message: "todo not found") unless todo

    todo.destroy
  end
end
