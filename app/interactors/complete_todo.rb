class CompleteTodo
  include Interactor::Organizer

  organize Todo::Find,
           Todo::Update::ToCompleted,
           Todo::Serialize
end
