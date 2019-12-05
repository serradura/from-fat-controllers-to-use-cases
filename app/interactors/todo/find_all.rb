class Todo::FindAll
  include Interactor

  def call
    user = context.user
    params = context.params

    return context.fail!(message: "user not found") unless user
    return context.fail!(message: "params is missing") unless params

    context.todos = todos_where(params).where(user_id: user.id)
  end

  private

    def todos_where(params)
      case params[:status]&.strip&.downcase
      when 'active' then Todo.active
      when 'overdue' then Todo.overdue
      when 'completed' then Todo.completed
      else Todo.all
      end
    end
end
