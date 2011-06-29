class RecordsController < ApplicationController
  before_filter :authenticate_user!

  # GET /records
  # GET /records.xml
  def index
    if !params[:year].nil? and !params[:month].nil?
      s_date = Time.utc(params[:year], params[:month]).to_date
      e_date = s_date.next_month
    elsif !params[:year].nil? and params[:month].nil?
      s_date = Time.utc(params[:year]).to_date
      e_date = s_date.next_year
    elsif params[:year].nil? and params[:month].nil?
      s_date = Time.utc(Time.now.year, Time.now.month).to_date
      e_date = s_date.next_month
      params[:year]= s_date.year
      params[:month] = s_date.month
    end
    
    @records = Record.users(current_user.id)
    @records = @records.where(["date >= ? AND date < ?", s_date, e_date]) unless s_date.nil?
    @total_worked_time = @records.sum(:duration)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end
  end

  # GET /records/1
  # GET /records/1.xml
  def show
    @record = Record.users(current_user.id).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/new
  # GET /records/new.xml
  def new
    @record = Record.new
    @record.date = params[:new_date] || Time.now.to_s

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/1/edit
  def edit
    @record = Record.users(current_user.id).find(params[:id])
    params[:ends] = @record.ends
  end

  # POST /records
  # POST /records.xml
  def create
    rec_params = params
    params[:record][:user_id] = current_user.id
    params = Record::extend_params_with(rec_params)
    @record = Record.new(params[:record])

    respond_to do |format|
      if @record.save
        format.html { redirect_to(records_url, :notice => 'Record was successfully created.') }
        format.xml  { render :xml => @record, :status => :created, :location => @record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /records/1
  # PUT /records/1.xml
  def update
    rec_params = params
    params[:record][:user_id] = current_user.id
    params = Record::extend_params_with(rec_params)
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        format.html { redirect_to(records_url, :notice => 'Record was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.xml
  def destroy
    @record = Record.users(current_user.id).find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to(records_url) }
      format.xml  { head :ok }
    end
  end
end
