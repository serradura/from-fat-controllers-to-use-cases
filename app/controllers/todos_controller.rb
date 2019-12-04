class TodosController < ApplicationController
  before_action :authenticate_user

  def index
    todos = Todo::Finder.new(current_user, params).find_todos(result_as_json: true)

    render_json(200, todos: todos)
  end

  def create
    success, todo = Todo::Creator.new(current_user, params).create_todo(result_as_json: true)

    status = success ? 201 : 422

    render_json(status, todo: todo)
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def destroy
    todo = Todo::Destroyer.new(current_user, params).destroy_todo(result_as_json: true)

    render_json(200, todo: todo)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def update
    success, todo = Todo::Updater.new(current_user, params).update_todo(result_as_json: true)

    status = success ? 200 : 422

    render_json(status, todo: todo)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def complete
    todo = Todo::Updater.new(current_user, params).complete_todo(result_as_json: true)

    render_json(200, todo: todo)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def activate
    todo = Todo::Updater.new(current_user, params).activate_todo(result_as_json: true)

    render_json(200, todo: todo)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end
end
