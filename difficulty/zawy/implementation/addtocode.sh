#!/bin/sh
# Copyright (c) 2019 HashToBeWild
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

# Read the parameter giving the base path
BasePath=$1

# Variables
DestinationFile=""
MarkerLineText=""
SearchParameters=""

# Add to configure.ac
KeyPhrase="wdifficultyzawy"
DestinationFile=$BasePath'/configure.ac'

# Only do this, if the file does not contain the KeyPhrase
if [ -z $(grep "$KeyPhrase" "$DestinationFile") ]; then 
    FragmentFile='./fragments/configure.ac.001'
    MarkerLineText='AC_LANG_PUSH'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert before the marker
    sed -n -i -e "$SearchParameters" -e 1x -e '2,${x;p}' -e '${x;p}' $DestinationFile 

    FragmentFile='./fragments/configure.ac.002'
    MarkerLineText='Options used to compile and link'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert after the marker
    sed -i -e "$SearchParameters" $DestinationFile
else
    echo "Skipping $DestinationFile"
fi

# Add to Makefile
KeyPhrase="USE_DIFFICULTY_ZAWY"
DestinationFile=$BasePath'/src/Makefile.am'

# Only do this, if the file does not contain the KeyPhrase
if [ -z $(grep "$KeyPhrase" "$DestinationFile") ]; then 
    FragmentFile='./fragments/Makefile.am.001'
    MarkerLineText='obj\/build\.h\:\ FORCE'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert before the marker
    sed -n -i -e "$SearchParameters" -e 1x -e '2,${x;p}' -e '${x;p}' $DestinationFile 

    FragmentFile='./fragments/Makefile.am.002'
    MarkerLineText='\#\ wallet\:\ shared\ between'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert before the marker
    sed -n -i -e "$SearchParameters" -e 1x -e '2,${x;p}' -e '${x;p}' $DestinationFile 
else
    echo "Skipping $DestinationFile"
fi

# Add to Code 
KeyPhrase="USE_DIFFICULTY_ZAWY"
DestinationFile=$BasePath'/src/pow.cpp'

# Only do this, if the file does not contain the KeyPhrase
if [ -z $(grep "$KeyPhrase" "$DestinationFile") ]; then 
    FragmentFile='./fragments/pow.cpp.001'
    MarkerLineText='\pow\.h'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert after the marker
    sed -i -e "$SearchParameters" $DestinationFile

    FragmentFile='./fragments/pow.cpp.002'
    MarkerLineText='GetNextWorkRequired'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert before the marker
    sed -n -i -e "$SearchParameters" -e 1x -e '2,${x;p}' -e '${x;p}' $DestinationFile 

    FragmentFile='./fragments/pow.cpp.003'
    MarkerLineText='unsigned\ int\ CalculateNextWorkRequired'
    SearchParameters='/'$MarkerLineText'/r '$FragmentFile
    # Insert before the marker
    sed -n -i -e "$SearchParameters" -e 1x -e '2,${x;p}' -e '${x;p}' $DestinationFile 
else
    echo "Skipping $DestinationFile"
fi
