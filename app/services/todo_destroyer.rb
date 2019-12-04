class TodoDestroyer
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def destroy_todo
    todo = TodoFinder.new(user, params).find_todo

    todo.destroy

    todo
  end
end
