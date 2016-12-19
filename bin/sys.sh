#!/bin/sh
# Prints temperature and battery charge (if present) on Linux, FreeBSD
# and OpenBSD.

OS=$(uname -s)

case $OS in
    Linux)
        temp_path="/sys/class/thermal/thermal_zone0"
        if [ -d ${temp_path} ]; then
            temp="$(< ${temp_path}/temp)"
            cpu_temp=${temp::-3}
        fi

        batt_path="/sys/class/power_supply/BAT0/"
        if test -d ${batt_path}; then
            max_charge="$(< ${batt_path}/energy_full)"
            cur_charge="$(< ${batt_path}/energy_now)"
        fi
        ;;

    FreeBSD)
        cpu_temp=$(sysctl -a dev.cpu.0.temperature | cut -d ' ' -f 2 | cut -d '.' -f 1)
        ;;

    OpenBSD)
        cmd="sysctl -n hw.sensors.acpibat0"
        max_charge="$(${cmd}.watthour0 | cut -d. -f1)"
        cur_charge="$(${cmd}.watthour3 | cut -d. -f1)"
        ;;
esac

if ! test -z ${cpu_temp+x}; then
    echo -n "CPU: ${cpu_temp}ºC | "
fi

if ! test -z ${max_charge+x} && ! test -z ${cur_charge+x}; then
    bat=$(echo "100 * $cur_charge / $max_charge" | bc)
    echo -n "BAT: ${bat}% | "
fi

# Print date
date '+%a %d %b, %H:%M'
