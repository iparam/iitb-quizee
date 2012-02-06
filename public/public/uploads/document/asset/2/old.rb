def update_into_zimbra

    if self.completed
      self.progress = "COMP"
      self.progress_percentage = "100"
    else
      self.completed_at = nil
      self.progress = "INPR"
      self.progress_percentage = "0"
    end

    begin
      if self.lawyer_email
        get_zimbra_lawyer
        zimbra_admin = Company.find(User.find_by_email(self.lawyer_email).company_id).zimbra_admin_account_email
        if zimbra_admin
          if self.category.eql?("todo")
            if !self.zimbra_task_id or self.zimbra_task_status || @is_changed
              comp_hash = {
                  :all_day => 'allDay',
                  :name => 'name',
                  :progress_percentage => 'percentComplete',
                  :progress => 'status',
                  :priority => 'priority'
              }
              task_hash = {
                  :lawyer_name => "or",
                  :lawyer_email => "a",
                  :start_date => 's',
                  :end_date => 'e',
                  :name => 'su',
                  :zimbra_task_id => 'zimbra_task_id',
                  :description => 'content',
                  :zimbra_task_uid => 'zimbra_task_uid'
              }
              zimbra_task_hash = {}
              task_hash.each { |key, value|
                if key.eql?(:start_date) or key.eql?(:end_date)
                  zimbra_task_hash[value] = get_date(self[key])
                else
                  zimbra_task_hash[value] = self[key]
                end
              }
              zimbra_comp_hash = {}
              comp_hash.each { |key, value|
                zimbra_comp_hash[value] = self[key]
              }
              unless zimbra_comp_hash['class']
                zimbra_comp_hash["class"]="PUB"
              end

              unless zimbra_comp_hash['fb']
                zimbra_comp_hash["fb"]="B"
              end

              unless zimbra_comp_hash['allDay']
                zimbra_comp_hash["allDay"]="0"
              end

              zimbra_comp_hash["status"] = progress || "INPR"
              zimbra_comp_hash["percentComplete"] = progress_percentage || "0"

              zimbra_comp_hash['name'] = self.name + " <" +Matter.find(self.matter_id).name + ">"
              zimbra_task_hash['su'] = zimbra_comp_hash['name']
              
              domain = ZimbraUtils.get_domain(self.lawyer_email)
              host = ZimbraUtils.get_url(domain)
              key = ZimbraUtils.get_key(domain)
      
              location = 15
              if  ApplicationConfig.zimbra_server_config[domain]
                if !self.zimbra_task_id
                  resp_hash = ZimbraTask.create_task(key, host, self.lawyer_email, zimbra_task_hash, zimbra_comp_hash, location)
                  zimbra_id = resp_hash['invId'].blank? ? self.zimbra_task_id : resp_hash['invId']
                  MatterTask.update_all({:zimbra_task_id => resp_hash['invId'], :zimbra_task_status => false}, {:id => self.id})
                else
                  if @is_changed # this condition is added when lead lawyer is changed.The tasks of old lawyer must be created for new lead lawyer and then deleted for old lawyer
                    old_lawyer = self.lawyer_email_was
                    ZimbraTask.delete_task(key, host, old_lawyer, self.zimbra_task_id)
                    resp_hash = ZimbraTask.create_task(key, host, self.lawyer_email, zimbra_task_hash, zimbra_comp_hash, location)
                  else
                    resp_hash = ZimbraTask.update_task(key, host, self.lawyer_email, zimbra_task_hash, zimbra_comp_hash, location)
                  end
                  zimbra_id = resp_hash['invId'].blank? ? self.zimbra_task_id : resp_hash['invId']
                  MatterTask.update_all({:zimbra_task_id => resp_hash['invId'], :zimbra_task_status => false}, {:id => self.id})
                end
              end
            end
          elsif self.category.eql?("appointment")

            if !self.zimbra_task_id || self.zimbra_task_status || @is_changed

              apt_hash = {
                  :description => "content",
                  :attendees_emails => "at",
                  :repeat => "freq",
                  :reminder => "m",
                  :name => "su",
                  :lawyer_name => "or",
                  :lawyer_email => "a",
                  :zimbra_task_id => 'zimbra_task_id',
                  #:start_time => 'st',
                  #:end_time => 'et',
                  :start_date => 'sd',
                  :end_date => 'ed',
                  :count => 'count',
                  :until => 'until',
                  :exception_start_date => 'ex_date',
                  :exception_start_time => 'ex_time',
                  :task_id => 'task_id'
              }
              location =10

              zimbra_apt_comp_hash = {}
              zimbra_apt_comp_hash["status"]="CONF"
              zimbra_apt_comp_hash["fb"] ="T"
              zimbra_apt_comp_hash["class"] ="PRI"
              zimbra_apt_comp_hash["transp"]="O"
              zimbra_apt_comp_hash["name"] =self.name + " <" +Matter.find(self.matter_id).name + ">"
              unless zimbra_apt_comp_hash['allDay']
                zimbra_apt_comp_hash["allDay"]="0"
              end

              if self.occurrence_type.eql?("until")
                self.count = nil
              end

              zimbra_apt_hash ={}
              apt_hash.each { |key, value|
                if key.eql?(:start_date) or key.eql?(:end_date) or key.eql?(:until) or key.eql?(:exception_start_date)
                  zimbra_apt_hash[value] = get_date(self[key])
                  zimbra_apt_hash['st'] = self[key].strftime("%H%M%S") if key.eql?(:start_date)
                  zimbra_apt_hash['et'] = self[key].strftime("%H%M%S") if key.eql?(:end_date)
                elsif key.eql?(:start_time) or key.eql?(:end_time) or (key.eql?(:exception_start_time) and !self.exception_start_time.nil?)
                  zimbra_apt_hash[value] = self[key].strftime("%H%M%S")
                else
                  zimbra_apt_hash[value] = self[key]
                end
              }
              zimbra_apt_hash["su"] = zimbra_apt_comp_hash["name"]
              zimbra_apt_hash["content_mail"] = "The following is a new meeting request:

    Subject: #{zimbra_apt_hash["su"]}
    Organizer: #{zimbra_apt_hash["a"]}

    Invitees: #{zimbra_apt_hash["at"]}

    *~*~*~*~*~*~*~*~*~*

    #{zimbra_apt_hash["content"]}"

              domain = ZimbraUtils.get_domain(self.lawyer_email)
              host = ZimbraUtils.get_url(domain)
              key = ZimbraUtils.get_key(domain)
              if  ApplicationConfig.zimbra_server_config[domain]
                #zimbra_apt_hash["tz"] = ZimbraTask.get_prefs_request(key, host,self.lawyer_email.to_s,self.lawyer_name.to_s)
                zimbra_apt_hash["tz"] = User.find_by_email(self.lawyer_email).zimbra_time_zone

                if self.zimbra_task_id.blank? # this condition when first time a new appointment is created. Then zimbra task id does not exist . So just create
                  resp_hash = ZimbraTask.create_apt(key, host, self.lawyer_email, zimbra_apt_hash, zimbra_apt_comp_hash, location)
                  zimbra_id = resp_hash['invId'].blank? ? self.zimbra_task_id : resp_hash['invId']
                  MatterTask.update_all({:zimbra_task_id => zimbra_id, :zimbra_task_status => false}, {:id => self.id})
                else
                  if self.task_id.present? and zimbra_task_id.blank?
                    #|| self.exception_status == true # if exception then task id will be present so create exception.
                    # when lead lawyer is changed(condition to check @is_changed) then all the exceptions as well as deleted instances are passed.
                    # in such cases the zimbra_task_id of such instances must refer to the parent zimbra_task_id.
                    zimbra_apt_hash["zimbra_task_id"] = MatterTask.find_by_id(self.task_id).zimbra_task_id if @is_changed
                    resp_hash = ZimbraTask.create_exception_apt(key, host, self.lawyer_email, zimbra_apt_hash, zimbra_apt_comp_hash, location)
                    zimbra_id = resp_hash['invId'].blank? ? self.zimbra_task_id : resp_hash['invId']
                    MatterTask.update_all({:zimbra_task_id => zimbra_id, :zimbra_task_status => false, :exception_status => false}, {:id => self.id})
                  else
                    if @is_changed #if lead lawyer is changed
                      old_lawyer = self.lawyer_email_was
                      cancel_hash ={
                          "at" => self.attendees_emails,
                          "su" => self.name,
                          "content" =>"The following is a new meeting request:

                  Subject: #{self.name}
                  Organizer: #{self.lawyer_email}
                  Invitees: #{self.attendees_emails}

                  *~*~*~*~*~*~*~*~*~*

                  #{self.description}"
                      }

                      unless self.exception_start_date.blank?
                        cancel_hash["ex_start_date"] = get_date(self.exception_start_date)
                        #cancel_hash["ex_start_time"] = (self.exception_start_time).strftime("%H%M%S")
                        cancel_hash["tz"] = ZimbraTask.get_prefs_request(key, host, old_lawyer.to_s, old_lawyer.to_s)
                      end
                      # delete appointments for old and create for new
                      ZimbraTask.delete_apt(key, host, old_lawyer, cancel_hash, self.zimbra_task_id)
                      resp_hash = ZimbraTask.create_apt(key, host, self.lawyer_email, zimbra_apt_hash, zimbra_apt_comp_hash, location)
                    else
                      # if none of above and appointment is just edited then update the appointment
                      resp_hash = ZimbraTask.update_apt(key, host, self.lawyer_email, zimbra_apt_hash, zimbra_apt_comp_hash, location)
                    end
                    zimbra_id = resp_hash['invId'].blank? ? self.zimbra_task_id : resp_hash['invId']
                    MatterTask.update_all({:zimbra_task_id => zimbra_id, :zimbra_task_status => false}, {:id => self.id})
                  end
                end
              end
            end
          end
        end
      end
