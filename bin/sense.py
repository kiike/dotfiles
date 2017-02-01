#!/usr/bin/env python
"""
sens.py: log and output sensor values
"""

import curses
import statistics
import time
import collections

import psutil
import sensors

DATE_FMT = "%Y-%m-%d %H:%M:%S"
QUIT_HINT = "Press 'q' to quit"
BLACKLIST = ("PCH_CHIP_CPU_MAX_TEMP", "PCH_CHIP_TEMP", "PCH_CPU_TEMP",
             "AUXTIN1", "AUXTIN2", "AUXTIN3", "intrusion1", "intrusion2",
             "fan1", "fan3", "fan5")

def init_history(chips):
    """
    Build a history tree that will collect all the measurements.
    """

    tree = {}
    for chip in chips:
        sensor_dict = {}
        for feature in chip:
            if feature.label in BLACKLIST:
                continue
            else:
                sensor_dict[feature.label] = []

        tree[str(chip)] = sensor_dict

    tree['CPU Usage'] = {}
    for cpu in range(psutil.cpu_count()):
        core_id = 'Core #{}'.format(cpu)
        tree['CPU Usage'][core_id] = []

    tree['CPU Frequency'] = {}
    for cpu in range(psutil.cpu_count()):
        core_id = 'Core #{}'.format(cpu)
        tree['CPU Frequency'][core_id] = []

    return tree


def update_history(history, chips):
    """
    Iterate through the chips and add the measurements to the history.
    """

    for chip in chips:
        for feature in chip:
            try:
                measurements = history[str(chip)][feature.label]
                measurements.append(feature.get_value())
            except KeyError:
                continue

    for i, usage in enumerate(psutil.cpu_percent(percpu=True)):
        core_id = 'Core #{}'.format(i)
        history['CPU Usage'][core_id].append(usage)

    for i, freq in enumerate(psutil.cpu_freq(percpu=True)):
        core_id = 'Core #{}'.format(i)
        history['CPU Frequency'][core_id].append(float(round(freq.current)))

    return history


def format_number(number):
    """
    Print numbers in a saner way.
    """
    if number.is_integer():
        fmt = '{:.0f}'.format(number)
    else:
        fmt = '{:.3f}'.format(number)

    return fmt


def init_screen(screen, colors):
    """
    Initializes the screen for future use
    """
    # Hide cursor
    curses.curs_set(0)

    # Prepare screen and disable key delay
    screen.clear()
    screen.nodelay(True)

    header = '{:<6} {:<6} {:<6} {:<6}'
    header = header.format('cur', 'min', 'max', 'avg')
    screen.addstr(0, 18, header, colors.white)


def init_colors():
    """
    Initialize colors pairs and return a colors namedtuple
    """

    # Make color pairs
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)
    curses.init_pair(3, curses.COLOR_RED, curses.COLOR_BLACK)
    curses.init_pair(4, curses.COLOR_GREEN, curses.COLOR_BLACK)
    curses.init_pair(5, curses.COLOR_WHITE, curses.COLOR_BLACK)

    colors = collections.namedtuple("colors",
                                    ["cyan", "yellow", "red", "green", "white"])
    colors.cyan = curses.color_pair(1)
    colors.green = curses.color_pair(2)
    colors.red = curses.color_pair(3)
    colors.yellow = curses.color_pair(4)
    colors.white = curses.color_pair(5)

    return colors


def print_footer(screen, colors):
    max_y, max_x = screen.getmaxyx()

    # Add a small footer
    screen.addstr(max_y-1, 0,
                  'sense.py',
                  colors.cyan + curses.A_BOLD)

    # Add the date centered on the bottom
    screen.addstr(max_y-1, 12, time.strftime(DATE_FMT),
                  colors.green + curses.A_BOLD)
    # And a hint to quit
    screen.addstr(max_y-1, max_x-len(QUIT_HINT)-1, QUIT_HINT)


def main(screen):
    """
    Initialize screen, sensors, history and display measurements on the screen.
    """

    colors = init_colors()
    init_screen(screen, colors)

    # Initialize the sensors and the history
    sensors.init()
    chips = [s for s in sensors.iter_detected_chips()]
    history = init_history(chips)

    while True:
        # Quit on 'q' or 'Q' keypress
        char = screen.getch()
        if char == ord('q') or char == ord('Q'):
            break

        line = 1
        history = update_history(history, chips)

        for chip in history:
            # Print sensor name
            screen.addstr(line, 0, str(chip), colors.cyan)

            features = history[chip]
            for i, feature in enumerate(features):
                line += 1
                # Whether this is the last measurement from the chip
                is_last = i + 1 == len(history[chip])

                # Print tree drawing char
                screen.addstr(line, 0,
                              '\u2514' if is_last else '\u251c',
                              colors.white)

                # Print feature name
                screen.addstr(line, 2, feature, colors.cyan + curses.A_BOLD)

                # Print sensor measurements
                measurements = history[chip][feature]
                fmt = '{:<6} {:<6} {:<6} {:<6.3f}'
                fmt = fmt.format(format_number(measurements[-1]),
                                 format_number(min(measurements)),
                                 format_number(max(measurements)),
                                 statistics.mean(measurements)
                                )
                screen.addstr(line, 18, fmt, colors.green)

            # Print a blank line
            line += 2

        print_footer(screen, colors)

        # Put it together and sleep
        screen.refresh()
        time.sleep(1)



if __name__ == "__main__":
    curses.wrapper(main)
