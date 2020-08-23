#!/bin/sh
pmset -g batt | grep -E -o "\d+%|\d+\:\d+" | grep -v 0:00 | paste -sd ' ' -
