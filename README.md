# tasks.sh

Create aliases for all your important development commands

## Core concepts

This script handles three core concepts:

- `abbr`, abbreviation for _abbreviation_,
- `task`, which is a human-readable instruction, and
- `command`, the command executed when you run a `task`.

To use them, first you need to _index_ a custom directory. This creates a
`taskfile` in your current directory and adds both the path of the directory and
its `taskfile` to the `tasks.sh` configuration.

Then, if you run an `abbr` whithin that _indexed_ directory, it'll find its
corresponding `task`, and execute the `command` for that task, as specified in
that directory's `taskfile`.

### Example

- `~/my-project/taskfile` This lives in your project and maps a `task` to its
  `command`.

  ```
  serve python -m http.server
  build make build
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
  ~/my-project ~/my-project/taskfile
  ```

Now, if you execute either `s` or `b` inside `~/my-project`, you'll execute
`python -m http.server` and `make build` respectively.
