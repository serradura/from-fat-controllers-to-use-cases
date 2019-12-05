class Todo::Serialization
  def self.as_json(todo)
    return todo.errors.as_json if todo.invalid?

    todo.as_json(except: [:user_id], methods: :status)
  end

  def self.map_as_json(todos)
    todos.map { |todo| as_json(todo) }
  end
end
