actions :create
default_action :create

attribute :owner, :kind_of => String
attribute :group, :kind_of => String
attribute :mode, :kind_of => String

attribute :template_source, :kind_of => String
attribute :template_cookbook, :kind_of => String
attribute :restart_script_cookbook, :kind_of => String

attribute :script_path, :kind_of => String
attribute :script_description, :kind_of => String
attribute :script_name, :kind_of => String, :name_attribute => true

attribute :script_daemon, :kind_of => String
attribute :script_daemon_args, :kind_of => String
attribute :script_daemon_user, :kind_of => String
attribute :script_daemon_path, :kind_of => String
attribute :script_daemon_stdout, :kind_of => String
attribute :script_daemon_stderr, :kind_of => String

attribute :script_pidfile, :kind_of => String
attribute :script_scriptname, :kind_of => String

attribute :script_env, :kind_of => Hash

attribute :restart_scriptname, :kind_of => String
attribute :restart_scriptpath, :kind_of => String
attribute :restart_owner, :kind_of => String
attribute :restart_group, :kind_of => String
attribute :restart_mode, :kind_of => String
attribute :restart_pids_script, :kind_of => String
