class TodosController < ApplicationController
  before_action :authenticate_user

  def index
    todos =
      case params[:status]&.strip&.downcase
      when 'active' then Todo.active
      when 'overdue' then Todo.overdue
      when 'completed' then Todo.completed
      else Todo.all
      end

    json = todos.where(user_id: current_user.id).map { |todo| todo_as_json(todo) }

    render_json(200, todos: json)
  end

  def create
    todo = current_user.todos.create(todo_params)

    if todo.valid?
      render_json(201, todo: todo_as_json(todo))
    else
      render_json(422, todo: todo.errors.as_json)
    end
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def destroy
    todo = current_user.todos.find(params[:id])

    todo.destroy

    render_json(200, todo: todo_as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def update
    todo = current_user.todos.find(params[:id])

    todo.update(todo_params)

    if todo.valid?
      render_json(200, todo: todo_as_json(todo))
    else
      render_json(422, todo: todo.errors.as_json)
    end
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def complete
    todo = current_user.todos.find(params[:id])

    todo.complete!

    render_json(200, todo: todo_as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def activate
    todo = current_user.todos.find(params[:id])

    todo.activate!

    render_json(200, todo: todo_as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  private

    def todo_params
      params.require(:todo).permit(:title, :due_at)
    end

    def todo_as_json(todo)
      todo.as_json(except: [:user_id], methods: :status)
    end
end
