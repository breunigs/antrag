require 'test_helper'

class ReferateControllerTest < ActionController::TestCase
  setup do
    @referat = referate(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:referate)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create referat" do
    assert_difference('Referat.count') do
      post :create, referat: @referat.attributes
    end

    assert_redirected_to referat_path(assigns(:referat))
  end

  test "should show referat" do
    get :show, id: @referat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @referat
    assert_response :success
  end

  test "should update referat" do
    put :update, id: @referat, referat: @referat.attributes
    assert_redirected_to referat_path(assigns(:referat))
  end

  test "should destroy referat" do
    assert_difference('Referat.count', -1) do
      delete :destroy, id: @referat
    end

    assert_redirected_to referate_path
  end
end
