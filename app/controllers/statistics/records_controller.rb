class Statistics::RecordsController < ApplicationController
  def search
    val = ''
    if params.key?(:start_addr) then
      val = params[:start_addr]
    elsif params.key?(:statistics_record) && params[:statistics_record].key?(:start_addr) then
      val = params[:statistics_record][:start_addr]
    end

    @statistics_records = Statistics::Record.search(val)

    respond_to do |format|
      # format.html # index.html.erb
      format.json {  render json: @statistics_records }
    end
  end
end
