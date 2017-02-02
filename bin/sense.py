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
             "AUXTIN1", "AUXTIN2", "AUXTIN3", "intrusion0", "intrusion1", "intrusion2",
             "fan3", "fan5", "beep_enable")

PALETTE = (('bg', 'default', 'default'),
           ('symbol', 'dark gray', 'default'),
           ('chip', 'dark cyan', 'default'),
           ('title', 'light green', 'default'),
           ('date', 'yellow', 'default'),
           ('quit_hint', 'dark gray', 'default'),
           ('sensor', 'light cyan', 'default'))

def init_history(chips):
    """
    Build a history tree that will collect all the measurements.
    """

    # Adapted from lm-sensors source code
    sensor_units = [' V', ' RPM', ' °C', '', '', '', '', ' V', ' ', '', '', '', '', '']
    sensor_types = ['in', 'fan', 'temp', 'power', 'energy', 'current',
                    'humidity', 'max_main', 'vid', 'intrusion', 'max_other',
                    'beep_enable', 'max', 'unknown']

    tree = {}
    for chip in chips:
        sensor_dict = {}
        for feature in chip:
            if feature.label in BLACKLIST:
                continue
            else:
                try:
                    unit = sensor_units[feature.type]
                    sensor_type = sensor_types[feature.type]
                except IndexError:
                    unit = " ???"
                    sensor_type = " ???"

                sensor_dict[feature.label] = {}
                sensor_dict[feature.label]['info'] = {'unit': unit, 'type': sensor_type}
                sensor_dict[feature.label]['measurements'] = []

        tree[str(chip)] = sensor_dict

    tree['CPU Usage'] = {}
    for cpu in range(psutil.cpu_count()):
        core_id = 'Core #{}'.format(cpu)
        tree['CPU Usage'][core_id] = {}
        tree['CPU Usage'][core_id]['info'] = {'unit': ' %', 'type': 'usage'}
        tree['CPU Usage'][core_id]['measurements'] = []

    tree['CPU Frequency'] = {}
    for cpu in range(psutil.cpu_count()):
        core_id = 'Core #{}'.format(cpu)
        tree['CPU Frequency'][core_id] = {}
        tree['CPU Frequency'][core_id]['info'] = {'unit': ' MHz', 'type': 'freq'}
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


def update_footer():
    title = urwid.AttrMap(urwid.Text('sense.py', align='left'), 'title')
    date = urwid.AttrMap(urwid.Text(time.strftime(DATE_FMT), align='center'), 'date')
    quit_hint = urwid.AttrMap(urwid.Text(QUIT_HINT, align='right'), 'quit_hint')
    return urwid.Columns((title, date, quit_hint))

def format_field(number, unit, s_type):
    """
    Make an urwid text out of a number and unit suitable for putting into columns.
    """

    if s_type in ('fan', 'freq', 'usage', 'temp'):
        field = '{:>7d}{:<3}'.format(round(number), unit)
    else:
        field = '{:>7.3f}{:<3}'.format(number, unit)

    return urwid.Text(field)


def get_output(history):
    """
    Make a list of strings out of sensor data.
    """

    out = []

    for chip in history:
        # Print sensor name
        out.append(urwid.AttrMap(urwid.Text(str(chip)), 'chip'))

        features = history[chip]
        for i, feature in enumerate(features):
            # If this is the last element, print a different symbol
            is_last = i + 1 == len(history[chip])
            symbol = '\u2514' if is_last else '\u251c'

            # Print sensor measurements
            measurements = history[chip][feature]['measurements']
            unit = history[chip][feature]['info']['unit']
            s_type = history[chip][feature]['info']['type']

            f_cur = format_field(measurements[-1], unit, s_type)
            f_min = format_field(min(measurements), unit, s_type)
            f_max = format_field(max(measurements), unit, s_type)
            f_avg = format_field(statistics.mean(measurements), unit, s_type)

            data_fields = urwid.Columns((f_cur, f_min, f_max, f_avg))

            line = urwid.Columns(((2, urwid.AttrMap(urwid.Text(symbol), 'symbol')),
                                  (16, urwid.AttrMap(urwid.Text(feature), 'sensor')),
                                  data_fields))
            out.append(line)

        # Show an empty line between sensors
        out.append(urwid.Text(''))

    return urwid.SimpleListWalker([w for w in out])

def update_frame(frame, loop, listwalker, chips, history):
    """ Loop that replaces the frame listwalker in-place. """
    while True:
        history = update_history(history, chips)
        listwalker[:] = get_output(history)
        frame.footer = update_footer()
        loop.draw_screen()
        time.sleep(1)

def key_handler(key):
    """ Handle keys such as q and Q for quit, etc."""
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()

def main():
    """
    Initialize screen, sensors, history and display measurements on the screen.
    """

    commands = urwid.CommandMap().copy()
    commands['j'] = 'cursor down'
    commands['k'] = 'cursor up'
    urwid.CommandMap = commands

    # Initialize the sensors and the history
    sensors.init()
    chips = [s for s in sensors.iter_detected_chips()]
    history = init_history(chips)
    history = update_history(history, chips)

    listwalker = get_output(history)
    body = urwid.ListBox(listwalker)

    header = (urwid.Text(w, align='center') for w in ('cur', 'min', 'max', 'avg'))
    header = urwid.Columns(((2, urwid.Text("")),
                            (16, urwid.Text("")),
                            urwid.Columns(header)))

    footer = update_footer()
    frame = urwid.Frame(body, header=header)



    loop = urwid.MainLoop(frame, unhandled_input=key_handler, palette=PALETTE)

    frame_updater = threading.Thread(target=update_frame,
                                     args=(frame, loop, listwalker,
                                           chips, history))

    frame_updater.start()
    loop.run()


if __name__ == "__main__":
    main()
