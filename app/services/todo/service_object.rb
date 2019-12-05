class Todo::ServiceObject
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def find_todo
    user.todos.find(params[:id])
  end

  protected

    def todo_params
      params.require(:todo).permit(:title, :due_at)
    end

    def serialize_todo(todo)
      return todo.errors.as_json if todo.invalid?

      todo.as_json(except: [:user_id], methods: :status)
    end
end
