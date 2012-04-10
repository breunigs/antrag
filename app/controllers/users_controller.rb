class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1/edit
  def edit
    return unless force_group("root")
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    return unless force_group("root")
    @user = User.find(params[:id])

    # init always, so non-checked checkboxes will be updated
    params[:user][:fachschaft_ids] ||= []
    params[:user][:referat_ids] ||= []
    # normalize groups field
    params[:user][:groups] = params[:user][:groups].downcase.split(/[^a-z]+/).uniq.sort.join(" ") if params[:user][:groups]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to edit_user_path(@user), notice: 'Nutzer erfolgreich aktualisiert.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
