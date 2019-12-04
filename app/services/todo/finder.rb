class Todo::Finder < Todo::ServiceObject
  def find_todo
    user.todos.find(params[:id])
  end

  def find_todos(result_as_json: false)
    relation = todos.where(user_id: user.id)

    return relation unless result_as_json

    relation.map { |todo| serialize_todo(todo) }
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
