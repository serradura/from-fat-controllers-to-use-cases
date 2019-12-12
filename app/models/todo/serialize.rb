class Todo::Serialize
  def self.as_json(todo)
    todo.as_json(except: [:user_id], methods: :status)
  end

  def self.collection_as_json(todos)
    todos.map { |todo| as_json(todo) }
  end

  class AsJson < Micro::Case
    attribute :todo

    validates :todo, type: Todo

    def call!
      return Success { { todo: Todo::Serialize.as_json(todo) } } if todo.valid?

      Failure(:invalid_todo) { { errors: todo.errors.as_json } }
    end
  end
end
