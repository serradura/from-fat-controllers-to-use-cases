class TodosController < ApplicationController
  before_action :authenticate_user

  def index
    result = FindTodos.call(user: current_user, params: params)

    render_json(200, todos: result.todos_as_json)
  end

  def create
    result = CreateTodo.call(user: current_user, params: params)

    status = result.success? ? 201 : 422

    render_json(status, todo: result.todo_as_json)
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def destroy
    result = DestroyTodo.call(user: current_user, params: params)

    render_json(200, todo: result.todo_as_json)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def update
    result = UpdateTodo.call(user: current_user, params: params)

    status = result.success? ? 200 : 422

    render_json(status, todo: result.todo_as_json)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def complete
    result = CompleteTodo.call(user: current_user, params: params)

    render_json(status, todo: result.todo_as_json)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def activate
    result = ActivateTodo.call(user: current_user, params: params)

    render_json(status, todo: result.todo_as_json)
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end
end
