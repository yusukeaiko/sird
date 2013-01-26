require 'test_helper'

class ApnicVersionsControllerTest < ActionController::TestCase
  setup do
    @apnic_version = apnic_versions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apnic_versions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apnic_version" do
    assert_difference('ApnicVersion.count') do
      post :create, apnic_version: { UTCoffset: @apnic_version.UTCoffset, enddate: @apnic_version.enddate, records: @apnic_version.records, registry: @apnic_version.registry, serial: @apnic_version.serial, startdate: @apnic_version.startdate, version: @apnic_version.version }
    end

    assert_redirected_to apnic_version_path(assigns(:apnic_version))
  end

  test "should show apnic_version" do
    get :show, id: @apnic_version
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apnic_version
    assert_response :success
  end

  test "should update apnic_version" do
    put :update, id: @apnic_version, apnic_version: { UTCoffset: @apnic_version.UTCoffset, enddate: @apnic_version.enddate, records: @apnic_version.records, registry: @apnic_version.registry, serial: @apnic_version.serial, startdate: @apnic_version.startdate, version: @apnic_version.version }
    assert_redirected_to apnic_version_path(assigns(:apnic_version))
  end

  test "should destroy apnic_version" do
    assert_difference('ApnicVersion.count', -1) do
      delete :destroy, id: @apnic_version
    end

    assert_redirected_to apnic_versions_path
  end
end
