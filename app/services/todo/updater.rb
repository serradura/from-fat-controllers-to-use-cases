class Todo::Updater < Todo::ServiceObject
  def update_todo(result_as_json: false)
    todo = find_todo

    todo.update(todo_params)

    result = result_as_json ? serialize_todo(todo) : todo

    [todo.valid?, result]
  end

  def complete_todo(result_as_json: false)
    todo = find_todo

    todo.completed_at = Time.current unless todo.completed?

    todo.save if todo.completed_at_changed?

    result_as_json ? serialize_todo(todo) : todo
  end

  def activate_todo(result_as_json: false)
    todo = find_todo

    todo.completed_at = nil unless todo.active?

    todo.save if todo.completed_at_changed?

    result_as_json ? serialize_todo(todo) : todo
  end
end
