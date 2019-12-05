class TodosController < ApplicationController
  before_action :authenticate_user

  def index
    Todo::List::FetchItems
      .call(user: current_user, params: params)
      .on_success { |result| render_json(200, todos: result[:todos]) }
  end

  def create
    Todo::List::AddItem
      .call(user: current_user, params: params)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_todo) { |todo| render_json(422, todo: todo[:errors]) }
      .on_success { |result| render_json(201, todo: result[:todo]) }
  end

  def destroy
    Todo::List::DeleteItem
      .call(user: current_user, todo_id: params[:id])
      .on_failure(:validation_error) { |result| render_json(400, errors: result[:errors]) }
      .on_failure(:todo_not_found) { render_json(404, todo: { id: 'not found' }) }
      .on_success { |result| render_json(200, todo: result[:todo]) }
  end

  def update
    Todo::List::UpdateItem
      .call(user: current_user, todo_id: params[:id], params: params)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:validation_error) { |result| render_json(400, errors: result[:errors]) }
      .on_failure(:todo_not_found) { render_json(404, todo: { id: 'not found' }) }
      .on_failure(:invalid_todo) { |todo| render_json(422, todo: todo[:errors]) }
      .on_success { |result| render_json(200, todo: result[:todo]) }
  end

  def complete
    Todo::List::CompleteItem
      .call(user: current_user, todo_id: params[:id])
      .on_failure(:validation_error) { |result| render_json(400, errors: result[:errors]) }
      .on_failure(:todo_not_found) { render_json(404, todo: { id: 'not found' }) }
      .on_success { |result| render_json(200, todo: result[:todo]) }
  end

  def activate
    Todo::List::ActivateItem
      .call(user: current_user, todo_id: params[:id])
      .on_failure(:validation_error) { |result| render_json(400, errors: result[:errors]) }
      .on_failure(:todo_not_found) { render_json(404, todo: { id: 'not found' }) }
      .on_success { |result| render_json(200, todo: result[:todo]) }
  end
end
