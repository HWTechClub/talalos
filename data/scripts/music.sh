#!/bin/sh

amixer -D pulse sset Master 100%
ffplay -nodisp -loop 0 /scripts/bg.mp3
