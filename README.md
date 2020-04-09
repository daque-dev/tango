# tasks.sh

Create aliases for all your important development commands

## What it does

`tasks.sh` will create three files on the first run: `init.sh`, `aliases.sh`,
and `taskfileperdir.sh`, all in the path `$HOME/.config/tasks/`.

- `init.sh` sources both `aliases.sh` and `taskfileperdir.sh`.
- `aliases.sh` contains the aliases for every task in every of your projects.
- `taskfileperdir.sh` maps a directory with a `taskfile`.

---

When `tasks.sh` is run, it'll prompt you the `tasksfile` name, each `task` and
each `taskcommand`.

Assuming you run the script in `~/my-project`, set a `tasksfile = my-tasks.sh`,
and have 2 tasks `serve` and `build`, with their respective commands
`python -m http.server` and `make build`, you'd have these files:

- `~/my-project/my-tasks.sh`

  ```sh
  #!/bin/bash
  case $1 in
      "serve") python -m http.server;;
      "build") make build;;
  esac
  ```

- `$HOME/.config/tasks/taskfileperdir.sh`

  Set the `taskfile` path to an absolute path so it can be accessed within
  subdirectories.

  ```sh
  #!/bin/bash
  declare -A TASKFILES
  TASKFILES["${HOME}/my-project/"]="${HOME}/my-project/my-tasks.sh"
  ```

- `$HOME/.config/tasks/aliases.sh`

  ```sh
  #!/bin/bash
  alias s=". ${TASKFILE} serve"
  alias b=". ${TASKFILE} build"
  ```
