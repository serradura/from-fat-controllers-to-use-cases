class UpdateTodo
  include Interactor::Organizer

  organize Todo::Find,
           Todo::FetchParamsToSave,
           Todo::Update,
           Todo::Serialize
end
