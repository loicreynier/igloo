import typer

app = typer.Typer(
    add_completion=False,
)


@app.command()
def say_hello():
    typer.echo("Hello, World!")


def main():
    app()


if __name__ == "__main__":
    app()
