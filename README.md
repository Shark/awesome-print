# awesome-print

This is CUPS v2.3 in a Docker container, pre-configured for the printers at my home. :heart_eyes:

## Deploy

- Create a bare Git repository

  ```
  mkdir awesome-print
  git init --bare
  ```

- Add the `post-receive` hook at `hooks/post-receive` (do not forget to `chmod +x post-receive`)

  ```bash
  #!/usr/bin/env bash
  set -euo pipefail; [[ "${TRACE-}" ]] && set -x

  GIT_DIR="$(pwd)"
  TARGET="${GIT_DIR}_src"

  while read oldrev newrev ref; do
    echo "Ref $ref received, deploying..."
    [[ ! -d $TARGET ]] && mkdir "$TARGET"
    git --work-tree="$TARGET" --git-dir="$GIT_DIR" checkout -f
    cd "$TARGET"
    sudo docker-compose --project-name "$(basename "$GIT_DIR")" up --detach --build
    sudo docker-compose --project-name "$(basename "$GIT_DIR")" exec -T cups add-printers.sh
    echo "Deployed."
  done
  ```

- Add a remote to your local repository

  ```
  git remote add deploy user@host:~/PATH
  ```

- Deploy! :tada:

  ```
  git push deploy master
  ```

## Run

After you run this for the first time, execute `add-printers.sh`:

```
docker-compose exec cups add-printers.sh
```

## Useful CUPS commands

- Find driver: `lpinfo --make-and-model "HL-2030" -m`
- Find printer options: `lpoptions -p Brother_QL-500 -l`
