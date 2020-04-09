#!/bin/bash
#
# Create a custom script with aliases for repititive dev tasks

#######################################
# Create the aliases and either append or echo them
# Globals:
#   TASKS
#   FILEPATH
# Arguments:
#   None
#######################################
function create_aliases() {
  ALIASES=()

  # Parse the commands for each of the tasks
  for i in "${TASKS[@]}"; do
    read -r -p "Alias for '$i': "
    ALIASES+=("$REPLY")
  done

  # Get path of shell rc. Defaults to `~/.bashrc`
  read -e -r -p "Path of your shell configuration file: (e.g .bashrc, .zshrc) [.bashrc]: " -i "$HOME/.bashrc" SHELL_CONFIG_PATH

  # Warn about modifying shell rc
  read -e -r -p "We will append now the aliases into ${SHELL_CONFIG_PATH}. Proceed? [Y/n]: " APPEND

  [[ -n $APPEND ]] && echo "Did not append aliases, add manually: "

  ## Append if accepted, print to stdout if not
  [[ -z $APPEND ]] &&
    # Create an alias for the script and command in the shell rc
    for i in ${!ALIASES[*]}; do
      ALIAS="alias ${ALIASES[$i]}=\". ${FILEPATH} ${TASKS[$i]}\""
      echo "${ALIAS}" >>"${SHELL_CONFIG_PATH}"
    done || echo "${ALIAS}"
}

DEFAULT_TASKS=("serve" "build" "test" "lint" "docs")
TASKS=()
COMMANDS=()

echo -e "\nThis script will create a tasks script for your project."
echo -e "Then it'll create aliases for each of those tasks.\n"

read -e -r -p "Do you want to use the default tasks (serve, build, test, lint, docs)? [Y/n]: " USE_DEFAULT

[[ -z \
$USE_DEFAULT || \
$USE_DEFAULT == 'y' || \
$USE_DEFAULT == 'Y' ]] &&
  TASKS=("${DEFAULT_TASKS[@]}") &&
  echo -e "\nUsing default tasks.\nLeave commands in blank if you don't want to use them." ||

  # Get input for the instructions (these are aliased so should be common)
  while read -r -p "Write an instruction (e.g. 'serve') [Enter to continue]: " && [[ $REPLY != '' ]]; do
    TASKS+=("$REPLY")
  done

echo ""

# Get input for the commands of each of the tasks
for i in "${TASKS[@]}"; do
  read -r -p "Command for '$i': "
  COMMANDS+=("$REPLY")
done

echo ""

read -e -r -p "Name of your script file [tasks]: " FILENAME

FILEPATH="./${FILENAME:-"tasks"}.sh"
echo ${FILEPATH}
echo -e "#!/bin/bash\n" >>"$FILEPATH"

echo "case \$1 in" >>"$FILEPATH"

for i in ${!TASKS[*]}; do
  echo -e "\t\"${TASKS[$i]}\") ${COMMANDS[$i]};;" >>"$FILEPATH"
done

echo "esac" >>"$FILEPATH"

read -e -r -p "Do you want to set aliases for the tasks? [Y/n]: " SET_ALIASES

[[ -z $SET_ALIASES ]] && create_aliases
