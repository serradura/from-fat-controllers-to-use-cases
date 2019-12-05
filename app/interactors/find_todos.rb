class FindTodos
  include Interactor::Organizer

  organize Todo::FindAll,
           Todo::SerializeAll
end
