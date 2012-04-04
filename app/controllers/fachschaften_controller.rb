class FachschaftenController < ApplicationController
  # GET /fachschaften
  # GET /fachschaften.json
  def index
    @fachschaften = Fachschaft.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fachschaften }
    end
  end

  # GET /fachschaften/1
  # GET /fachschaften/1.json
  def show
    @fachschaft = Fachschaft.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fachschaft }
    end
  end

  # GET /fachschaften/new
  # GET /fachschaften/new.json
  def new
    return if force_group("root")
    @fachschaft = Fachschaft.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fachschaft }
    end
  end

  # GET /fachschaften/1/edit
  def edit
    return if force_group("root")
    @fachschaft = Fachschaft.find(params[:id])
  end

  # POST /fachschaften
  # POST /fachschaften.json
  def create
    @fachschaft = Fachschaft.new(params[:fachschaft])

    respond_to do |format|
      if @fachschaft.save
        format.html { redirect_to @fachschaft, notice: 'Fachschaft was successfully created.' }
        format.json { render json: @fachschaft, status: :created, location: @fachschaft }
      else
        format.html { render action: "new" }
        format.json { render json: @fachschaft.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fachschaften/1
  # PUT /fachschaften/1.json
  def update
    return if force_group("root")
    @fachschaft = Fachschaft.find(params[:id])

    respond_to do |format|
      if @fachschaft.update_attributes(params[:fachschaft])
        format.html { redirect_to @fachschaft, notice: 'Fachschaft was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fachschaft.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fachschaften/1
  # DELETE /fachschaften/1.json
  def destroy
    return if force_group("root")
    @fachschaft = Fachschaft.find(params[:id])
    @fachschaft.destroy

    respond_to do |format|
      format.html { redirect_to fachschaften_url }
      format.json { head :no_content }
    end
  end
end
