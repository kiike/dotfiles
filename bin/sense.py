#!/usr/bin/env python
"""
sens.py: log and output sensor values
"""

import statistics
import time
import threading

import psutil
import sensors
import urwid

DATE_FMT = "%Y-%m-%d %H:%M:%S"
QUIT_HINT = "Press 'q' to quit"
BLACKLIST = ("PCH_CHIP_CPU_MAX_TEMP", "PCH_CHIP_TEMP", "PCH_CPU_TEMP",
             "AUXTIN1", "AUXTIN2", "AUXTIN3", "intrusion1", "intrusion2",
             "fan1", "fan3", "fan5")

def init_history(chips):
    """
    Build a history tree that will collect all the measurements.
    """

    # Adapted from lm-sensors source code
    sensor_units = ['', ' RPM', ' °C', '', '', '', '', ' V', ' ', '', '']

    tree = {}
    for chip in chips:
        sensor_dict = {}
        for feature in chip:
            if feature.label in BLACKLIST:
                continue
            else:
                unit = sensor_units[feature.type]
                sensor_dict[feature.label] = {}
                sensor_dict[feature.label]['info'] = {'unit': unit}
                sensor_dict[feature.label]['measurements'] = []

        tree[str(chip)] = sensor_dict

    tree['CPU Usage'] = {}
    for cpu in range(psutil.cpu_count()):
        core_id = 'Core #{}'.format(cpu)
        tree['CPU Usage'][core_id] = {}
        tree['CPU Usage'][core_id]['info'] = {'unit': '%'}
        tree['CPU Usage'][core_id]['measurements'] = []

    tree['CPU Frequency'] = {}
    for cpu in range(psutil.cpu_count()):
        core_id = 'Core #{}'.format(cpu)
        tree['CPU Frequency'][core_id] = {}
        tree['CPU Frequency'][core_id]['info'] = {'unit': ' MHz'}
        tree['CPU Frequency'][core_id]['measurements'] = []

    return tree


def update_history(history, chips):
    """
    Iterate through the chips and add the measurements to the history.
    """

    for chip in chips:
        for feature in chip:
            try:
                measurements = history[str(chip)][feature.label]['measurements']
                measurements.append(feature.get_value())
            except KeyError:
                continue

    for i, usage in enumerate(psutil.cpu_percent(percpu=True)):
        core_id = 'Core #{}'.format(i)
        destination = history['CPU Usage'][core_id]['measurements']
        destination.append(usage)

    for i, freq in enumerate(psutil.cpu_freq(percpu=True)):
        core_id = 'Core #{}'.format(i)
        destination = history['CPU Frequency'][core_id]['measurements']
        destination.append(float(round(freq.current)))

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


def add_header():
    header = '{:<6} {:<6} {:<6} {:<6}'
    header = header.format('cur', 'min', 'max', 'avg')
    return header


def add_footer():
    footer = "{:<16} {:<16} {:>16}"
    footer = footer.format('sense.py',
                           time.strftime(DATE_FMT),
                           QUIT_HINT)

    return footer

def get_output(history):
    """
    Make a list of strings out of sensor data.
    """

    out = []

    for chip in history:
        # Print sensor name
        out.append(str(chip))

        features = history[chip]
        for i, feature in enumerate(features):
            # If this is the last element, print a different symbol
            is_last = i + 1 == len(history[chip])
            symbol = '\u2514' if is_last else '\u251c'

            # Print sensor measurements
            measurements = history[chip][feature]['measurements']
            unit = history[chip][feature]['info']['unit']
            data_fmt = '{:>6}{} {:>6}{} {:>6}{} {:>6.3f}{}'
            data = data_fmt.format(format_number(measurements[-1]), unit,
                                   format_number(min(measurements)), unit,
                                   format_number(max(measurements)), unit,
                                   statistics.mean(measurements), unit)
            line = "{} {} {}".format(symbol, feature, data)
            out.append(line)

        out.append("")

    return out

def updater(loop, body, chips, history):
    """ Loop that updates the content window. """
    while True:
        history = update_history(history, chips)
        output = get_output(history)
        body.set_text("\n".join(output))
        loop.draw_screen()
        time.sleep(1)

def key_handler(key):
    """ Handle keys such as Q for quit, etc."""
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()

def main():
    """
    Initialize screen, sensors, history and display measurements on the screen.
    """

    # Initialize the sensors and the history
    sensors.init()
    chips = [s for s in sensors.iter_detected_chips()]
    history = init_history(chips)

    body = urwid.Text("")
    fill = urwid.Filler(body, "top")
    loop = urwid.MainLoop(fill, unhandled_input=key_handler)

    updater_thread = threading.Thread(target=updater,
                                      args=(loop, body, chips, history))

    updater_thread.start()
    loop.run()


if __name__ == "__main__":
    main()
