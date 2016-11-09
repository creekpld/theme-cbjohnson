
function fish_greeting -d "Greeting message on shell session start up"

    echo ""
    echo -en " " (welcome_message) "\n"
    echo -en "              \n"
    echo -en "    ⣿⣿⣿⣿⣿⣿   " (show_date_info) "\n"
    echo -en "    ⣿⣿       " (show_tipp) "\n"
    echo -en "    ⣿⣿⣿⣿⣿⣿   " (show_current_users) "\n"
    echo -en "    ⣿⣿       " (show_os_info) "\n"
    echo -en "    ⣿⣿⣿⣿⣿⣿   " (show_cpu_info) "\n"
    echo -en "             " (show_mem_info) "\n"
    echo -en "    E Corp   " (show_net_info) "\n"
    echo ""
    echo "Have a Nice Day"
end

function welcome_message -d "Say welcome to user"

    echo -en "Hello, "
    set_color FFF  # white
    echo -en (whoami)
    set_color normal
    echo " !"
end


function show_date_info -d "Prints information about date"

    #set --local up_time (uptime |sed 's/^ *//g' |cut -d " " -f4,5 |tr -d ",")
    set --local up_time   (uptime | cut -d ',' -f1 | cut -d 'p' -f2)

    echo -en "\tToday is "
    set_color cyan
    echo -en (date +%d.%m.%Y,)
    set_color normal
    echo -en " running for "
    set_color cyan
    echo -en "$up_time"
    set_color normal
    echo -en "."
end

function show_tipp -d "Prints a random Program and Description"

   set --local bin_count (ls $PATH 2> /dev/null | sort -ud | grep -v "/" | wc -l)
   set --local tipp "none"
   set --local line_number (math (random) \% $bin_count +1)
   set --local line (ls $PATH 2> /dev/null | sort -ud | grep -v "/" | head -n $line_number | tail -n -1)
   set --local tipp (whatis $line 2> /dev/null | tr -d '([0-9])' | tr -s ' ' | cut -c 1-80)

   while not test ( echo $tipp | grep -v 'nothing appropriate' );
      or not test ( echo $tipp | grep -ve '[,]' )

	    set line_number ( math (random) \% $bin_count +1 )
            set line (ls $PATH | sort -ud | grep -v "/" | head -n $line_number | tail -n -1)
            set tipp (whatis $line 2> /dev/null | tr -d '([0-9])' | tr -s ' ' | cut -c 1-80)
   end

   set_color yellow
   echo -en "\tApp tipp: "
   set_color 0F0  # green
   echo -en "$tipp"
   set_color normal

end

function show_current_users -d "Prints currently logged-in Users"

    set --local users (who | cut -d' ' -f1 | sort | uniq)

    set_color yellow
    echo -en "\tLogged-in Users: "
    set_color 0F0  # green
    echo -en "$users"
    set_color normal

end

function show_os_info -d "Prints operating system info"

    set_color yellow
    echo -en "\tOS: "
    set_color 0F0  # green
    echo -en (uname -smr)
    set_color normal
end


function show_cpu_info -d "Prints iformation about cpu"

    set --local os_type (uname -s)
    set --local cpu_info ""

    if [ "$os_type" = "Linux" ]

        set --local procs_n (grep -c "^processor" /proc/cpuinfo)
        set --local cores_n (grep "cpu cores" /proc/cpuinfo | head -1 | cut -d ":"  -f2 | tr -d " ")
        set --local cpu_type (grep "model name" /proc/cpuinfo | head -1 | cut -d ":" -f2)
        set cpu_info "$procs_n processors, $cores_n cores, $cpu_type"

    else if [ "$os_type" = "Darwin" ]

        set --local procs_n (system_profiler SPHardwareDataType | grep "Number of Processors" | cut -d ":" -f2 | tr -d " ")
        set --local cores_n (system_profiler SPHardwareDataType | grep "Cores" | cut -d ":" -f2 | tr -d " ")
        set --local cpu_type (system_profiler SPHardwareDataType | grep "Processor Name" | cut -d ":" -f2 | tr -d " ")
        set cpu_info "$procs_n processors, $cores_n cores, $cpu_type"
    end

    set_color yellow
    echo -en "\tCPU: "
    set_color 0F0  # green
    echo -en $cpu_info
    set_color normal
end


function show_mem_info -d "Prints memory information"

    set --local os_type (uname -s)
    set --local total_memory ""

    if [ "$os_type" = "Linux" ]
        set total_memory (free --si -h | grep "Mem" | cut -d " " -f 12)

	if [ $total_memory = "" ]
		set total_memory (free --si -h | grep "Mem" | cut -d " " -f 13)
	end
	if [ $total_memory = "" ]
		set total_memory (sed -n -e 's/^.*MemTotal: * //p' < /proc/meminfo)
	end

    else if [ "$os_type" = "Darwin" ]
        set total_memory (system_profiler SPHardwareDataType | grep "Memory:" | cut -d ":" -f 2 | tr -d " ")
    end

    set_color yellow
    echo -en "\tMemory: "
    set_color 0F0  # green
    echo -en $total_memory
    set_color normal
end


function show_net_info -d "Prints information about network"

    set --local os_type (uname -s)
    set --local ip ""
    set --local gw ""

    if [ "$os_type" = "Linux" ]
        set ip (ip addr show | grep -v "127.0.0.1" | grep "inet "| sed 's/^ *//g' | cut -d " " -f2)
        set gw (netstat -nr | grep UG | cut -d " " -f10)
    else if [ "$os_type" = "Darwin" ]
        set ip (ifconfig | grep -v "127.0.0.1" | grep "inet " | head -1 | cut -d " " -f2)
        set gw (netstat -nr | grep default | cut -d " " -f13)
    end

    set_color yellow
    echo -en "\tNet: "
    set_color 0F0  # green
    echo -en "Ip address $ip, default gateway $gw"
    set_color normal
end
