require 'test_helper'

class TodosControllerUpdateTest < ActionDispatch::IntegrationTest
  test "should respond with 401 if the user token is invalid" do
    put todo_url(id: 1)

    assert_response 401
  end

  test "should respond with 400 when the todo params are missing" do
    todo = todos(:active)

    put todo_url(todo), {
      headers: { 'Authorization' => "Bearer token=\"#{todo.user.token}\"" },
      params: { title: 'Buy coffee' }
    }

    assert_response 400

    assert_equal(
      { "error" => "param is missing or the value is empty: todo" },
      JSON.parse(response.body)
    )
  end

  test "should respond with 404 when the todo was not found" do
    user = users(:rodrigo)

    put todo_url(id: 1), {
      headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" },
      params: { todo: { title: 'Buy coffee' } }
    }

    assert_response 404

    assert_equal(
      { "todo" => { "id" => "not found" } },
      JSON.parse(response.body)
    )
  end

  test "should respond with 422 when receives invalid params" do
    todo = todos(:active)

    put todo_url(todo), {
      headers: { 'Authorization' => "Bearer token=\"#{todo.user.token}\"" },
      params: { todo: { title: '' } }
    }

    assert_response 422

    assert_equal(
      { "todo" => { "title"=>["can't be blank"] } },
      JSON.parse(response.body)
    )
  end

  test "should respond with 200 when receives valid params" do
    todo = todos(:active)
    previous_title = todo.title

    put todo_url(todo), {
      headers: { 'Authorization' => "Bearer token=\"#{todo.user.token}\"" },
      params: { todo: { title: 'Buy coffee' } }
    }

    assert_response 200

    json = JSON.parse(response.body)
    todo = Todo.find(json.dig('todo', 'id'))

    refute_equal(previous_title, todo.title)
    assert_equal('Buy coffee', todo.title)

    assert_equal(
      { "todo" => todo.as_json(except: [:user_id], methods: :status) },
      json
    )

    todo.delete
  end
end
