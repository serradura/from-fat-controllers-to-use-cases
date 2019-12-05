class Todo::Params
  def self.to_save(params)
    params.require(:todo).permit(:title, :due_at)
  end
end
