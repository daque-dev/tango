#
# Prompt user for the desired tasks, abbrs, and commands
# Create (or update) the configuration files `abbrs` and `taskfiles`

# ---------------------------------------------------------------------------- #

function echo_introduction() {
    echo ""
    echo "This script will create a tasks script for your project."
    echo "Then it'll create aliases for each of those tasks."
    echo ""
}

#######################################
# Obtains an array of tasks to include in the taskfile
# Globals:
#   tasks
# Outputs:
#   Returns the tasks in an array
#######################################
function get_tasks() {
    echo ""
    while read -r -p "Name of the task [Enter to continue]: " && [[ -n $REPLY ]]; do
        tasks+=("$REPLY")
    done
}

#######################################
# Obtains an associative array for the abbrs
# Globals:
#   tasks
#   abbrs
# Outputs:
#   Associative array for abbrs and taks
#######################################
function get_abbrs() {
    # Get input for the commands of each of the tasks
    for i in "${tasks[@]}"; do
        read -r -p "Abbr for '$i': " abbr
        abbrs["$abbr"]=$i
    done
}

function get_task_file_name() {
    read -e -r -p "Name of your script file [tasks]: "
    echo ${REPLY:="tasks"}".sh"
}

function init() {
    tasks=()
    declare -A abbrs

    echo_introduction

    get_tasks

    echo ""

    get_abbrs

    echo ""

    taskfile=$(get_task_file_name)
}
