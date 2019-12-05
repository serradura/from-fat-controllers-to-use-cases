class Todo::Serialization
  attr_reader :todo

  def self.as_json(todo)
    new(todo).as_json
  end

  def self.map_as_json(todos)
    todos.map { |todo| as_json(todo) }
  end

  def initialize(todo)
    @todo = todo
  end

  def as_json
    if todo.invalid?
      todo.errors.as_json
    else
      todo.as_json(except: [:user_id], methods: :status)
    end
  end
end
