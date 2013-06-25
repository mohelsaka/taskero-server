class MeetingsController < ApplicationController
  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all
    
    Delayed::Job.all.each {|job| job.invoke_job}
    Delayed::Job.delete_all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetings }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.json
  def new
    @meeting = Meeting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.new(params[:meeting])
    
    saved = @meeting.save
    if saved
      @meeting.delay.handle_meeting_request
    end
    
    respond_to do |format|
      if saved
        format.html { redirect_to @meeting, notice: 'Meeting was successfully created.' }
        format.json { render json: @meeting, status: :created, location: @meeting }
      else
        format.html { render action: "new" }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.json
  def update
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      if @meeting.update_attributes(params[:meeting])
        format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to meetings_url }
      format.json { head :no_content }
    end
  end

  def decline
    @meeting = Meeting.find(params[:id])
    @meeting.meeting_collaborators.find_by_user_id(params[:user_id]).decline
    @meeting.delay.check_global_state

    respond_to do |format|
      format.html { redirect_to @meeting, notice: 'Meeting was successfully declined.' }
      format.json { render json: @meeting, status: :created, location: @meeting }
    end
  end

  def accept
    @meeting = Meeting.find(params[:id])
    @meeting.meeting_collaborators.find_by_user_id(params[:user_id]).accept
    @meeting.delay.check_global_state

    respond_to do |format|
      format.html { redirect_to @meeting, notice: 'Meeting was successfully accepted.' }
      format.json { render json: @meeting, status: :created, location: @meeting }
    end
  end
end
