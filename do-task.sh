function tasks-do-task()
{
    current_working_directory="$(pwd)";
    echo $current_working_directory;
    task="$1";
    echo $task;
    taskfile=${taskfile_per_dir["$current_working_directory"]};
    [[ -n $taskfile ]] || { echo "This directory doesn't have an associated taskfile"; return 255; };
    while true;
    do
	read read_task read_command;
	read_status=$?;
	if [[ "$read_task" == "$task" ]];
	then
	    eval "$read_command";
	fi
	if (($read_status)); then break; fi
    done < "$taskfile";
}
