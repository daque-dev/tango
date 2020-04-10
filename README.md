# tasks.sh

Create aliases for all your important development commands

## Core concepts

This script handles three core concepts:

- `abbr`, abbreviation for _abbreviation_,
- `task`, which is a human-readable instruction, and
- `command`, the command executed when you run a `task`.

Then, when you run an `abbr` inside a directory indexed by `tasks.sh`, it'll
find its corresponding `task`, and execute the custom per-project `command` for
that task.

### Example

- `~/my-project/taskfile.sh` This lives in your project and maps a `task` to its
  `command`.

  ```sh
  #!/bin/bash
  case $1 in
      "serve") python -m http.server;;
      "build") make build;;
  esac
  ```

- `~/.config/tasks/abbrs`: This maps an`abbr` (that will be aliased in your
  shell) to a task in **any** `taskfile`. **The implementation of the tasks
  depends on your project.**

  ```
  s serve
  b build
  ```

- `~/.config/tasks/taskfiles`: This maps each indexed directory to its
  `taskfile`.

  ```
  ~/my-project ~/my-project/taskfile.sh
  ```

Now, if you execute either `s` or `b` inside `~/my-project`, you'll execute
`python -m http.server` and `make build` respectively.
