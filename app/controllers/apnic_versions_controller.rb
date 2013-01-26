class ApnicVersionsController < ApplicationController
  # GET /apnic_versions
  # GET /apnic_versions.json
  def index
    @apnic_versions = ApnicVersion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apnic_versions }
    end
  end

  # GET /apnic_versions/1
  # GET /apnic_versions/1.json
  def show
    @apnic_version = ApnicVersion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apnic_version }
    end
  end

  # GET /apnic_versions/new
  # GET /apnic_versions/new.json
  def new
    @apnic_version = ApnicVersion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apnic_version }
    end
  end

  # GET /apnic_versions/1/edit
  def edit
    @apnic_version = ApnicVersion.find(params[:id])
  end

  # POST /apnic_versions
  # POST /apnic_versions.json
  def create
    @apnic_version = ApnicVersion.new(params[:apnic_version])

    respond_to do |format|
      if @apnic_version.save
        format.html { redirect_to @apnic_version, notice: 'Apnic version was successfully created.' }
        format.json { render json: @apnic_version, status: :created, location: @apnic_version }
      else
        format.html { render action: "new" }
        format.json { render json: @apnic_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apnic_versions/1
  # PUT /apnic_versions/1.json
  def update
    @apnic_version = ApnicVersion.find(params[:id])

    respond_to do |format|
      if @apnic_version.update_attributes(params[:apnic_version])
        format.html { redirect_to @apnic_version, notice: 'Apnic version was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @apnic_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apnic_versions/1
  # DELETE /apnic_versions/1.json
  def destroy
    @apnic_version = ApnicVersion.find(params[:id])
    @apnic_version.destroy

    respond_to do |format|
      format.html { redirect_to apnic_versions_url }
      format.json { head :no_content }
    end
  end
end
