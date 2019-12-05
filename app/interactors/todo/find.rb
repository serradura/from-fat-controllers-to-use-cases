class Todo::Find
  include Interactor

  def call
    user = context.user
    params = context.params

    return context.fail!(message: "user not found") unless user
    return context.fail!(message: "params is missing") unless params

    context.todo = user.todos.find(params[:id])
  end
end
