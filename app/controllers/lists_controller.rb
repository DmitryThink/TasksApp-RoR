class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  def index
    if user_signed_in?
      @lists = List.all
      @list = List.new
    else
      redirect_to user_session_path
    end
  end

  def userId
    @lists = List.where(:userId => user_param)
    begin
      @user = User.find(user_param)
    rescue
      render 'list/UserIdError'
    end
  end
  # GET /lists/1
  # GET /lists/1.json
  def show

  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)
    @list.userId = current_user.id
    respond_to do |format|
      if @list.save
        format.html { redirect_to lists_url, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
        Pusher.trigger('CreateList', 'list', model: @list)
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to lists_url, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
        @list.userId = current_user.id
        Pusher.trigger('UpdateList', 'list', model: @list)
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
      @list.userId = current_user.id
      Pusher.trigger('DestroyList', 'list', model: @list)
    end
    @list.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :userId)
    end
    def user_param
      params.require(:userId)
    end
end
