class Todo::ServiceObject
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  protected

    def serialize_todo(todo)
      return todo.errors.as_json if todo.invalid?

      todo.as_json(except: [:user_id], methods: :status)
    end
end
