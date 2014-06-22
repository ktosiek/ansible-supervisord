Role Name
========

Install & configure Supervisor.

Role Variables
--------------

None of them are required, but you probably want to set ``supervisord_programs`` and ``supervisord_instance_name``.
**Escape warning**: most options need "%" escaped as "%%", as supervisord uses %(var_name)s for variable substitution.


    supervisord_instance_name: "default"

This name will be used in default paths and for init script names.
If you need multiple supervisor daemons, that's how they are told apart.


    supervisord_logfile: "/var/log/supervisor/{{ supervisord_instance_name }}.log"

Main log file settings: location, maximum size before rotating it, and maximum amount of rotated copies that'll be kept.


    supervisord_user: no

Run supervisord as this user.


    supervisord_environemt: {}

Environment for supervisord and all children.
This can have 2 forms, either a string (that will be put literally into config file) or a dictionary of variable: value.


    supervisord_identifier: "{{ supervisord_instance_name }}"

Identifier for use in RPC communication.


    supervisord_programs: []

Programs this instance should supervise. List of dictionaries, fields used here are described in Program Definition section.


    supervisord_extra_config: {}

Additional configuration for supervisord.
It's a dictionary mapping section name to a dictionary mapping options to values, for example: ``{ inet_http_server: { port: 9001 } }``.
If some option is also used by this role, it will be overridden (so be careful).


Program Definition
------------------

Each element of supervisord_programs defines a process group.
The full list of settings is at: http://supervisord.org/configuration.html#program-x-section-values.
Most settings are just written into the file (with some care for booleans and numbers), this lists only includes the special ones.

    name: No default, required

Name of this process group.
This will be available as %(program_name)s in all string values in this group.


    command: No default, required

The command to run.


    socket: No default, optional

Socket to listen on, on behalf of this program.
Setting this will generate an fcgi-program:{{ name }} instead of program:{{ name }} section.


    environment: {}

Additional environment variables for this process group. For format see supervisord_environemt in Role Variables.


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
