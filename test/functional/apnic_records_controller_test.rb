require 'test_helper'

class ApnicRecordsControllerTest < ActionController::TestCase
  setup do
    @apnic_record = apnic_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apnic_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apnic_record" do
    assert_difference('ApnicRecord.count') do
      post :create, apnic_record: { cc: @apnic_record.cc, date: @apnic_record.date, extensions: @apnic_record.extensions, registry: @apnic_record.registry, start: @apnic_record.start, status: @apnic_record.status, type: @apnic_record.type, value: @apnic_record.value }
    end

    assert_redirected_to apnic_record_path(assigns(:apnic_record))
  end

  test "should show apnic_record" do
    get :show, id: @apnic_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apnic_record
    assert_response :success
  end

  test "should update apnic_record" do
    put :update, id: @apnic_record, apnic_record: { cc: @apnic_record.cc, date: @apnic_record.date, extensions: @apnic_record.extensions, registry: @apnic_record.registry, start: @apnic_record.start, status: @apnic_record.status, type: @apnic_record.type, value: @apnic_record.value }
    assert_redirected_to apnic_record_path(assigns(:apnic_record))
  end

  test "should destroy apnic_record" do
    assert_difference('ApnicRecord.count', -1) do
      delete :destroy, id: @apnic_record
    end

    assert_redirected_to apnic_records_path
  end
end
