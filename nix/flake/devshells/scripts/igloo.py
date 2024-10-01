import os
import subprocess
import typer

from pathlib import Path
from typing import List

app = typer.Typer()
build_app = typer.Typer()
switch_app = typer.Typer()

app.add_typer(build_app, name="build")
app.add_typer(switch_app, name="switch")

HELP_HOME_CONFIG = (
    "Home configuration to build. "
    "If not specified, it will be guessed from `$USER` and `$HOSTNAME`."
)
HELP_NIXOS_CONFIG = (
    "NixOS configuration to build. "
    "If not specified, it will be guessed from `$HOSTNAME`."
)
HELP_HOME_ARGS = "Additional arguments passed to `home-manager`."
HELP_NIXOS_ARGS = "Additional arguments passed to `nixos-rebuild`"
HELP_UPDATE_CHECK = "Skip running checks after flake inputs update"
HELP_UPDATE_COMMIT = "Skip commit after flake inputs update"
HELP_UPDATE_INPUTS = "List of flake inputs to update"


@build_app.command("home")
def build_home(
    config: str = typer.Option(None, "--config", help=HELP_HOME_CONFIG),
    extra_args: List[str] = typer.Argument(None, help=HELP_HOME_ARGS),
):
    run_home_manager("build", config, extra_args=extra_args)


@switch_app.command("home")
def switch_home(
    config: str = typer.Option(None, "--config", help=HELP_HOME_CONFIG),
    extra_args: List[str] = typer.Argument(None, help=HELP_HOME_ARGS),
):
    run_home_manager("switch", config, extra_args=extra_args)


@build_app.command("nixos")
def build_nixos(
    config: str = typer.Option(None, "--config", help=HELP_NIXOS_CONFIG),
    extra_args: List[str] = typer.Argument(None, help=HELP_NIXOS_ARGS),
):
    run_nixos_rebuild("build", config, extra_args=extra_args)


@switch_app.command("nixos")
def switch_nixos(
    config: str = typer.Option(None, "--config", help=HELP_NIXOS_CONFIG),
    extra_args: List[str] = typer.Argument(None, help=HELP_NIXOS_ARGS),
):
    run_nixos_rebuild("switch", config, extra_args=extra_args)


@app.command("update")
def update(
    no_check: bool = typer.Option(False, "--no-check", help=HELP_UPDATE_CHECK),
    no_commit: bool = typer.Option(False, "--no-commit", help=HELP_UPDATE_COMMIT),
    inputs: List[str] = typer.Option(None, "--inputs", help=HELP_UPDATE_INPUTS),
):
    typer.echo("Updating flake inputs...")
    update_cmd = "nix flake update"
    if inputs:
        update_cmd = "nix flake lock " + " ".join(
            [f"--update-input {input}" for input in inputs]
        )
        typer.echo(f"Updating specific inputs: {', '.join(inputs)}")
    run_command(update_cmd)

    if not no_check:
        typer.echo("Running checks after flake inputs update...")
        run_command("nix flake check")

    if not no_commit:
        typer.echo("Committing update...")
        run_command("git commit flake.lock -m 'build(flake): update inputs'")


def run_command(command: str) -> None:
    typer.echo(f"Running: {command}")
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        typer.echo(f"Command failed: {e}", err=True)
        raise typer.Exit(code=1)


def run_home_manager(command: str, config: str, extra_args: List[str] | None) -> None:
    if config:
        home = config
    else:
        home = home_manager_config()

    args = " ".join(extra_args) if extra_args else ""

    cmd = f"home-manager {args} {command} -b bak --flake .#{home}"
    typer.echo(f"Running: {cmd}")
    subprocess.run(cmd, shell=True, check=True)


def home_manager_config() -> str:
    home = os.getenv("USER")

    if is_wsl_system():
        home += "@wsl"
    else:
        hostname = os.uname().nodename

        flake_path = Path(".")  # TODO: add check if we are in flake root
        hosts_path = flake_path / "nix" / "hosts"

        if hosts_path.is_dir():
            # List all folders in `$FLAKE/nix/hosts` and filter out ones with hyphens
            # we don't want to capture `<host>-wsl`
            valid_hostnames = [
                folder.name
                for folder in hosts_path.iterdir()
                if folder.is_dir() and "-" not in folder.name
            ]

            # Check if the current hostname exists in the valid_hostnames list
            if hostname in valid_hostnames:
                typer.echo(f"Hostname '{hostname}' found in flake.")
                home = f"{home}@{hostname}"
            else:
                typer.echo(
                    f"Hostname '{hostname}' not found in flake. "
                    f"Falling back to home-configuration '{home}'."
                )
        else:
            typer.echo(
                f"'Could not find NixOS systems in flake. "
                f"Falling back to home configuration '{home}'."
            )

    return home


def is_wsl_system() -> bool:
    state = False
    try:
        with open("/proc/version", "r") as f:
            version_info = f.read()
            if "Microsoft" in version_info or "WSL" in version_info:
                state = True
    except FileNotFoundError:
        state = False
    return state


def run_nixos_rebuild(command: str, config: str, extra_args: List[str] | None) -> None:
    if config:
        config = config
    else:
        config = os.uname().nodename

    args = " ".join(extra_args) if extra_args else ""

    cmd = f"nixos-rebuild {command} {args} --flake .#{config}"
    if command == "switch":
        cmd = "sudo " + cmd

    typer.echo(f"Running: {cmd}")
    subprocess.run(cmd, shell=True, check=True)


if __name__ == "__main__":
    app()
