config_dir="$HOME/.config/tasks";

declare -A taskfile_per_dir;

function add-abbr()
{
    abbr=$1;
    task=$2;
    echo "adding abbreviation $abbr -> $task";
    alias $abbr="tasks-do-task $task";
}

function add-taskfile()
{
    dir=$1;
    taskfile=$2;
    echo "adding taskfile $taskfile in $dir";
    taskfile_per_dir["$dir"]="$taskfile";
}

while true;
do
    read abbr task;
    status=$?;
    add-abbr "$abbr" "$task" > /dev/null;
    if (($status)); then break; fi
done < "$config_dir/abbrs";

while true;
do
    read dir taskfile;
    status=$?;
    add-taskfile "$dir" "$taskfile" > /dev/null;
    if (($status)); then break; fi
done < "$config_dir/taskfiles";
