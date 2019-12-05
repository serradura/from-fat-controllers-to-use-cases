class Todo::Update::ToActive
  include Interactor

  def call
    todo = context.todo

    return context.fail!(message: "todo not found") unless todo

    todo.completed_at = nil unless todo.active?

    todo.save if todo.completed_at_changed?
  end
end
