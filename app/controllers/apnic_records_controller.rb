class ApnicRecordsController < ApplicationController
  # GET /apnic_records
  # GET /apnic_records.json
  def index
    @apnic_records = ApnicRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apnic_records }
    end
  end

  # GET /apnic_records/1
  # GET /apnic_records/1.json
  def show
    @apnic_record = ApnicRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apnic_record }
    end
  end

  # GET /apnic_records/new
  # GET /apnic_records/new.json
  def new
    @apnic_record = ApnicRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apnic_record }
    end
  end

  # GET /apnic_records/1/edit
  def edit
    @apnic_record = ApnicRecord.find(params[:id])
  end

  # POST /apnic_records
  # POST /apnic_records.json
  def create
    @apnic_record = ApnicRecord.new(params[:apnic_record])

    respond_to do |format|
      if @apnic_record.save
        format.html { redirect_to @apnic_record, notice: 'Apnic record was successfully created.' }
        format.json { render json: @apnic_record, status: :created, location: @apnic_record }
      else
        format.html { render action: "new" }
        format.json { render json: @apnic_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apnic_records/1
  # PUT /apnic_records/1.json
  def update
    @apnic_record = ApnicRecord.find(params[:id])

    respond_to do |format|
      if @apnic_record.update_attributes(params[:apnic_record])
        format.html { redirect_to @apnic_record, notice: 'Apnic record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @apnic_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apnic_records/1
  # DELETE /apnic_records/1.json
  def destroy
    @apnic_record = ApnicRecord.find(params[:id])
    @apnic_record.destroy

    respond_to do |format|
      format.html { redirect_to apnic_records_url }
      format.json { head :no_content }
    end
  end
end
