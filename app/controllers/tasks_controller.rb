class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @tasks = Task.all
      @task = Task.new
      @list = List.find(list_param)
      @task.listId = @list.id
    else
      redirect_to user_session_path
    end
  end

  def publicIndex
    @tasks = Task.where(:userId => user_param, :listId => list_param)
    begin
      @user = User.find(user_param)
      @list = List.find(list_param)
    rescue
      render 'tasks/publicIndexError'
    end
  end

  def create
    @task = Task.new(task_params)
    @task.userId = current_user.id
    if @task.save
      redirect_to controller: 'tasks', action: 'index', listId: @task.listId, notice: 'Task was successfully updated.'
      Pusher.trigger('CreateTask', 'task', model: @task)
    else
      redirect_to controller: 'tasks', action: 'index', listId: list_param, notice: 'Something wrong!'
    end
  end

  def update
    if @task.update(task_params)
      redirect_to controller: 'tasks', action: 'index', listId: @task.listId, notice: 'Task was successfully updated.'
      @task.userId = current_user.id
      Pusher.trigger('UpdateTask', 'task', model: @task)
    else
      redirect_to controller: 'tasks', action: 'index', listId: list_param, notice: 'Something wrong!'
    end
  end

  def destroy
    redirect_to controller: 'tasks', action: 'index', listId: @task.listId, notice: 'Task was successfully destroyed.'
    @task.userId = current_user.id
    Pusher.trigger('DestroyTask', 'task', model: @task)
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:id, :name, :description, :checked, :userId, :listId)
    end

    def user_param
      params.require(:userId)
    end

    def list_param
      params.require(:listId)
    end
end
