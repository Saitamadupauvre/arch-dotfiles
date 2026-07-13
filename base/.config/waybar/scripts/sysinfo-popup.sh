#!/bin/bash
cpu=$(top -bn1 | awk -F'[ ,]+' '/Cpu\(s\)/{print 100-$8"%"}')
mem=$(free -h --si | awk '/Mem:/{print $3" / "$2" ("int($3/$2*100)"%)"}')
top5=$(ps -eo comm,%cpu --sort=-%cpu | head -6 | tail -5)

rofi -e "  CPU  ${cpu}
  RAM  ${mem}

Top processes:
${top5}" \
    -theme ~/.config/rofi/calm-blue.rasi \
    -theme-str 'window {width: 320px; anchor: north east; x-offset: -12px; y-offset: 40px;} listview {lines: 0;}'
