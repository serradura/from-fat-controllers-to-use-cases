class Todo::Update::ToCompleted
  include Interactor

  def call
    todo = context.todo

    return context.fail!(message: "todo not found") unless todo

    todo.completed_at = Time.current unless todo.completed?

    todo.save if todo.completed_at_changed?
  end
end

