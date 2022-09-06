require 'octokit'
require 'json'
repo_json=[]
searchQuery=''
while searchQuery.chomp.empty?
  puts 'please enter your search query'
  searchQuery=gets
end
errorMessage=''
  begin
    client = Octokit::Client.new(:access_token => 'your access token')
    repoInfo=client.get("/search/repositories?q=#{searchQuery}&sort=stars&order=desc&per_page=10")
   if client.last_response.status == 503
    errorMessage='Service Unavailable'
    raise "Service Unavailable"
   elsif client.last_response.status == 422
    errorMessage='Unprocessable Entity'
    raise "Unprocessable Entity"
   elsif client.last_response.status == 404
    errorMessage='Not Found'
    raise "Not Found"
   elsif client.last_response.status == 403
    errorMessage='Forbidden'
    raise "Forbidden"
   elsif client.last_response.status == 401
    errorMessage='Unauthorized'
    raise "Unauthorized"
   elsif client.last_response.status == 200
    repoInfo['items'].each do |item|
      repo_json.push({:name => item['name'], :description => item['description'], :url => item['html_url'], :username => item['owner']['login']})
    end
    puts repo_json.to_json
   end
  rescue 
    puts errorMessage
end