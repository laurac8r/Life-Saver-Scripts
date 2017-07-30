#/!bin/bash

export nuissance_phrase='ExN03'

for f in *.hh
  do mv "$f" "${f#$nuissance_phrase}"
done
