#!/bin/bash
#
# create summarys of your computations 
#
# version history:
#
# version 0.1: (19.01.2018) 
# Tizian Müller: 
# - basic stuff with gaussian .out-Files
# script is not fully tested. Use at your own risk
# please report any bugs and suggestions via mail or during cigarette breaks
#

# difine variables
VERSION="0.1"
USERNAME=`whoami`

function prnt_error {
echo -e "\033[0;31m ERROR ! stopping script \033[0m "
}

function prnt_warning {
echo -e "\033[1;33m WARNING ! \033[0m "
}

function prnt_ok {
echo -e -n "\033[0;32m OK: \033[0m "
}


## here schould be some sort of check for arguments


echo "give me something"



# show welcome message
echo "summary version $VERSION  "
echo "i think this testing is over soon"


LIST=`find -name "*.out"`
LISTARR=($LIST)

echo "found ${#LISTARR[@]} .out files"



######################################################
#            Functions 

function find_methode { # gives the used Method
RAW=`grep -m 1 "GINC-" $name | sed -e 's.\\\. .g'`
METH=` echo $RAW | awk '{print $5}'`
BASIS=`echo $RAW | awk '{print $6}'`
}

function find_energ { 
ENERG_EL=`tac $name | grep -m 1 "SCF Done:  " | awk '{print $5}'`
}

function find_ther_corr { # finds the themal corrections for electronic Energy
 ZPVE=`grep "Zero-point correction=" $name | awk '{print $3}'`
 RAW=`grep -A 8 "Zero-point correction=" $name| awk 'NF>1{print $NF}'`
 RAWARRAY=($RAW)
 
 ENERG_THERM=${RAWARRAY[1]}
 ENTHALPY=${RAWARRAY[2]}
 GIBBS=${RAWARRAY[3]}

#ZPVE=`grep "Zero-point correction=" $name | awk '{print $3}'`
#ENERG=`grep "Thermal correction to Energy=" $name | awk '{print $5}'`
#ENTHALPY=`grep "Thermal correction to Enthalpy= " $name | awk '{print $5}'`
#GIBBS=`grep "Thermal correction to Gibbs Free Energy= " $name | awk '{print $7}'`
}


function find_Nimag {
if  [ -z `grep -i -m 1 "imaginary frequencies (negative Signs" $name | awk '{print $2}'` ]
then IMAG="0"
else IMAG="`grep -i -m 1 "imaginary frequencies (negative Signs" $name | awk '{print $2}'`"
fi
}

function find_NTerm {
 NTHERM=`grep -c "Normal termination of Gaussian" $name`
}

function find_version {
RAW=`grep -m 1 -A 2 "Cite this work as:" $name`
PROG=`echo $RAW | awk '{print $5 $6}' | sed 's/,//g'`
REV=`echo $RAW | awk '{print $8}' | sed 's/,//g'`
}


######################################################
echo "name METH BASIS ENERG ZPVE ENERG ENTHALPY GIBBS"

for name in "${LISTARR[@]}" ; do

find_methode
find_energ
find_ther_corr
find_Nimag
find_NTerm
find_version


echo "$name $METH $BASIS $ENERG_EL $ZPVE $ENERG_THERM $ENTHALPY $GIBBS $IMAG $NTHERM $PROG $REV"

done

######################################################











