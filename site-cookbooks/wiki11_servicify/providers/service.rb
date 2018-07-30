action :create do
  owner = new_resource.owner || 'root'
  group = new_resource.group || 'root'
  mode = new_resource.mode || '0755'

  template_source = new_resource.template_source || 'etc.init.d.service.erb'
  template_cookbook = new_resource.template_cookbook || 'wiki11_servicify'
  restart_script_cookbook = new_resource.restart_script_cookbook || 'wiki11_servicify'

  script_path = new_resource.script_path || '/sbin:/usr/sbin:/bin:/usr/bin'
  script_description = new_resource.script_description || '"Description of the service"'
  script_name = new_resource.script_name || 'daemonexecutablename'
  script_daemon = new_resource.script_daemon || "/usr/sbin/#{script_name}"
  script_daemon_args = new_resource.script_daemon_args || ''
  script_daemon_user = new_resource.script_daemon_user || 'wiki11dev'
  script_daemon_path = new_resource.script_daemon_path || '/'
  script_daemon_stdout = new_resource.script_daemon_stdout || '/dev/null'
  script_daemon_stderr = new_resource.script_daemon_stderr || '/dev/null'

  script_pidfile = new_resource.script_pidfile || "/var/run/#{script_name}.pid"
  script_scriptname = new_resource.script_scriptname || "/etc/init.d/#{script_name}"

  script_env = new_resource.script_env || {}

  restart_scriptname = new_resource.restart_scriptname || "/var/run/#{script_name}.pid"
  restart_scriptpath = new_resource.restart_scriptpath || "/usr/bin/#{script_name}_restart.sh"
  restart_owner = new_resource.restart_owner || owner
  restart_group = new_resource.restart_group || group
  restart_mode = new_resource.restart_mode || '0544'
  restart_pids_script = new_resource.restart_pids_script || "ps -ef | grep #{script_daemon_user} | grep #{script_name} | awk '{print $2}'"

  variables = {
    :script_path => script_path,
    :script_description => script_description,
    :script_name => script_name,
    :script_daemon => script_daemon,
    :script_daemon_args => script_daemon_args,
    :script_daemon_user => script_daemon_user,
    :script_daemon_path => script_daemon_path,
    :script_daemon_stdout => script_daemon_stdout,
    :script_daemon_stderr => script_daemon_stderr,
    :script_pidfile => script_pidfile,
    :script_scriptname => script_scriptname,
    :script_env => script_env
  }

  template 'service skeleton' do
    path script_scriptname
    source template_source
    cookbook template_cookbook
    owner owner
    group group
    variables variables
    mode mode
  end

  # Because monit somehow likes to restart multiple instances
  restart_variables = {
    :script_name => script_name,
    :pids_script => restart_pids_script
  }
  template 'service restart script' do
    path restart_scriptpath
    source 'usr.bin.service_restart.sh.erb'
    cookbook restart_script_cookbook
    owner restart_owner
    group restart_group
    variables restart_variables
    mode restart_mode
  end
end
