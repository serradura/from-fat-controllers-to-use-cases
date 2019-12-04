class TodosController < ApplicationController
  before_action :authenticate_user

  def index
    todos = TodoFinder.new(current_user, params).find_todos

    json = todos.map { |todo| todo_as_json(todo) }

    render_json(200, todos: json)
  end

  def create
    todo = TodoCreator.new(current_user, params).create_todo

    if todo.valid?
      render_json(201, todo: todo_as_json(todo))
    else
      render_json(422, todo: todo.errors.as_json)
    end
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def destroy
    todo = TodoDestroyer.new(current_user, params).destroy_todo

    render_json(200, todo: todo_as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def update
    todo = TodoUpdater.new(current_user, params).update_todo

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
    todo = TodoUpdater.new(current_user, params).complete_todo

    render_json(200, todo: todo_as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def activate
    todo = TodoUpdater.new(current_user, params).activate_todo

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
