class Todo::List::FetchItems < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    todos = Todo.where_status(params[:status]).where(user_id: user.id)

    Success { { todos: Todo::Serialize.collection_as_json(todos) } }
  end
end
