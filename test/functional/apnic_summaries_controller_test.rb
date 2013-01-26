require 'test_helper'

class ApnicSummariesControllerTest < ActionController::TestCase
  setup do
    @apnic_summary = apnic_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apnic_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apnic_summary" do
    assert_difference('ApnicSummary.count') do
      post :create, apnic_summary: { count: @apnic_summary.count, registry: @apnic_summary.registry, summary: @apnic_summary.summary, type: @apnic_summary.type }
    end

    assert_redirected_to apnic_summary_path(assigns(:apnic_summary))
  end

  test "should show apnic_summary" do
    get :show, id: @apnic_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apnic_summary
    assert_response :success
  end

  test "should update apnic_summary" do
    put :update, id: @apnic_summary, apnic_summary: { count: @apnic_summary.count, registry: @apnic_summary.registry, summary: @apnic_summary.summary, type: @apnic_summary.type }
    assert_redirected_to apnic_summary_path(assigns(:apnic_summary))
  end

  test "should destroy apnic_summary" do
    assert_difference('ApnicSummary.count', -1) do
      delete :destroy, id: @apnic_summary
    end

    assert_redirected_to apnic_summaries_path
  end
end
