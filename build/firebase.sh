#!/bin/sh

# run the original firebase
if [ $FIREBASE_TOKEN ]; then
  exec firebase "$@" --token $FIREBASE_TOKEN
else
  exec firebase "$@"
fi
