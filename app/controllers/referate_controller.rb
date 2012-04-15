class ReferateController < ApplicationController
  # GET /referate
  # GET /referate.json
  def index
    @referate = Referat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @referate }
    end
  end

  # GET /referate/1
  # GET /referate/1.json
  def show
    @referat = Referat.find(params[:id])
    @motions_status = @referat.motions.find(:all, :order => "status, created_at").group_by { |m| m.status }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @referat }
    end
  end

  # GET /referate/new
  # GET /referate/new.json
  def new
    return unless force_group("root")
    @referat = Referat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @referat }
    end
  end

  # GET /referate/1/edit
  def edit
    return unless force_group("root")
    @referat = Referat.find(params[:id])
  end

  # POST /referate
  # POST /referate.json
  def create
    return unless force_group("root")
    @referat = Referat.new(params[:referat])

    respond_to do |format|
      if @referat.save
        format.html { redirect_to @referat, notice: 'Referat was successfully created.' }
        format.json { render json: @referat, status: :created, location: @referat }
      else
        format.html { render action: "new" }
        format.json { render json: @referat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /referate/1
  # PUT /referate/1.json
  def update
    return unless force_group("root")
    @referat = Referat.find(params[:id])

    respond_to do |format|
      if @referat.update_attributes(params[:referat])
        format.html { redirect_to @referat, notice: 'Referat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @referat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /referate/1
  # DELETE /referate/1.json
  def destroy
    return unless force_group("root")
    @referat = Referat.find(params[:id])
    @referat.destroy

    respond_to do |format|
      format.html { redirect_to referate_url }
      format.json { head :no_content }
    end
  end
end
