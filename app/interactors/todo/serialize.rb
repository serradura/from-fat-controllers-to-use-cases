class Todo::Serialize
  include Interactor

  def call
    todo = context.todo

    return context.fail!(message: "todo not found") unless todo

    context.todo_as_json =
      if todo.invalid?
        todo.errors.as_json
      else
        todo.as_json(except: [:user_id], methods: :status)
      end

    context.fail! if todo.invalid?
  end
end
