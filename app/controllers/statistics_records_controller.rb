# -*- coding: utf-8 -*-
class StatisticsRecordsController < ApplicationController
  # GET /statistics_records
  # GET /statistics_records.json
  def index
    val = ''
    if params.key?(:start_addr) then
      val = params[:start_addr]
    elsif params.key?(:statistics_record) && params[:statistics_record].key?(:start_addr) then
      val = params[:statistics_record][:start_addr]
    end

    @statistics_records = StatisticsRecord.search(val)

    respond_to do |format|
      # format.html # index.html.erb
      format.json { render json: @statistics_records }
    end
  end
=begin
  # GET /statistics_records/1
  # GET /statistics_records/1.json
  def show
    @statistics_record = StatisticsRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @statistics_record }
    end
  end

  # GET /statistics_records/new
  # GET /statistics_records/new.json
  def new
    @statistics_record = StatisticsRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @statistics_record }
    end
  end

  # GET /statistics_records/1/edit
  def edit
    @statistics_record = StatisticsRecord.find(params[:id])
  end

  # POST /statistics_records
  # POST /statistics_records.json
  def create
    @statistics_record = StatisticsRecord.new(params[:statistics_record])

    respond_to do |format|
      if @statistics_record.save
        format.html { redirect_to @statistics_record, notice: 'Statistics record was successfully created.' }
        format.json { render json: @statistics_record, status: :created, location: @statistics_record }
      else
        format.html { render action: "new" }
        format.json { render json: @statistics_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /statistics_records/1
  # PUT /statistics_records/1.json
  def update
    @statistics_record = StatisticsRecord.find(params[:id])

    respond_to do |format|
      if @statistics_record.update_attributes(params[:statistics_record])
        format.html { redirect_to @statistics_record, notice: 'Statistics record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @statistics_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statistics_records/1
  # DELETE /statistics_records/1.json
  def destroy
    @statistics_record = StatisticsRecord.find(params[:id])
    @statistics_record.destroy

    respond_to do |format|
      format.html { redirect_to statistics_records_url }
      format.json { head :no_content }
    end
  end
=end
end
