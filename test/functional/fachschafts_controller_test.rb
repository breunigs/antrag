require 'test_helper'

class FachschaftsControllerTest < ActionController::TestCase
  setup do
    @fachschaft = fachschafts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fachschafts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fachschaft" do
    assert_difference('Fachschaft.count') do
      post :create, fachschaft: @fachschaft.attributes
    end

    assert_redirected_to fachschaft_path(assigns(:fachschaft))
  end

  test "should show fachschaft" do
    get :show, id: @fachschaft
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fachschaft
    assert_response :success
  end

  test "should update fachschaft" do
    put :update, id: @fachschaft, fachschaft: @fachschaft.attributes
    assert_redirected_to fachschaft_path(assigns(:fachschaft))
  end

  test "should destroy fachschaft" do
    assert_difference('Fachschaft.count', -1) do
      delete :destroy, id: @fachschaft
    end

    assert_redirected_to fachschafts_path
  end
end
