class TodosController < ApplicationController
  before_action :authenticate_user

  def index
    todos = todo_list.fetch_items_by_status(params[:status])

    render_json(200, todos: Todo::Serialization.map_as_json(todos))
  end

  def create
    todo_params = Todo::Params.to_save(params)

    todo = todo_list.add_item(todo_params)

    status = todo.persisted? ? 201 : 422

    render_json(status, todo: Todo::Serialization.as_json(todo))
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def destroy
    todo = todo_list.delete_item(params[:id])

    render_json(200, todo: Todo::Serialization.as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def update
    todo_params = Todo::Params.to_save(params)

    todo = todo_list.update_item(params[:id], todo_params)

    status = todo.valid? ? 200 : 422

    render_json(status, todo: Todo::Serialization.as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  rescue ActionController::ParameterMissing => e
    render_json(400, error: e.message)
  end

  def complete
    todo = todo_list.complete_item(params[:id])

    render_json(200, todo: Todo::Serialization.as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  def activate
    todo = todo_list.activate_item(params[:id])

    render_json(200, todo: Todo::Serialization.as_json(todo))
  rescue ActiveRecord::RecordNotFound
    render_json(404, todo: { id: 'not found' })
  end

  private

    def todo_list
      @todo_list ||= Todo::List.of(current_user)
    end
end
