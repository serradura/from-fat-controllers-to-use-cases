class CreateTodo
  include Interactor::Organizer

  organize Todo::FetchParamsToSave,
           Todo::Create,
           Todo::Serialize
end
