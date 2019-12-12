class Todo::List::DeleteItem < Micro::Case
  flow Todo::List::FindItem,
       self.call!,
       Todo::Serialize::AsJson

  attribute :todo

  validates :todo, type: Todo

  def call!
    todo.destroy

    Success { attributes }
  end
end
