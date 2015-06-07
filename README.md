# Execute command - REST
Sinatra rest service, executes command remotelly, and returns json.

Usage:
- Change default username and password (optional)
- Start service "ruby execute_command_rest.rb" (default port 4567) or "ruby execute_command_rest.rb -p 12345" 
- Go to URL "localhost:4567/execute?command=ls -la"
