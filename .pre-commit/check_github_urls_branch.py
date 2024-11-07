import re
import subprocess
import sys

USER = "loicreynier"
REPO = "igloo"
BRANCH = "main"


def check_github_urls(file_paths, user, repo, branch="main"):
    """Check if GitHub URLs in the provided files target `branch`."""
    url_pattern = re.compile(
        r"https://(?:raw\.githubusercontent\.com|github\.com)/"
        f"{user}/{repo}/"
        r"(?:raw/)?"
        r"([^/]+)/"
    )
    all_good = True

    for file_path in file_paths:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
            for line_num, line in enumerate(lines, 1):
                match = url_pattern.search(line)
                if match and match.group(1) != branch:
                    print(
                        f"URL in file '{file_path}', line {line_num} "
                        f"targets branch '{match.group(1)}' instead of '{branch}'.",
                        file=sys.stderr,
                    )
                    all_good = False

    return all_good


def current_branch():
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error checking current branch: {e}", file=sys.stderr)
        return None


def main():
    if current_branch() != BRANCH:
        sys.exit(0)

    file_paths = sys.argv[1:]

    if not file_paths:
        sys.exit(0)

    if not check_github_urls(file_paths, USER, REPO, branch=BRANCH):
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
