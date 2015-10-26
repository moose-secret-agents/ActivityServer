module Coach
  class Entry < Coach::Entity
    # Create new Entry
    def self.create(username, password, activity_type, attributes={})
      auth = { username: username, password: password }
      response = post "/users/#{username}/#{activity_type}",basic_auth: auth, body: attributes.to_json, headers: { 'Content-Type' =>'application/json'}
      puts attributes.to_s
      puts response.code
      response.code == 201 ? Coach::Entry.new(JSON.parse(response.body)) : nil
    end
  end
end