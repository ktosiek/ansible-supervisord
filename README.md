supervisord
===========

Install & configure Supervisor.
This role provides it's own Upstart init script, and can install it for each supervised application.
It will also deactivate the distro's one (configurable with supervisord_enable_distro_init).


Requirements
------------

Static ansible_managed.
    This role uses the ``ansible_managed`` variable. If you set it to something dynamic (or left the default), you should pass a static one into this role - otherwise you'll see unnecessary restarts.



Role Variables
--------------

None of them are required, but you probably want to set ``supervisord_programs`` and ``supervisord_instance_name``.
**Escape warning**: most options need "%" escaped as "%%", as supervisord uses %(var_name)s for variable substitution.


    supervisord_instance_name: "default"

This name will be used in default paths and for init script names.
If you need multiple supervisor daemons, that's how they are told apart.


    supervisord_configuration_file: "/etc/supervisord-{{ supervisord_instance_name }}.conf"

Where to put this instance's configuration.


    supervisord_logfile: "/var/log/supervisor/{{ supervisord_instance_name }}.log"

Main log file location.


    supervisord_user: no

Run supervisord as this user.


    supervisord_environment: {}

Environment for supervisord and all children.
This can have 2 forms, either a string (that will be put literally into config file) or a dictionary of variable: value.


    supervisord_identifier: "{{ supervisord_instance_name }}"

Identifier for use in RPC communication.


    supervisord_programs: []

Programs this instance should supervise. List of dictionaries, fields used here are described in Program Definition section.


    supervisord_disable_distro_init: yes

Should the distribution-provided init script be turned off? This will also stop the instance managed by that script.


    supervisord_extra_config: {}

Additional configuration for supervisord.
It's a dictionary mapping section name to a dictionary mapping options to values, for example: ``{ inet_http_server: { port: 9001 } }``.
If some option is also set by this role, it might show up twice (so be careful).


Program Definition
------------------

Each element of supervisord_programs defines a process group.
The full list of settings is at: http://supervisord.org/configuration.html#program-x-section-values.
Most settings are just written into the file (with some care for booleans), this lists only includes the special ones.


    name: No default, required

Name of this process group.
This will be available as %(program_name)s in all string values in this group.


    command: No default, required

The command to run.


    socket: No default, optional

Socket to listen on, on behalf of this program.
Setting this will generate an fcgi-program:{{ name }} instead of program:{{ name }} section.


    environment: {}

Additional environment variables for this process group. For format see supervisord_environment in Role Variables.


Handlers
--------

This role exports following handlers:

    restart {{ supervisord_instance_name }}

Restarts the whole supervisord process.

    reload {{ supervisord_instance_name }}

Reloads supervisord configuration.


Using as a role dependency
--------------------------

When using this role as a dependency, you'll probably want to pass your role's name as supervisord_instance_name and use something like this for handlers:

    - name: Restart my web workers
      supervisorctl:
        name: my_app-web
        state: restarted
        config: "{{ supervisord_configuration_file }}"

One warning though - if you use supervisorctl with state=started just after reloaading/restarting supervisord
it might throw strange looking errors like ``ERROR (already started)``.
This looks like a bug in supervisorctl module, for a workaround see _vagrant/playbook.yml

TODO: link to a bug report
TODO: shortcut for this


Example Playbook
-------------------------

    - hosts: my_app_servers
      roles:
      - my_app_role
      - role: ktosiek.supervisord
        supervisord_instance_name: "my_app"
        supervisord_programs:
          - name: my_app
            command: /opt/my_app/fcgi
            socket: /var/run/my_app/my_app.socket


License
-------

BSD
