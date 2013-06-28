class Meeting < ActiveRecord::Base
  attr_accessible :body, :deadline, :duedate, :state, :collaborators, :duration

  has_many :meeting_collaborators
  has_many :users, :through => :meeting_collaborators

  def collaborators=(_collaborators)
  	self.users << _collaborators.map {|collaborator| User.find_or_create_by_email(collaborator)}
  end

  def to_hash(include_state=false)
    meeting_hash = self.attributes
    meeting_hash["collaborators"] = self.users.map(&:email)
    if include_state
      meeting_hash["users_response"] = self.meeting_collaborators.map(&:state)
    end
    meeting_hash
  end

  def handle_meeting_request
    # return in case of empty collaborators meeting
    return if self.users.empty?

  	# calc due date from java code
  	self.update_attribute(:duedate, Time.now.to_i)
		
		meeting_json = self.to_json(:include => {:users => {:only => :email}})

  	# preparing android message
		android_message = {data: {meeting: meeting_json}, collapse_key: "meeting_request"}
  	
  	# preparing wp message
    wp_message = {
      title: "meeting_request",
      content: "meeting request from #{self.users.first.email}",
      params: self.to_hash
    }
		broadcast_message(android_message, wp_message)
  end

  def check_global_state
  	return if self.meeting_collaborators.exists?(['state IS NULL'])

  	if self.meeting_collaborators.exists?(:state => 'declined')
  		decline
  	else
  		accept
  	end
  end

  def decline
		meeting_json = self.to_json(:include => {:users => {:only => :email},
																						 :meeting_collaborators => {:only => :state}})

  	# preparing android message
		android_message = {data: {meeting: meeting_json}, collapse_key: "decline_meeting"}
  	
  	# preparing wp message
    wp_message = {
      title: "decline_meeting",
      content: "meeting request from #{self.users.first.email}",
      params: self.to_hash(true)
    }

		broadcast_message(android_message, wp_message)  	
  end

  def accept
  	meeting_json = self.to_json(:include => {:users => {:only => :email}})

  	# preparing android message
		android_message = {data: {meeting: meeting_json}, collapse_key: "accept_meeting"}
  	
  	# preparing wp message
    wp_message = {
      title: "accept_meeting",
      content: "meeting request from #{self.users.first.email}",
      params: self.to_hash
    }

		broadcast_message(android_message, wp_message)  	
  end

  protected
  def broadcast_message(android_message, wp_message)
  	android_users = []
  	wp_users = []
  	unregistered_users = []
  	
  	self.users.each do |user|
  		if user.registration_id.nil?
  			unregistered_users << user
  		elsif user.email.include? "@gmail.com" 
  			android_users << user
  		elsif user.email.include? "@hotmail.com"
  			wp_users << user
  		end
  	end

  	# send notification to android users
		gcm = GCM.new(GCM_API_KEY)
		registration_ids = android_users.map(&:registration_id)
		response = gcm.send_notification(registration_ids, android_message)
  	
  	# send notification to WP users
		wp_users.each do |wp_user|
	    reponse = MicrosoftPushNotificationService.send_notification wp_user.registration_id, :toast, wp_message
		end

		# other users are not handled
  end
end