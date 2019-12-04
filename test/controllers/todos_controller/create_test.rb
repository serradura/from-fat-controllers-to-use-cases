require 'test_helper'

class TodosControllerCreateTest < ActionDispatch::IntegrationTest
  test "should respond with 401 if the user token is invalid" do
    get todos_url

    assert_response 401
  end

  test "should respond with 400 when the todo params are missing" do
    user = users(:rodrigo)

    post todos_url, {
      headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" },
      params: { title: 'Buy coffee' }
    }

    assert_response 400

    assert_equal(
      { "error" => "param is missing or the value is empty: todo" },
      JSON.parse(response.body)
    )
  end

  test "should respond with 422 when receives invalid params" do
    user = users(:rodrigo)

    post todos_url, {
      headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" },
      params: { todo: { title: '' } }
    }

    assert_response 422

    assert_equal(
      { "todo" => { "title"=>["can't be blank"] } },
      JSON.parse(response.body)
    )
  end

  test "should respond with 201 when receives valid params" do
    user = users(:rodrigo)

    post todos_url, {
      headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" },
      params: { todo: { title: 'Buy coffee' } }
    }

    assert_response 201

    json = JSON.parse(response.body)
    todo = Todo.find(json.dig('todo', 'id'))

    assert_equal(
      { "todo" => todo.as_json(except: [:user_id], methods: :status) },
      json
    )

    todo.delete
  end
end
