import re
import sys

USER = "loicreynier"
REPO = "igloo"


def check_github_urls(file_paths, user, repo, branch="main"):
    """Check if GitHub URLs in the provided files target `branch`."""
    url_pattern = re.compile(
        r"https://(?:raw\.githubusercontent\.com|github\.com)/"
        f"{user}/{repo}/"
        r"raw/([^/]+)/"
    )
    all_good = True

    for file_path in file_paths:
        with open(file_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
            for line_num, line in enumerate(lines, 1):
                match = url_pattern.search(line)
                if match and match.group(1) != "main":
                    print(
                        f"URL in file '{file_path}', line {line_num} "
                        f"targets branch '{match.group(1)}' instead of 'main'.",
                        file=sys.stderr,
                    )
                    all_good = False

    return all_good


def main():
    file_paths = sys.argv[1:]

    if not file_paths:
        sys.exit(0)

    if not check_github_urls(file_paths, USER, REPO):
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
