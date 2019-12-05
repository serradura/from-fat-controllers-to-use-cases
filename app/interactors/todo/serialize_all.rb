class Todo::SerializeAll
  include Interactor

  def call
    todos = context.todos

    return context.fail!(message: "todos not found") unless todos

    context.todos_as_json = todos.map do |todo|
      Todo::Serialize.call(todo: todo).todo_as_json
    end
  end
end
