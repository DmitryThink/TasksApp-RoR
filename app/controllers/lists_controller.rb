class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @lists = List.all
      @list = List.new
    else
      redirect_to user_session_path
    end
  end

  def publicIndex
    @lists = List.where(:userId => user_param)
    begin
      @user = User.find(user_param)
    rescue
      render 'list/publicIndexError'
    end
  end

  def errors
    if @list.errors.any?
      @list.errors.full_messages.each do |message|
        flash[message] = message
      end
    end
  end

  def create
    @list = List.new(list_params)
    @list.userId = current_user.id
    if @list.save
      redirect_to lists_url, notice: 'List was successfully created.'
      Pusher.trigger('CreateList', 'list', model: @list)
    else
      errors
      redirect_to lists_url
    end
  end

  def update
    if @list.update(list_params)
      redirect_to lists_url, notice: 'List was successfully updated.'
      @list.userId = current_user.id
      Pusher.trigger('UpdateList', 'list', model: @list)
    else
      errors
      redirect_to lists_url
    end
  end

  def destroy
    redirect_to lists_url, notice: 'List was successfully destroyed.'
    @list.userId = current_user.id
    Pusher.trigger('DestroyList', 'list', model: @list)
    @tasks = Task.where(:listid => @list.id)
    @tasks.each do |task|
      task.destroy
      Pusher.trigger('DestroyTask', 'task', model: task)
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
