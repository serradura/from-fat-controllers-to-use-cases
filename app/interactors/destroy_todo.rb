class DestroyTodo
  include Interactor::Organizer

  organize Todo::Find,
           Todo::Destroy,
           Todo::Serialize
end
