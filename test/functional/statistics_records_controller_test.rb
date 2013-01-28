require 'test_helper'

class StatisticsRecordsControllerTest < ActionController::TestCase
  setup do
    @statistics_record = statistics_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statistics_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create statistics_record" do
    assert_difference('StatisticsRecord.count') do
      post :create, statistics_record: { cc: @statistics_record.cc, data_type: @statistics_record.data_type, date: @statistics_record.date, end_addr_dec: @statistics_record.end_addr_dec, extensions: @statistics_record.extensions, registry: @statistics_record.registry, start: @statistics_record.start, start_addr_dec: @statistics_record.start_addr_dec, status: @statistics_record.status, value: @statistics_record.value }
    end

    assert_redirected_to statistics_record_path(assigns(:statistics_record))
  end

  test "should show statistics_record" do
    get :show, id: @statistics_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @statistics_record
    assert_response :success
  end

  test "should update statistics_record" do
    put :update, id: @statistics_record, statistics_record: { cc: @statistics_record.cc, data_type: @statistics_record.data_type, date: @statistics_record.date, end_addr_dec: @statistics_record.end_addr_dec, extensions: @statistics_record.extensions, registry: @statistics_record.registry, start: @statistics_record.start, start_addr_dec: @statistics_record.start_addr_dec, status: @statistics_record.status, value: @statistics_record.value }
    assert_redirected_to statistics_record_path(assigns(:statistics_record))
  end

  test "should destroy statistics_record" do
    assert_difference('StatisticsRecord.count', -1) do
      delete :destroy, id: @statistics_record
    end

    assert_redirected_to statistics_records_path
  end
end
