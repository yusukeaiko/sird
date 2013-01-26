class ApnicSummariesController < ApplicationController
  # GET /apnic_summaries
  # GET /apnic_summaries.json
  def index
    @apnic_summaries = ApnicSummary.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apnic_summaries }
    end
  end

  # GET /apnic_summaries/1
  # GET /apnic_summaries/1.json
  def show
    @apnic_summary = ApnicSummary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apnic_summary }
    end
  end

  # GET /apnic_summaries/new
  # GET /apnic_summaries/new.json
  def new
    @apnic_summary = ApnicSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apnic_summary }
    end
  end

  # GET /apnic_summaries/1/edit
  def edit
    @apnic_summary = ApnicSummary.find(params[:id])
  end

  # POST /apnic_summaries
  # POST /apnic_summaries.json
  def create
    @apnic_summary = ApnicSummary.new(params[:apnic_summary])

    respond_to do |format|
      if @apnic_summary.save
        format.html { redirect_to @apnic_summary, notice: 'Apnic summary was successfully created.' }
        format.json { render json: @apnic_summary, status: :created, location: @apnic_summary }
      else
        format.html { render action: "new" }
        format.json { render json: @apnic_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apnic_summaries/1
  # PUT /apnic_summaries/1.json
  def update
    @apnic_summary = ApnicSummary.find(params[:id])

    respond_to do |format|
      if @apnic_summary.update_attributes(params[:apnic_summary])
        format.html { redirect_to @apnic_summary, notice: 'Apnic summary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @apnic_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apnic_summaries/1
  # DELETE /apnic_summaries/1.json
  def destroy
    @apnic_summary = ApnicSummary.find(params[:id])
    @apnic_summary.destroy

    respond_to do |format|
      format.html { redirect_to apnic_summaries_url }
      format.json { head :no_content }
    end
  end
end
