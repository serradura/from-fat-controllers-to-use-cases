class Todo::Create
  include Interactor

  def call
    user = context.user

    return context.fail!(message: "user not found") unless user

    todo = user.todos.create(context.todo_params)

    context.todo = todo
  end
end
