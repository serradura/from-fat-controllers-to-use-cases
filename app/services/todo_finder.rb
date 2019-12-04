class TodoFinder
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def find_todo
    user.todos.find(params[:id])
  end

  def find_todos
    todos.where(user_id: user.id)
  end

  private

    def todos
      case params[:status]&.strip&.downcase
      when 'active' then Todo.active
      when 'overdue' then Todo.overdue
      when 'completed' then Todo.completed
      else Todo.all
      end
    end
end
