# encoding: utf-8

class MotionsController < ApplicationController
  # static page, but includes the erb and style goodies
  def kingslanding
    @motion = Motion.new
  end

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

  # GET /motions/1/edit
  def edit
    @motion = Motion.find(params[:id])
  end

  # GET /motions/1/add_attachment
  def add_attachment
    @motion = Motion.find(params[:id])
    @attachment = Attachment.new
  end

  def change_referat
    @motion = Motion.find(params[:id])
    return generic_denied_message unless is_current_in_group?("finanzen") || is_current_in_referat?(@motion.referat)
    @referat = params[:referat].blank? ? nil : Referat.find(params[:referat])
    if @referat.nil? && !params[:referat].blank?
      flash[:error] = "Das ausgewählte Referat existiert gar nicht."
    else
      old = @motion.referat_id
      @motion.referat_id = @referat ? @referat.id : ""
      # set correct top
      @motion.top = @motion.get_top_state
      if old == @motion.referat_id
        flash[:warning] = "Das gewählte Referat ist schon das aktuelle."
      elsif @motion.save
        if @referat
          add_comment(@motion, "#{current_user.name} hat das zugeordnete Referat geändert in #{@referat.name}.")
        else
          add_comment(@motion, "#{current_user.name} hat das zugeordnete Referat entfernt.")
        end
        mailtxt = ""
        if @motion.status == Motion::STATUS_NEW && @referat
          # only mail to new referat
          Mailer.new_motion(@motion, @referat, false, false)
          mailtxt = "#{@referat.name} hat eine E-Mail erhalten, die sie über diesen neuen Antrag informiert."
        end
        flash[:notice] = "Das Referat wurde geändert. #{mailtxt}"
      else
        flash[:error] = "Konnte das Referat nicht ändern."
      end
    end

    redirect_to @motion
  end

  def grant
    @motion = Motion.find(params[:id])
    return generic_denied_message unless current_may_accept_deny?(@motion)
    @motion.status = Motion::STATUS_GRANTED
    @motion.top = ""
    if @motion.save
      add_comment(@motion, "#{current_user.name} hat das Geld genehmigt bzw. den Antrag angenommen.")
      Mailer.motion_granted(@motion)
      flash[:notice] = "Status geändert, das Geld ist jetzt genehmigt bzw. der Antrag angenommen. Der/Die Antragsteller/in sollte eine E-Mail bekommen haben."
    else
      flash[:error] = "Konnte den Antrag nicht ändern."
    end
    redirect_to @motion
  end

  def deny
    @motion = Motion.find(params[:id])
    return generic_denied_message unless current_may_accept_deny?(@motion)
    @motion.status = Motion::STATUS_DENIED
    @motion.top = ""
    if @motion.save
      add_comment(@motion, "#{current_user.name} hat den Antrag abgelehnt.")
      Mailer.motion_denied(@motion)
      flash[:notice] = "Status geändert, der Antrag wurde abgelehnt. Der/Die Antragsteller/in sollte eine E-Mail bekommen haben."
    else
      flash[:error] = "Konnte den Antrag nicht ändern."
    end
    redirect_to @motion
  end

  # Sets the status to a value defined in the Motion class. Note that
  # not the contents of the constant, but the constant’s name need to
  # be passed. So if STATUS_DENIED = "Abgelehnt", then pass "STATUS_
  # DENIED".
  def set_status
    @motion = Motion.find(params[:id])
    return generic_denied_message unless current_may_set_status?(@motion)
    redirect_to(@motion) and return unless params[:status] =~ /^[A-Z_]+$/ && Motion.const_defined?(params[:status])

    @motion.status = Motion.const_get(params[:status])
    if @motion.save
      add_comment(@motion, "#{current_user.name} hat den Status auf „#{@motion.status}“ gesetzt.")
      flash[:notice] = "Status erfolgreich auf „#{@motion.status}“ geändert."
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
    @attachment = Attachment.create(params[:attachment])
    @attachment.motion_id = @motion.id
    @attachment.ip = request.remote_ip

    pp @attachment
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
    @attachment = @motion.attachments.find_by_id(params[:attachment])
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

    # convert date fields into real Date objects. If it fails due to
    # bogus data, the dynamic field validator will catch that it isn't
    # a valid date object.
    params[:dynamic].each do |kind, fields|
      fields.each do |name, value|
        if value.is_a?(Hash) && value.keys.include?("(3i)")
          begin
            d_y = value["(1i)"].to_i
            d_m = value["(2i)"].to_i
            d_d = value["(3i)"].to_i
            params[:dynamic][kind][name] = Date.new(d_y, d_m, d_d)
          rescue; end
        end
      end
    end

    # don't allow arrays as values. Convert them to strings (occurs in
    # select fields for some reason).
    params[:dynamic].each do |kind, fields|
      fields.each do |name, value|
        if value.is_a?(Array)
          params[:dynamic][kind][name] = params[:dynamic][kind][name].first
        end
        if value.is_a?(Hash) # entries with :index => blub
          value.each do |k,v|
            params[:dynamic][kind][name][k] = v.first
          end
        end
      end
    end

    @motion.dynamic_fields = Base64.encode64(Marshal.dump(params[:dynamic]))
    @motion.fin_expected_amount = @motion.calc_fin_expected_amount
    @motion.status = Motion::STATUS_NEW
    @motion.top = @motion.get_top_state

    uuid = UUIDTools::UUID.timestamp_create.to_s
    while Motion.find_by_uuid(uuid) != nil
      uuid = UUIDTools::UUID.timestamp_create.to_s
    end
    @motion.uuid = uuid
    respond_to do |format|
      if @motion.save
        Mailer.new_motion(@motion, @motion.referat, @motion.finanz?, true)

        format.html { redirect_to @motion, notice: 'Motion was successfully created.' }
        format.json { render json: @motion, status: :created, location: @motion }
      else
        format.html { render action: "kingslanding" }
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
