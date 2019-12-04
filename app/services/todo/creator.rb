class Todo::Creator < Todo::ServiceObject
  def create_todo(result_as_json: false)
    todo_params = params.require(:todo).permit(:title, :due_at)

    todo = user.todos.create(todo_params)

    result = result_as_json ? serialize_todo(todo) : todo

    [todo.valid?, result]
  end
end
