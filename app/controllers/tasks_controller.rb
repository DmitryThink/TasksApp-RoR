class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
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

  def listUserId
    @tasks = Task.where(:userId => user_param)
    begin
      @user = User.find(user_param)
      @list = List.find(user_list)
    rescue
      render 'tasks/listUserIdError'
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show

  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.userId = current_user.id
    respond_to do |format|
      if @task.save
        format.html do
          redirect_to controller: 'tasks', action: 'index', listId: @task.listId
          Pusher.trigger('Create', 'new', model: @task)
        end
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to controller: 'tasks', action: 'index', listId: @task.listId, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
        @task.userId = current_user.id
        Pusher.trigger('Update', 'task', model: @task)
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    respond_to do |format|
      format.html do
        redirect_to controller: 'tasks', action: 'index', listId: @task.listId, notice: 'Task was successfully destroyed.'
        @task.userId = current_user.id
        Pusher.trigger('Destroy', 'task', model: @task)
      end
      format.json { head :no_content }
    end
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
