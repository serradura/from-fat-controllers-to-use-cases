class Todo::FetchParamsToSave
  include Interactor

  def call
    params = context.params

    return context.fail!(message: "params is missing") unless params

    context.todo_params =
      params.require(:todo).permit(:title, :due_at)
  end
end
