require 'sinatra'
require 'sinatra/base'
require 'open3'
require 'json'

set :show_exceptions, :after_handler

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == ['rails_user', 'rails_pass']  
end

get '/execute' do
  content_type :json

  # Default message, in case that command is not passed as parameter
  return_message = {success: false, stdout: [], stderr: []}
  
  if params.has_key?('command') 
    begin
      stdin, stdout, stderr = Open3.popen3(params[:command])
      stdout_lines = []
      while line = stdout.gets do
        stdout_lines += [line]
      end
      stderr_lines = []
      while line = stderr.gets do
        stderr_lines += [line]
      end
      return_message = {success: true, stdout: stdout_lines, stderr: stderr_lines}
    rescue Errno::ENOENT => e
      return_message = {success: true, stdout: [], stderr: ["#{e.message}\n"]}
    rescue StandardError => e
      return_message = {success: false, stdout: [], stderr: ["#{e.message}\n"]}
    ensure
      stdin.close unless stdin.nil?
      stdout.close unless stdin.nil?
      stderr.close unless stdin.nil?
    end
  end

  return_message.to_json 
end
