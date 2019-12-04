require 'test_helper'

class TodosControllerIndexTest < ActionDispatch::IntegrationTest
  test "should respond with 401 if the user token is invalid" do
    get todos_url

    assert_response 401
  end

  test "should respond with 200 even when the user hasn't to-dos" do
    user = users(:rodrigo)

    get todos_url, headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" }

    assert_response 200

    assert_equal(
      { "todos" => [] },
      JSON.parse(response.body)
    )
  end

  test "should respond with 200 when the user has to-dos and there is no status to filter" do
    user = users(:john_doe)

    get todos_url, headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" }

    assert_response 200

    json = JSON.parse(response.body)

    assert_instance_of(Array, json["todos"])

    assert_equal(4, json["todos"].size)

    json["todos"].each do |item|
      assert_equal(
        ["id", "title", "due_at", "completed_at", "created_at", "updated_at", "status"],
        item.keys
      )
    end
  end

  test "should respond with 200 when the user has to-dos and the status is active" do
    user = users(:john_doe)

    get todos_url, headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" }, params: { status: 'active' }

    assert_response 200

    json = JSON.parse(response.body)

    assert_instance_of(Array, json["todos"])

    assert_equal(2, json["todos"].size)

    assert(json["todos"].all? { |todo| todo['completed_at'].blank? })

    json["todos"].each do |item|
      assert_equal(
        ["id", "title", "due_at", "completed_at", "created_at", "updated_at", "status"],
        item.keys
      )
    end
  end

  test "should respond with 200 when the user has to-dos and the status is completed" do
    user = users(:john_doe)

    get todos_url, headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" }, params: { status: 'completed' }

    assert_response 200

    json = JSON.parse(response.body)

    assert_instance_of(Array, json["todos"])

    assert_equal(2, json["todos"].size)

    assert(json["todos"].all? { |todo| todo['completed_at'].present? })

    json["todos"].each do |item|
      assert_equal(
        ["id", "title", "due_at", "completed_at", "created_at", "updated_at", "status"],
        item.keys
      )
    end
  end

  test "should respond with 200 when the user has to-dos and the status is overdue" do
    user = users(:john_doe)

    get todos_url, headers: { 'Authorization' => "Bearer token=\"#{user.token}\"" }, params: { status: 'overdue' }

    assert_response 200

    json = JSON.parse(response.body)

    assert_instance_of(Array, json["todos"])

    assert_equal(1, json["todos"].size)

    assert(json["todos"].all? { |todo| todo['completed_at'].blank? })

    json["todos"].each do |item|
      assert_equal(
        ["id", "title", "due_at", "completed_at", "created_at", "updated_at", "status"],
        item.keys
      )
    end
  end
end
