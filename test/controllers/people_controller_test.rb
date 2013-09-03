require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  test "Retrieve template person" do
    get :show, { :id => 1, :format => 'json'}
    assert_response :success

    person = JSON.parse(response.body)
    assert_equal("Stacey", person['first_name'])
    assert_equal("Vetzal", person['last_name'])
    assert_equal("905-555-1212", person['phone'])
    assert_equal("stacey@threewisemen.ca", person['email'])
    assert_equal(1, person['id'])
  end

  test "Create person" do
    post :create, { :person => { :first_name => "Test", :last_name => "Test", :email => "test@email.com" }, :format => 'json' }
    assert_response :success

    person = JSON.parse(response.body)
    assert_equal("Test", person['first_name'])
    assert_equal("Test", person['last_name'])
    assert_equal("test@email.com", person['email'])
  end

  test "Update person" do
    put :update, { :id => 1, :person => { :first_name => "Test", :last_name => "Test", :email => "test@email.com" }, :format => 'json' }
    assert_response :success
  end
end
