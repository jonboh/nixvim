{ lib, inputs, ... }:
{
  imports =
    [ ./devshell.nix ]
    ++ lib.optional (inputs.git-hooks ? flakeModule) inputs.git-hooks.flakeModule
    ++ lib.optional (inputs.treefmt-nix ? flakeModule) inputs.treefmt-nix.flakeModule;

  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
      treefmt.config = {
        projectRootFile = "flake.nix";
        flakeCheck = true;

        programs = {
          isort.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          prettier = {
            enable = true;
            excludes = [ "**.md" ];
          };
          ruff = {
            check = true;
            format = true;
          };
          statix.enable = true;
          stylua.enable = true;
          shfmt.enable = true;
          # FIXME: re-enable on darwin, currently broken: taplo with options '[format]' failed to apply: exit status 101
          taplo.enable = pkgs.stdenv.isLinux;
        };

        settings = {
          global.excludes = [
            ".editorconfig"
            ".envrc"
            ".git-blame-ignore-revs"
            ".gitignore"
            "LICENSE"
            "flake.lock"
            "**.md"
            "**.scm"
            "**.svg"
            "**/man/*.5"
            # Those files are generated by pytest-regression, which then `diff`s them.
            # Formatting them will make the tests fail.
            "docs/gfm-alerts-to-admonitions/tests/**/*.yml"
          ];
          formatter.ruff-format.options = [ "--isolated" ];
        };
      };
    }
    // lib.optionalAttrs (inputs.git-hooks ? flakeModule) {
      pre-commit = {
        # We have a treefmt check already, so this is redundant.
        # We also can't run the test if it includes running `nix build`,
        # since the nix CLI can't build within a derivation builder.
        check.enable = false;

        settings.hooks = {
          treefmt.enable = true;
          typos = {
            enable = true;
            excludes = [ "generated/*" ];
          };
          maintainers = {
            enable = true;
            name = "maintainers";
            description = "Check maintainers when it is modified.";
            files = "^lib/maintainers[.]nix$";
            package = pkgs.nix;
            entry = "nix build --no-link --print-build-logs";
            args = [ ".#checks.${system}.maintainers" ];
            pass_filenames = false;
          };
          plugins-by-name = {
            enable = true;
            name = "plugins-by-name";
            description = "Check `plugins/by-name` when it's modified.";
            files = "^(?:tests/test-sources/)?plugins/by-name/";
            package = pkgs.nix;
            entry = "nix build --no-link --print-build-logs";
            args = [ ".#checks.${system}.plugins-by-name" ];
            pass_filenames = false;
          };
        };
      };
    };
}
