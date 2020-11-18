#!/usr/bin/env bash
#
# Put in a cron and enjoy your PC waking up every weekday at the specified time! 
# Does not overwrite alarms set in the future so that if the cron runs past midnight 
# it won't overwrite "today's" cron.
#
# Example:
# 10 * * * * /opt/scripts/weekday-rtc-wakeup.sh "09:00" >/dev/null
#

if [[ $(id -u) != 0 ]]; then
	echo "You need to run this with sudo power" >&2
	exit 1;
fi
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 {24_HOURS_TIME_FORMAT}" >&2
    exit 1;
fi

wake_alarm_file=/sys/class/rtc/rtc0/wakealarm

# Check if we already have an alarm scheduled
current_alarm=$(cat $wake_alarm_file 2>/dev/null)
current_time=$(date +%s)

if [[ ! -z $current_alarm && $current_alarm -gt $current_time ]]; then
	echo "An alarm is already set"
	exit 0;
fi

weekday=$(date +%u)
if [[ $weekday == 5 || $weekday == 6 ]]; then
	next_weekday="Monday"
else
	next_weekday="Tomorrow"
fi

# Only set the alarm (-m no) using localtime (-l)
/usr/sbin/rtcwake -m no -l -t $(date +%s -d "$next_weekday $1") >/dev/null
echo "Alarm set for $next_weekday $1"

exit 0;
