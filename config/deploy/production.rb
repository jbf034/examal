server "wcsyxx.s162.airbean.com", port: 22322, user: "root", roles: [:app, :web, :db]
set :deploy_to, '/app'
set :branch, "master"
set :ssh_options, {
  user: 'root',
  forward_agent: true
}
