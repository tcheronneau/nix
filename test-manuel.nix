let
  # For extra determinism
  nixpkgs =
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/5233fd2ba76a3accb5aaa999c00509a11fd0793c.tar.gz";
    };

  # Single source of truth for all tutorial constants
  database = "postgres";
  schema   = "api";
  table    = "todos";
  username = "authenticator";
  password = "mysecretpassword";
  webRole  = "web_anon";

  nixos =
    import "${nixpkgs}/nixos" {
      system = "x86_64-linux";

      configuration = { config, pkgs, ... }: {
        # Open the default port for `postgrest` in the firewall
        networking.firewall.allowedTCPPorts = [ 3000 ];

        services.postgresql = {
          enable = true;

          initialScript = pkgs.writeText "initialScript.sql" ''
            create schema ${schema};

            create table ${schema}.${table} (
              id serial primary key,
              done boolean not null default false,
              task text not null,
              due timestamptz
            );

            insert into ${schema}.${table} (task) values
              ('finish tutorial 0'), ('pat self on back');

            create role ${webRole} nologin;

            grant usage on schema ${schema} to ${webRole};
            grant select on ${schema}.${table} to ${webRole};

            create role ${username} noinherit login password '${password}';
            grant ${webRole} to ${username};
          '';
        };

        users = {
          mutableUsers = false;

          users = {
            # For ease of debugging the VM as the `root` user
            root.password = "";

            # Create a system user that matches the database user so that we
            # can use peer authentication.  The tutorial defines a password,
            # but it's not necessary.
            "${username}"= {
              isSystemUser = true;
              group = "${username}";
            };
          };
          groups."${username}" = {};
        };

        systemd.services.postgrest = {
          wantedBy = [ "multi-user.target" ];

          after = [ "postgresql.service" ];

          script =
            let
              configuration = pkgs.writeText "tutorial.conf" ''
                db-uri = "postgres://${username}:${password}@localhost:${toString config.services.postgresql.port}/${database}"
                db-schema = "${schema}"
                db-anon-role = "${username}"
              '';

            in
              ''
                ${pkgs.haskellPackages.postgrest}/bin/postgrest ${configuration}
              '';

          serviceConfig.User = username;
        };

        # Uncomment the next line for running QEMU on a non-graphical system
        # virtualisation.graphics = false;
      };
    };

in
  nixos.vm
