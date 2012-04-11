# encoding: utf-8

class MotionsController < ApplicationController
  # GET /motions
  # GET /motions.json
  def index
    @motions = Motion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @motions }
    end
  end

  # GET /motions/1
  # GET /motions/1.json
  def show
    @motion = Motion.find(params[:id])
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @motion }
    end
  end

  # GET /motions/new
  # GET /motions/new.json
  def new
    @motion = Motion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @motion }
    end
  end

  # GET /motions/1/edit
  def edit
    @motion = Motion.find(params[:id])
  end

  # GET /motions/1/add_attachment
  def add_attachment
    @motion = Motion.find(params[:id])
    @attachment = Attachment.new
  end

  def toggle_motion_top
    return unless force_login
    @motion = Motion.find(params[:id])
    @motion.is_top = !@motion.is_top
    if @motion.save
      flash[:notice] = "Status geändert, jetzt #{@motion.is_top ? "auch ein TOP" : "kein TOP mehr"}. <a href='#{toggle_motion_top_path(@motion)}'>Rückgängig machen?</a>".html_safe
    else
      flash[:error] = "Konnte den Antrag nicht ändern."
    end
    redirect_to @motion
  end

  def toggle_motion_fin_granted
    return unless force_group([:root, :finanzen])
    @motion = Motion.find(params[:id])
    @motion.fin_granted = !@motion.fin_granted
    if @motion.save
      add_comment(@motion, "#{current_user.name} hat #{@motion.fin_granted ? "das Geld genehmigt" : " die Geldgenehmigung zurückgenommen"}.")
      flash[:notice] = "Status geändert, #{@motion.fin_granted ? "das Geld ist jetzt genehmigt" : "das Geld ist jetzt nicht mehr genehmigt"}. <a href='#{toggle_motion_fin_granted_path(@motion)}'>Rückgängig machen?</a>".html_safe
    else
      flash[:error] = "Konnte den Antrag nicht ändern."
    end
    redirect_to @motion
  end

  def toggle_motion_fin_deducted
    return unless force_group([:root, :finanzen])
    @motion = Motion.find(params[:id])
    @motion.fin_deducted = !@motion.fin_deducted
    if @motion.save
      add_comment(@motion, "#{current_user.name} hat das Geld als #{@motion.fin_deducted ? " (vollständig) abgebucht " : " noch nicht, bzw. nicht vollständig abgebucht"} markiert.")
      flash[:notice] = "Status geändert, #{@motion.fin_deducted ? "das Geld wurde als (vollständig) abgebucht markiert" : "das Geld wurde als noch nicht, bzw. nicht vollständig abgebucht markiert"}. <a href='#{toggle_motion_fin_deducted_path(@motion)}'>Rückgängig machen?</a>".html_safe
    else
      flash[:error] = "Konnte den Antrag nicht ändern."
    end
    redirect_to @motion
  end

  # POST /motions/1/store_attachment
  def store_attachment
    @motion = Motion.find(params[:id])
    @attachment = Attachment.create(params[:attachment_id])
    @attachment.motion_id = @motion.id
    @attachment.ip = request.remote_ip
    if @attachment.save
      flash[:notice] = "Dateianhang gespeichert."
      u = current_user ? (current_user.name + " hat ") : ""
      add_comment(@motion, "#{u}Dateianhang hinzugefügt: <a href=\"#{@attachment.file.url}\">#{@attachment.file_name}</a>")
      redirect_to motion_path(@motion)
    else
      flash[:error] = "Konnte den Dateianhang nicht speichern."
      render action: "add_attachment"
    end
  end

  # GET /motions/1/remove_attachment/1
  def remove_attachment
    return unless force_group(:root)
    @motion = Motion.find(params[:id])
    @attachment = @motion.attachments.find_by_id(params[:attachment_id])
    if @attachment.nil?
      flash[:error] = "Der ausgewählte Anhang existiert icht oder gehört nicht zum Antrag."
      redirect_to motion_path(@motion) and return
    end
    add_comment(@motion, "#{current_user.name} hat den „#{@attachment.file_name}“ Anhang gelöscht.")
    @attachment.file = nil
    @attachment.save
    @attachment.destroy
    redirect_to motion_path(@motion) + "#attachments"
  end

  # POST /motions/1/store_comment
  def store_comment
    @motion = Motion.find(params[:id])
    @comment = Comment.create(params[:comment])
    @comment.motion_id = @motion.id
    @comment.ip = request.remote_ip
    @comment.user_id = current_user.id if current_user
    @comment.save
    redirect_to motion_path(@motion) + "#last_comment"
  end

  # POST /motions
  # POST /motions.json
  def create
    @motion = Motion.new(params[:motion])

    respond_to do |format|
      if @motion.save
        format.html { redirect_to @motion, notice: 'Motion was successfully created.' }
        format.json { render json: @motion, status: :created, location: @motion }
      else
        format.html { render action: "new" }
        format.json { render json: @motion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /motions/1
  # PUT /motions/1.json
  def update
    @motion = Motion.find(params[:id])

    respond_to do |format|
      if @motion.update_attributes(params[:motion])
        format.html { redirect_to @motion, notice: 'Motion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @motion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motions/1
  # DELETE /motions/1.json
  def destroy
    return unless force_group(:root)
    @motion = Motion.find(params[:id])
    @motion.destroy

    respond_to do |format|
      format.html { redirect_to motions_url }
      format.json { head :no_content }
    end
  end
end
