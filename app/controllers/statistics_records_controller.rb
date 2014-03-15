class StatisticsRecordsController < ApplicationController
  before_action :set_statistics_record, only: [:show, :edit, :update, :destroy]

  # GET /statistics_records
  # GET /statistics_records.json
  def index
    @statistics_records = StatisticsRecord.all
  end

  # GET /statistics_records/1
  # GET /statistics_records/1.json
  def show
  end

  # GET /statistics_records/new
  def new
    @statistics_record = StatisticsRecord.new
  end

  # GET /statistics_records/1/edit
  def edit
  end

  # POST /statistics_records
  # POST /statistics_records.json
  def create
    @statistics_record = StatisticsRecord.new(statistics_record_params)

    respond_to do |format|
      if @statistics_record.save
        format.html { redirect_to @statistics_record, notice: 'Statistics record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @statistics_record }
      else
        format.html { render action: 'new' }
        format.json { render json: @statistics_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statistics_records/1
  # PATCH/PUT /statistics_records/1.json
  def update
    respond_to do |format|
      if @statistics_record.update(statistics_record_params)
        format.html { redirect_to @statistics_record, notice: 'Statistics record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @statistics_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statistics_records/1
  # DELETE /statistics_records/1.json
  def destroy
    @statistics_record.destroy
    respond_to do |format|
      format.html { redirect_to statistics_records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statistics_record
      @statistics_record = StatisticsRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statistics_record_params
      params.require(:statistics_record).permit(:registry_id, :country_id, :data_type, :start_addr, :end_addr, :value, :prefix, :date, :status, :extensions, :start_addr_dec, :end_addr_dec)
    end
end
