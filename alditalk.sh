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

tmp=$(mktemp)
gammu -c ~/.gammurc getussd "$QUERY" >$tmp 2>/dev/null &

while true; do
        x=$(cat $tmp|wc -l)
        if test "$x" -gt 0; then
                break
        fi
        sleep 1
done

SUMMARY=$(cat $tmp | grep "$KEYWORD" | cut -f2 -d '"')

kill -3 $(jobs -p)

rm $tmp

if test -z "$SUMMARY"; then
	SUMMARY="Ein unerwarteter Fehler trat auf (Ergebnis war leer)."
fi

zenity --info --text "$SUMMARY" --title "Ergebnis"
