class Todo::List
  attr_reader :user, :todos

  singleton_class.send(:alias_method, :of, :new)

  def initialize(user)
    @user = user
    @todos = user.todos
  end

  def add_item(params)
    todos.create(params)
  end

  def update_item(id, params)
    find_todo(id) { |todo| todo.update(params) }
  end

  def delete_item(id)
    find_todo(id) { |todo| todo.destroy }
  end

  def complete_item(id)
    find_todo(id) do |todo|
      todo.completed_at = Time.current unless todo.completed?

      todo.save if todo.completed_at_changed?
    end
  end

  def activate_item(id)
    find_todo(id) do |todo|
      todo.completed_at = nil unless todo.active?

      todo.save if todo.completed_at_changed?
    end
  end

  def fetch_items_by_status(status)
    Todo.by_status(status).where(user_id: user.id)
  end

  private

    def find_todo(id)
      todo = todos.find(id)

      yield todo

      todo
    end
end
