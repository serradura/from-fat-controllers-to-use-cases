class TodoUpdater
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def update_todo
    todo = find_todo

    todo_params = params.require(:todo).permit(:title, :due_at)

    todo.update(todo_params)

    todo
  end

  def complete_todo
    todo = find_todo

    todo.completed_at = Time.current unless todo.completed?
    todo.save if todo.completed_at_changed?

    todo
  end

  def activate_todo
    todo = find_todo

    todo.completed_at = nil unless todo.active?
    todo.save if todo.completed_at_changed?

    todo
  end

  private

    def find_todo
      TodoFinder.new(user, params).find_todo
    end
end
