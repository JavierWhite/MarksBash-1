#!/bin/bash

# ************************************************************UNCLASSIFIED************************************************************
#  Company: Northrop Grumman 
#  Date   : July 16, 2021
#  By     : Tim Kan M61636 for SWDC OPIR
#  Purpose: Cleaning up hpp files. Making it look neat without having to go and chang line by line
#  Instruction: ./test.sh <Inputfile> <Outputfile> 
#               the user will need to specify input file and their desire output file.
#               desired output can be a .txt or .cpp etc...
#  Check4Runtime: time <scriptName>.sh <Inputfile> <Outputfile2> use this command in linux as of rn it's total runtime is 1m48.887s
# ************************************************************UNCLASSIFIED************************************************************

i='/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*----------------------------- DESCRIPTION ----------------------------*/
/*----------------------------------------------------------------------*/'
touch $2
echo -e "$i \n" > $2

j='/*----------------------------------------------------------------------*/
/*------------------------------ INCLUDES ------------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$j \n" >> $2
grep -i "#include" $1 >> $2

k='/*----------------------------------------------------------------------*/
/*------------------------ FORWARD DECLARATIONS ------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$k \n" >> $2

l='/*----------------------------------------------------------------------*/
/*------------------------------- USINGS -------------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$l \n" >> $2
x=$(grep -i "::" $1| awk '{print $2}'|head -1| sed 's/::/ /g'| cut -d " " -f 1-4 )

for file in $x
do 
    echo "namespace $file {" >> $2
done


g='/*----------------------------------------------------------------------*/
/*-------------------------- GLOBAL VARIABLES --------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$g \n" >> $2

c='/*----------------------------------------------------------------------*/
/*----------------------- CONSTRUCTOR/DESTRUCTOR -----------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$c \n" >> $2 
x=$(grep -i "::" $1| awk '{print $2}'|head -1| sed 's/::/ /g'| cut -d " " -f 5)
x=$(echo "$1" |cut -d ' ' -f 1| cut -d "." -f 1)
xx=$(grep -i "ImaginaryClass" $1| grep -i "*"| cut -d "(" -f 2  |sed 's/;/ :/g')
echo -e "$x::$x ($xx \n{ " >> $2
y=$(grep -i "::" $1| head -1| awk '{print $5}' | sed 's~::~ ~g' | awk '{print $5}')
echo "  $y()," >> $2
yy=$(grep -i "bool" $1 | grep -v "(" | grep -v "]" | sed 's~    ~//~g' | sed 's~ ~\n~g'| sed -e 's~^~  ~g'  | sed 's~;~~g')
echo "$yy(false)," >> $2
gg=$(grep -i "char" $1 | head -1 |grep -v "(" | grep -v "]" | sed 's~    ~//~g' | sed 's~ ~\n~g' | sed -e 's~^~  ~g' |sed 's~;~~g')
echo "$gg('\0')," >> $2
unsig=$(grep -i "unsigned" $1| head -1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g')
rest=$(grep -i "unsigned" $1| grep -v ']'| sed 's~    ~//~g'| cut -d " " -f 3| sed -e 's~^~  ~g' | sed 's~;~~g' |tail -n+2)
echo -e "$unsig(0)," >> $2
for file in $rest
do 
    echo "  $file(0)," >> $2
done 
short=$(grep -i 'short' $1| head -1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$short(0)," >> $2

int=$(grep -i 'int' $1| grep -v ')\|*\|//'| grep -i 'volatile'|  sed 's~    ~//~g'|cut -d ' ' -f 2-3| sed -e 's~^~//~g'  | sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$int(0)," >> $2

echo "  //long" >> $2
rest2=$(grep -i 'long' $1| sed 's~    ~//~g'| cut -d " " -f 2| sed -e 's~^~  ~g' | sed 's~;~~g' |tail -n+2)
for n in $rest2
do
    echo "  $n(0)," >> $2
done

float=$(grep -i 'float' $1| head -1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$float(0.0)," >> $2

dub=$(grep -i 'double' $1| grep -v '(\|*'| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$dub(0.0)," >> $2

string=$(grep -i '::string' $1| grep -v "("| head -1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$string('')," >> $2

ref=$(grep -i "reference" $1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g')
echo "$ref(0)," >> $2

pter=$(grep -i 'pointer' $1| grep -v "("| head -1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$pter(NULL)," >> $2

obj=$(grep -i 'object' $1| grep -v "("| head -1| sed 's~    ~//~g'| sed 's~ ~\n~g'| sed -e 's~^~  ~g' | sed 's~;~~g' )
echo "$obj()," >> $2

arr=$(grep -i ']' $1| grep -i 'bool'| sed 's~    ~//~g'|sed 's~ ~\n~g'|tr -d '[0-9]'| sed -e 's~^~  ~g'| sed 's~;~~g')
echo -e "$arr({false}),">> $2

char=$(grep -i ']' $1| grep -i 'char'| sed 's~    ~//~g'|sed 's~ ~\n~g'|tr -d '[0-9]'| sed -e 's~^~  ~g' | sed 's~;~~g')
echo "$char({'\0'}),">> $2

short=$(grep -i ']' $1| grep -i 'short'| sed 's~    ~//~g'|sed 's~ ~\n~g'|tr -d '[0-9]'| sed -e 's~^~  ~g' | sed 's~;~~g')
echo -e "$short({0}),">> $2

unArr=$(grep -i ']' $1| grep -i 'unsigned'| sed 's~    ~//~g'|sed 's~ ~\n~g' |tr -d '[0-9]'| sed -e 's~^~  ~g' | sed 's~;~~g') 
echo -e "$unArr({0}),">> $2

echo -e "\n\n}" >> $2
ff='/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/'
x=$(echo "$1" |cut -d ' ' -f 1| cut -d "." -f 1)
point=$(grep -i "pointer" $1| sed 's~    ~//~g'| cut -d ' ' -f 2| head -1| sed 's~;~~g')
echo -e "$ff" >> $2
echo "$x::~$x ()" >> $2
echo -e "{ \n  if (NULL != $point) {delete $point;} \n  $point = NULL; \n }" >> $2


f='/*----------------------------------------------------------------------*/
/*------------------------------ FUNCTIONS -----------------------------*/
/*----------------------------------------------------------------------*/'

ff='/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/'


echo -e "$f \n" >> $2
x1=$(grep -i "bool" $1| grep -i "const" |grep -i "(" | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1| sed 's~;~ \n{ \n\n}~g')   
y=$(grep -i "bool" $1| grep -i "const" |grep -i "(" | sed -e 's/^[ \t]*//' | cut -d ' ' -f 2-10| sed 's~;~ \n{ \n\n}~g')

echo "$x1 $x::$y" >> $2
echo -e "$ff" >> $2

x1=$(grep -i "double" $1| grep -i "const" |grep -i "(" | sed -e 's/^[ \t]*//' | head -1|cut -d ' ' -f 1)
x2=$(grep -i "double" $1| grep -i "const" |grep -i "(" | sed -e 's/^[ \t]*//' | head -1|cut -d ' ' -f 2-10| sed 's~;~ \n{ \n\n}~g')

echo "$x1 $x::$x2" >> $2
echo -e "$ff" >> $2

x1=$(grep -i "const" $1| grep -i "objectname" |grep -v "bool" | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1-2)
x2=$(grep -i "const" $1| grep -i "objectname" |grep -v "bool" | sed -e 's/^[ \t]*//' | cut -d ' ' -f 3-10|sed 's~;~ \n{ \n\n}~g')

echo "$x1 $x::$x2" >> $2
echo -e "$ff" >> $2

x1=$(grep -i "const" $1| grep -i "double" |grep -v "int" | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1-2)
x2=$(grep -i "const" $1| grep -i "double" |grep -v "int" | sed -e 's/^[ \t]*//' | cut -d ' ' -f 3-10|sed 's~;~ \n{ \n\n}~g')

echo "$x1 $x::$x2" >> $2
echo -e "$ff" >> $2

echo "// More function can be added here and so on" >> $2

o='/*----------------------------------------------------------------------*/
/*------------------------------ OPERATORS -----------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$o \n" >> $2
echo "//this part will handle the operators just we are just leaving it for now" >> $2

t='/*----------------------------------------------------------------------*/
/*------------------------------ TEMPLATES -----------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$t \n" >> $2
echo "//this part will handle the Templates however we are just leavin it for now" >> $2
c='/*----------------------------------------------------------------------*/
/*------------------------- CLOSING NAMESPACES -------------------------*/
/*----------------------------------------------------------------------*/'

echo -e "$c \n" >> $2

s1=$(grep -i "::" $1| awk '{print $2}'|head -1| sed 's/::/ /g'| cut -d " " -f 1-4)

a1=($(echo $s1|fold -w1 ))
for (( i=${#a1[@]}-1;i>=0;i--));do echo "} //end of namespace ${a1[i]} " >> $2 ; done



ii='/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/'
echo -e "$ii \n" >> $2