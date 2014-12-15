#!/bin/bash

CODE=$(zenity --entry --text "Bitte geben Sie den 16-stelligen Code ein:" --title "Stick aufladen")

QUERY='*100#'
KEYWORD="Serviceantwort"

if test -n "$CODE"; then
	LEN=$(echo -n "$CODE"|wc -m)

	if test $LEN -ne 16; then
		# TODO FEHLER
		zenity --error --text "Fehler: Der Code muss genau 16 Ziffern haben." 
		exit 1
	fi

	QUERY="*104*$CODE#"
	KEYWORD="Serviceantwort"
fi

SUMMARY=$(gammu -c ~/.gammurc-ussd-100 getussd "$QUERY"| grep "$KEYWORD" | cut -f2 -d '"')

# notify-send -t 10 "$SUMMARY"

if test -z "$SUMMARY"; then
	SUMMARY="Ein unerwarteter Fehler trat auf (Ergebnis war leer)."
fi

zenity --info --text "$SUMMARY" --title "Ergebnis"
