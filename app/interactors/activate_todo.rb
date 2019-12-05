class ActivateTodo
  include Interactor::Organizer

  organize Todo::Find,
           Todo::Update::ToActive,
           Todo::Serialize
end
