class TodoCreator
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def create_todo
    todo_params = params.require(:todo).permit(:title, :due_at)

    user.todos.create(todo_params)
  end
end
