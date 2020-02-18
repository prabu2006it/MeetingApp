namespace :data do

  # spring rake data:import_user
  task :import_user => :environment do
    uri = URI.parse("http://intranet.accionlabs.com:3005")
    path = "/employee/get-employees"
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(path)
    response = http.request(request)
    users = JSON.parse(response.body)
    users["data"].each_with_index do |ext_user, index|
      puts "user: #{index + 1}"
      user = User.where(email: ext_user["EmailID"]).last
      if user.present?
        user.update_attributes(role: 1, active: ext_user["Employeestatus"].to_s == "Active" ? true : false, external_id: ext_user["_id"], department: ext_user["Department"], emp_id: ext_user["EmployeeID"], first_name: ext_user["FirstName"], last_name: ext_user["LastName"], password: ext_user["FirstName"].to_s + ext_user["EmployeeID"].to_s, project: ext_user["Project"])
      else
        User.create(email: ext_user["EmailID"], role: 1, active: ext_user["Employeestatus"].to_s == "Active" ? true : false, external_id: ext_user["_id"], department: ext_user["Department"], emp_id: ext_user["EmployeeID"], first_name: ext_user["FirstName"], last_name: ext_user["LastName"], password: ext_user["FirstName"].to_s + ext_user["EmployeeID"].to_s, project: ext_user["Project"])
      end
    end
  end

end
