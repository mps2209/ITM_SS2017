#!/bin/bash

# ---------------------------------------------------------------------------------------------------------
#	Set input params
# ---------------------------------------------------------------------------------------------------------

video="$1"
audio="$2"
output="$3"

# ---------------------------------------------------------------------------------------------------------
#	ANT
# ---------------------------------------------------------------------------------------------------------

function ant {
    # You need local admin rights to do this
    chmod +x ./ant.sh
    chmod +x tools/ant/apache-ant-1.10.0/bin/ant

    ./ant.sh clean
    ./ant.sh compile
    ./ant.sh VideoMetadataGenerator 	-Dinput=$video 	-Doutput=$output
    ./ant.sh VideoFrameGrabber 		    -Dinput=$video 	-Doutput=$output
    ./ant.sh VideoThumbnailGenerator 	-Dinput=$video 	-Doutput=$output	-Dtimespan=0
    ./ant.sh VideoThumbnailGenerator 	-Dinput=$video 	-Doutput=$output 	-Dtimespan=5
    ./ant.sh AudioThumbGenerator 	    -Dinput=$audio 	-Doutput=$output 	-Dlength=10
    ./ant.sh AudioMetadataGenerator 	-Dinput=$audio	-Doutput=$output
    ./ant.sh AudioPlayer                -Dinput=$audio/error.wav
    
    end
}

# ---------------------------------------------------------------------------------------------------------
#	Try to create output folder
# ---------------------------------------------------------------------------------------------------------

function createoutputfolder {
    if [ -z "$output" ]; 
        then output="out"
    fi
    mkdir -p $output
}

# ---------------------------------------------------------------------------------------------------------
#	ERR
# ---------------------------------------------------------------------------------------------------------

# filenotfound
function directorynotfound {
    echo "Input Folder does not exists"
    exit
}

# wrongparam
function wrongparam {
    echo "One or more parameter are missing"
    echo "Example usage: cmd media\video media\audio output"
    exit
}

# ---------------------------------------------------------------------------------------------------------
#	END
# ---------------------------------------------------------------------------------------------------------

# end
function end {
    exit
}

# ---------------------------------------------------------------------------------------------------------
#	Check input
# ---------------------------------------------------------------------------------------------------------

if [ -z "$video" ]; 
    then wrongparam
fi

if [ -z "$audio" ]; 
    then wrongparam
fi

if [ -z "$output" ];
    then createoutputfolder
fi

if [ ! -d $video ]; 
    then directorynotfound
fi

if [ ! -d $audio ]; 
    then directorynotfound
fi

if [ ! -d $output ]; 
    then createoutputfolder
fi

if [ ! -d $video ] && [ ! -d $audio ] && [ ! -d $output ];
    then end
else
    ant
fi