#!/bin/bash

#Script to classificate the files between identify and unidentify. To use correctlly change the Working_directory with 
#the path of the new release. ¡¡¡CHANGE PATH DIRECTORY IN EACH RELEASE!!! You can find the parts that need to be changed 
# more easily by looking for the symbol (**)

#This part classifies the files in: Identified and unidentified.
#Set working directory (**)
WORKING_DIRECTORY=`pwd`/

#Create a working directory (**)
mkdir -p $WORKING_DIRECTORY/archive_unidentified_2014-12
mkdir -p $WORKING_DIRECTORY/archive_identified_2014-12
mkdir -p $WORKING_DIRECTORY/cache_temp
mkdir -p $WORKING_DIRECTORY/cache



#Go over the different files and split the data. 
echo Working on files...

for i in $(ls *.mgf ); do
    echo $i

    awk '/^BEGIN IONS/{n++;w=1} n&&w{print > "./cache_temp/out" n ".txt"} /^END IONS/{w=0}' $i

done



# Go over the different files.
echo Working on files...

for path_to_hb_file in $(ls cache_temp/*.txt ); do
    echo $path_to_hb_file

    if grep -q 'SEQ=' $path_to_hb_file; then
        mv $path_to_hb_file $WORKING_DIRECTORY/archive_identified_2014-12
    else
        mv $path_to_hb_file $WORKING_DIRECTORY/archive_unidentified_2014-12
    fi
done


#This part takes information from the different files. 

#Set working directory(**)
WORKING_DIRECTORY=`pwd`/cache


# Go over the different files.(**)
echo Working on files...


for path_to_hb_file in $( ls archive_identified_2014-12/*.txt ); do
    echo $path_to_hb_file
    grep 'SEQ' $path_to_hb_file | cut -d "=" -f2- | tr ',' '\n' >> $WORKING_DIRECTORY/sequences_ide.txt
    grep 'TAXONOMY' $path_to_hb_file | cut -d "=" -f2- | tr ',' '\n' >> $WORKING_DIRECTORY/taxonomy_ide.txt
    grep 'USER' $path_to_hb_file | cut -d "=" -f2- >> $WORKING_DIRECTORY/modifications_ide.txt
    grep 'TITLE' $path_to_hb_file | sed 's/^.*\(spectrum.*\)/\1/g' | cut -d "=" -f2-  >> $WORKING_DIRECTORY/spectrum_ide.txt

done

for path_to_hb_file in $( ls archive_unidentified_2014-12/*.txt ); do
    echo $path_to_hb_file
    grep 'SEQ' $path_to_hb_file | cut -d "=" -f2- | tr ',' '\n' >> $WORKING_DIRECTORY/sequences_unide.txt
    grep 'TAXONOMY' $path_to_hb_file | cut -d "=" -f2- | tr ',' '\n' >> $WORKING_DIRECTORY/taxonomy_unide.txt
    grep 'USER' $path_to_hb_file | cut -d "=" -f2- >> $WORKING_DIRECTORY/modifications_unide.txt
    grep 'TITLE' $path_to_hb_file | sed 's/^.*\(spectrum.*\)/\1/g' | cut -d "=" -f2-  >> $WORKING_DIRECTORY/spectrum_unide.txt

done