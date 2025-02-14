#!/usr/bin/env python3

import signal
import subprocess
import sys
import dbus
from time import sleep


def sig_handler(signal, frame):
    sys.exit(0)


signal.signal(signal.SIGINT, sig_handler)

# Spotify MPRIS Control
session_bus = dbus.SessionBus()
spotify = session_bus.get_object(
    "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2"
)
player_iface = dbus.Interface(spotify, "org.mpris.MediaPlayer2.Player")
props_iface = dbus.Interface(spotify, "org.freedesktop.DBus.Properties")

spotify_was_paused_by_script = False


def get_active_players():
    """Use playerctl to get a list of active players."""
    try:
        result = subprocess.run(
            ["playerctl", "-l"], stdout=subprocess.PIPE, text=True, check=True
        )
        players = result.stdout.strip().split("\n")
        return players
    except subprocess.CalledProcessError as e:
        print(f"Error running playerctl: {e}")
        return []


def is_player_playing(player_name):
    """Check if a specific player is in the 'Playing' state."""
    try:
        result = subprocess.run(
            ["playerctl", "-p", player_name, "status"],
            stdout=subprocess.PIPE,
            text=True,
            check=True,
        )
        return result.stdout.strip() == "Playing"
    except subprocess.CalledProcessError:
        return False


while True:
    try:
        spotify_status = props_iface.Get(
            "org.mpris.MediaPlayer2.Player", "PlaybackStatus"
        )
        active_players = get_active_players()

        # Debugging output
        # print("Active players:", active_players)
        # print("Spotify playback status:", spotify_status)

        # Check if any non-Spotify player is playing
        other_playing_players = [
            player
            for player in active_players
            if player != "spotify" and is_player_playing(player)
        ]

        if other_playing_players:
            if spotify_status == "Playing":
                # print("Pausing Spotify because another program is playing audio...")
                player_iface.Pause()
                spotify_was_paused_by_script = True
        else:
            if spotify_status == "Paused" and spotify_was_paused_by_script:
                # print( "Resuming Spotify playback because no other program is playing audio...")
                player_iface.Play()
                spotify_was_paused_by_script = False

    except Exception as e:
        print(f"Error: {e}")

    sleep(0)  # Check every second
