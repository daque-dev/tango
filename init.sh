#
# Prompt user for the desired tasks, abbrs, and commands
# Create (or update) the configuration files `abbrs` and `taskfiles`

#######################################
# Initialize the tasks.sh script.
#
# This will prompt the user for available tasks, with their
# corresponding commands and abbrs.
#
# It'll create both the local files for the current directory,
# and the global files for the system in `$HOME/.config/tasks/`
#######################################
function tasks-init() {

    #######################################
    # Print the description of the script
    #######################################
    function echo_introduction() {
        echo
        echo "This script will create a tasks script for your project."
        echo "Then it'll create aliases for each of those tasks."
    }

    #######################################
    # Obtains an array of tasks to include in the taskfile
    # Globals:
    #   tasks
    #######################################
    function get_tasks() {
        echo -e "$DELIMITTER"
        echo "Write the tasks you want to add." \
            "These should be short and readable."
        echo "For example: 'serve', 'build', 'test'"
        echo -e "$YELLOW"
        echo "These are for reference. You won't be using them as commands."
        echo -e "$RESET"
        echo "When you're done, press Enter."
        echo
        while read -r -p "Name of the task: " && [[ -n $REPLY ]]; do
            tasks+=("$REPLY")
        done
    }

    #######################################
    # Obtains an associative array for the abbrs and tasks
    # Globals:
    #   tasks
    #   abbrs
    #######################################
    function get_abbrs() {
        echo -e "$DELIMITTER"
        echo "Write the abbreviations for each of the tasks."
        echo -e "$YELLOW"
        echo "You'll be using them as commands, and will be aliased,"
        echo "so make sure you don't collide them."
        echo -e "$RESET"
        # Get input for the commands of each of the tasks
        for i in "${tasks[@]}"; do
            read -r -p "Abbr for '$i': " abbr
            abbrs["$abbr"]=$i
        done
    }

    #######################################
    # Obtains an associative array for the tasks and commands
    # Globals:
    #   tasks
    #   commands
    #######################################
    function get_commands() {
        echo -e "$DELIMITTER"
        echo "Write the commands that each task will trigger."
        echo -e "$YELLOW"
        echo "These are the **real** commands you'll execute."
        echo -e "$RESET"
        # Get input for the commands of each of the tasks
        for i in "${tasks[@]}"; do
            read -r -p "Command to $i: " cmd
            commands["$i"]=$cmd
        done
    }

    #######################################
    # Prompts the user for the name of the local taskfile
    # Globals:
    #   task_file_name
    #######################################
    function get_task_file_name() {
        echo -e "$DELIMITTER"
        DEFAULT_NAME="taskfile"
        read -e -r -p "Name of your tasks file: " -i ${DEFAULT_NAME} task_file_name
    }

    #######################################
    # Prompts the user for the name of the local taskfile
    # Globals:
    #   task_file_name
    #   commands
    #######################################
    function create_local_task_file() {
        filepath="./${task_file_name}"
        echo "Saving your directory configuration in ${filepath}."
        for i in ${!commands[*]}; do
            echo -e "$i ${commands[$i]}" >>"$filepath"
        done
    }

    #######################################
    # Appends the abbrs defined in this session
    # Globals:
    #   abbrs
    #   TASKS_CONFIG_PATH
    #######################################
    function create_global_abbrs_file() {
        filepath="${TASKS_CONFIG_PATH}/abbrs"
        echo "Saving your global abbrs in ${filepath}."
        for i in ${!abbrs[*]}; do
            echo -e "$i ${abbrs[$i]}" >>"$filepath"
        done
    }

    #######################################
    # Saves working directory and taskfile to tasks.sh config
    # Globals:
    #   task_file_name
    #   TASKS_CONFIG_PATH
    #######################################
    function create_global_tasks_file() {
        filepath="${TASKS_CONFIG_PATH}/taskfiles"
        echo "Adding your directory and taskfile to ${filepath}."
        echo -e "${PWD} ${task_file_name}" >>"$filepath"
    }

    # Formatting constants
    RESET="\033[0m"
    YELLOW="\033[1;33m"
    BLUE="\033[1;34m"
    DELIMITTER="\n=========================================\n"

    # Path constants
    TASKS_CONFIG_PATH="${HOME}/.config/tasks"

    # Initializing global variables
    tasks=()
    declare -A abbrs
    declare -A commands
    task_file_name=""

    echo_introduction

    # Get the data for the tasks
    get_tasks
    get_abbrs
    get_commands

    get_task_file_name

    echo -e "$DELIMITTER"

    # Save local configuration
    create_local_task_file

    # Create path if it doesn't exist
    [[ -d $TASKS_CONFIG_PATH ]] || mkdir -p "$TASKS_CONFIG_PATH"

    # Create the global files
    create_global_abbrs_file
    create_global_tasks_file

    echo -e "$RESET"
}
