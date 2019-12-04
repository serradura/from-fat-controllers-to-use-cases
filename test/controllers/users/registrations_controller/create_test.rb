require 'test_helper'

class Users::RegistrationsControllerCreateTest < ActionDispatch::IntegrationTest
  test "should respond with 400 when the user param is missing" do
    post users_registrations_url

    assert_response 400

    assert_equal(
      { "error" => "param is missing or the value is empty: user" },
      JSON.parse(response.body)
    )
  end

  test "should respond with 400 when the user password params are missing" do
    post users_registrations_url, params: { user: { name: 'User One' } }

    assert_response 422

    assert_equal(
      {
        "user" => {
          "password" => ["can't be blank"],
          "password_confirmation" => ["can't be blank"]
        }
      },
      JSON.parse(response.body)
    )
  end

  test "should respond with 400 when the user password params are differents" do
    post users_registrations_url, params: { user: { name: 'User Two', password: '123', password_confirmation: '321' } }

    assert_response 422

    assert_equal(
      { "user" => { "password_confirmation" => ["doesn't match password"] } },
      JSON.parse(response.body)
    )
  end

  test "should respond with 422 when the user data is invalid" do
    post users_registrations_url, params: { user: { password: '123', password_confirmation: '123', name: '' } }

    assert_response 422

    assert_equal(
      { "user" => { "name" => ["can't be blank"] } },
      JSON.parse(response.body)
    )
  end

  test "should respond with 201 when creating the user" do
    assert_difference 'User.count', +1 do
      post users_registrations_url, params: { user: { password: '123', password_confirmation: '123', name: 'Rodrigo' } }
    end

    assert_response 201

    json = JSON.parse(response.body)
    uuid = /\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b/

    assert_match(uuid, json["user"]["token"])
    assert_equal("Rodrigo", json["user"]["name"])
    assert_kind_of(Numeric, json["user"]["id"])

    User.where(id: json["user"]["id"]).delete_all
  end
end
