class TodosController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :json


  # GET /todos
  # GET /todos.xml
  def index
    @todos = Todo.users(current_user.id).all
    @todo = Todo.new
    @todo.date = Time.new.to_s
    @todo.time = Record::get_time_as_string

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @todos }
      format.js   { render :json=> @todos }
    end
  end

  # GET /todos/1
  # GET /todos/1.xml
  def show
    @todo = Todo.users(current_user.id).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @todo }
      format.js   { render :json=> @todo }
    end
  end

  # GET /todos/new
  # GET /todos/new.xml
  def new
    @todo = Todo.new
    @todo.date = Time.now.to_s

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @todo }
      format.js
    end
  end

  # GET /todos/1/edit
  def edit
    @todo = Todo.users(current_user.id).find(params[:id])
  end

  # POST /todos
  # POST /todos.xml
  def create
    @todo = Todo.new(params[:todo])
    @todo[:user_id] = current_user.id
    @todo[:time] = Record::hours_to_numeric(@todo[:time])

    respond_to do |format|
      if @todo.save
        format.html { redirect_to(@todo, :notice => 'Todo was successfully created.') }
        format.xml  { render :xml => @todo, :status => :created, :location => @todo }
        format.js   { @notice = "Todo #{@todo.title} was successfully created"}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /todos/1
  # PUT /todos/1.xml
  def update
    @todo = Todo.users(current_user.id).find(params[:id])
    @todo.user_id = current_user.id
    

    respond_to do |format|
      params[:todo][:time] = Record::hours_to_numeric(params[:todo][:time])
      if @todo.update_attributes(params[:todo])
        format.html { redirect_to(@todo, :notice => 'Todo was successfully updated.') }
        format.xml  { head :ok }
        format.js   { @notice = "Todo #{@todo.title} was successfully updated"}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.xml
  def destroy
    @todo = Todo.users(current_user.id).find(params[:id])
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to(todos_url) }
      format.xml  { head :ok }
      format.js  { head :ok }
    end
  end
end
