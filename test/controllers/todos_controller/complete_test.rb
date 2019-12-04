require 'test_helper'

class TodosControllerCompleteTest < ActionDispatch::IntegrationTest
  test "should respond with 401 if the user token is invalid" do
    put complete_todo_url(id: 1)

    assert_response 401
  end

  test "should respond with 404 when the todo was not found" do
    user = users(:rodrigo)

    put complete_todo_url(id: 1), headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" }

    assert_response 404

    assert_equal(
      { "todo" => { "id" => "not found" } },
      JSON.parse(response.body)
    )
  end

  test "should respond with 200 after completes an existent todo" do
    todo = todos(:active)

    put complete_todo_url(todo), headers: { 'Authorization' => "Bearer token=\"#{todo.user.token}\"" }

    assert_response 200

    todo.reload

    assert_predicate(todo, :completed?)

    assert_equal(
      { "todo" => todo.as_json(except: [:user_id], methods: :status) },
      JSON.parse(response.body)
    )
  end
end
