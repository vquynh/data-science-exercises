"""
This python programs turns a Raspberry Pi into an theremin with the help of distance sensors
A theremin is an electronic musical instrument controlled without physical contact by the thereminist (performer).
The distance from the hand to the sensor determine the frequency (pitch).
Higher notes are played by moving the hand closer to the sensor.
According to the distance measured by the sensor, the frequency of the note is calculated
"""
# The library RPi.GPIO is used to control GPIO interface on the Raspberry Pi,
# so that the signals from the sensors connected to the GPIO pins can be read
import RPi.GPIO as GPIO
# The library pygame.midi is used to play the calculated note as midi sound
import pygame
import pygame.midi
import time
import statistics
global midi_output

# SET THE NUMBER OF THE GPIO PINS
# For the distance sensor, there is a trigger pin and an echo pin
# The trigger pin will send an ultrasonic pulse
# When the ultrasound reaches an object (the thereminist's hand), it will be reflected
# The echo pin will then receive this signal

GPIO_TRIGGER = 23
GPIO_ECHO = 24


# Prepare the program by setting the trigger pin to be the output and the echo pin to be the input
# The output is first set to false and the program sleeps for 0.1s
# so that it doesn't start right away and the ultrasonic sensor has time to get ready
def prepare(gpio_trigger_pin, gpio_echo_pin):
    GPIO.setup(gpio_trigger_pin, GPIO.OUT)
    GPIO.setup(gpio_echo_pin, GPIO.IN)
    GPIO.output(gpio_trigger_pin, False)
    time.sleep(0.1)


# Calculate the distance between the sensor and the closest object (the hand)
def get_distance(gpio_trigger, gpio_echo):
    stop_time = 0
    start_time = 0
    # trigger the sensor by setting output to True
    GPIO.output(gpio_trigger, True)
    # wait for 1 nanosecond because that's the time the sensor needs to trigger the signal
    time.sleep(0.00001)
    # set the output back to "False" to stop the trigger
    GPIO.output(gpio_trigger, False)
    # run a loop to check if the gpio_echo pin received any signal, if input == 0
    # that means there is no signal received yet so continuously set the current timestamp as start time
    while GPIO.input(gpio_echo) == 0:
        start_time = time.time()
    # the moment the signal reached gpio_echo, the input == 1 and the timestamp will be set as stop time
    # until the signal is gone
    while GPIO.input(gpio_echo) == 1:
        stop_time = time.time()
    # elapsed is the time between when the signal was triggered and when it echoed back to the sensor
    elapsed = stop_time - start_time
    # distance is calculated by multiply the travel time with the ultrasonic sound's speed
    # divide to 2 because the sound travel to the object and echo back to the sensor
    distance = (elapsed * 34300) / 2
    return int(distance)


# Calculate the note based on the distance
def get_note(dist):
    # set the minimum distance to be 5cm where the pitch is the highest
    min_dist = 5
    # set the maximum distance to be 70cm where the pitch is the lowest
    max_dist = 70
    # number of octaves
    # an octave is the interval between one musical pitch and another with double its frequency
    octaves = 1
    # the lowest note is set to midi note 68 which is equivalent to G#4/Ab4
    min_note = 68
    # the highest note is set to midi note 68 + 12 = 80 which is equivalent to G#5/Ab5
    max_note = min_note + 12 * octaves

    # if the distance is bigger than the max distance
    if dist > max_dist:
        # then the note is the lowest
        relative_note = min_note
    # if the distance is smaller than the min distance
    elif dist < min_dist:
        # then the note is the highest
        relative_note = max_note
    # otherwise, the note is calculated proportional to the distance
    else:
        note_to_distance_ratio = (max_note - min_note) / (max_dist - min_dist)
        relative_distance = dist - min_dist
        relative_note = min_note + relative_distance*note_to_distance_ratio
    return int(relative_note)


# base configuration for the midi sound
def conf_midi():
    # set the instrument to ocarina
    instrument = 79
    # set device id to id of the speaker connected to raspberry pi
    device_id = 2
    latency = 0
    buffer_size = 512
    midi_output = pygame.midi.Output(device_id, latency, buffer_size)
    midi_output.set_instrument(instrument)


def play_midi(new_note, old_note):
    if new_note != old_note:
        # switch off the old note with velocity 0 so the note fades out slowly
        midi_output.note_off(old_note, 0)
        # play the new note with velocity 127 so the note starts quickly
        # this combination seems to create the best transition of one note to the other
        midi_output.note_on(new_note, 127)


def update_list(list_of_distance, new_distance):
    list_of_distance.pop(0)
    list_of_distance.append(new_distance)
    return list_of_distance


pygame.init()
pygame.midi.init()

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

prepare(GPIO_TRIGGER, GPIO_ECHO)
conf_midi()

# set distance list to store the last 5 distances measured by the sensor
distance_list = [0, 0, 0, 0, 0]

# set first note
note = 0

try:
    while True:
        # set previous not to current note
        previous_note = note
        # get new distance from the sensor
        new_dist = get_distance(GPIO_TRIGGER, GPIO_ECHO)
        # update the distance list
        distance_list = update_list(distance_list, new_dist)
        # get the median distance value of the list
        # use the median distance instead of the latest distance to calculate the note
        # to avoid distance changing to abruptly and the note sounding too artificial
        median_dist = statistics.median(distance_list)
        note = get_note(median_dist)
        play_midi(note, previous_note)
        # play the calculated note for 0.1 second before calculating the next note
        time.sleep(0.1)

except KeyboardInterrupt:
    GPIO.cleanup()
    del midi_output
    pygame.midi.quit()
GPIO.cleanup()
