# prerequisite : PROJECT_DIR is defined

# -------------------------------- NEW MCU --------------------------------
# New MCU related alias
setEnvVariableIfNotSet NEW_MCU_ROOT_DIR $PROJECT_DIR/mcu-libwebrtc

LIBWEBRTC_ROOT_DIR=$NEW_MCU_ROOT_DIR/libwebrtc/src
LIBWEBRTC_BUILD_DIR=$NEW_MCU_ROOT_DIR/libwebrtc/src/out/Default
MCU_BINARY_NAME=MCU
alias cdnn='cd $NEW_MCU_ROOT_DIR'
alias cdn='cd $LIBWEBRTC_ROOT_DIR/SymToTemasysCode'
alias cdl='cd $LIBWEBRTC_ROOT_DIR'
alias cdo='cd $LIBWEBRTC_BUILD_DIR'

function runMcu
{
  local currentDir=`pwd`
  cdo
  if (( $# != 0 )) then
    ./$1
  else
    ./$MCU_BINARY_NAME
  fi
  cd $currentDir
}
alias testMcu='runMcu MCU_TEST'

# Build MCU
function bm
{
  if (( $# != 0 )) then
    ninja -C $LIBWEBRTC_BUILD_DIR $1
  else
    ninja -C $LIBWEBRTC_BUILD_DIR $MCU_BINARY_NAME
  fi
  # Check the output status and print message according to it
  if (( $? != 0 )) then
    echo "** BUILD FAILED **"
  else
    echo "** BUILD SUCCEEDED **"
  fi
}
alias bt='bm MCU_TEST'
alias btt='bm MCU_TEST_CLIENTS'


function cleanBuildMcu
{
  cdnn
  ./init.sh --patch-only
  bm
}

# grep in webrtc excluding some directories (excluding test directories also)
function wgrep 
{
    cdl
    grep --recursive --ignore-case --exclude-dir={out,third_party,sdk,tools,buildtools,build,examples} --exclude={tags,\*test\*,\*mock\*,\*android\*,\*fake\*,\*legacy\*} "$1" .
}

# grep in webrtc excluding some directories (but not excluding test directories)
function tgrep 
{
    cdl
    grep --recursive --ignore-case --exclude-dir={out,third_party,sdk} --exclude={tags,\*android\*,\*legacy\*} "$1" .
}

function startMcuDeps
{
  pm2 start redis-server -- --save "900 1" --dir "/var"
  startSkylink # Depends on skylink.zshrc
  startSignalling # Depends on sig.zshrc
}

# Clean MCU logs, recordings, core
function cm
{
  rm -r $LIBWEBRTC_BUILD_DIR/Recordings/*
  rm $LIBWEBRTC_BUILD_DIR/core
  rm  $LIBWEBRTC_BUILD_DIR/Logs/*
}

function generateCtags
{
  cdl

  # Having any argument means to exclude test directories
  if (( $# != 0 )) then
    ctags --links=yes -R --exclude="*.java" --exclude="*.js" --exclude="**node_modules*" --exclude="third_party" --exclude="**test*" --exclude="**Test*" api/* audio/* base/* call/* common_audio/* common_video/* data/* examples/* infra/* logging/* media/* modules/* ortc/* p2p/* pc/* rtc_base/* rtc_tools/* sdk/* stats/* system_wrappers/* voice_engine/* video/* SymToTemasysCode/*
  else
    ctags --links=yes -R --exclude="*.java" --exclude="*.js" --exclude="**node_modules*" --exclude="third_party" --exclude="**test*" api/* audio/* base/* call/* common_audio/* common_video/* data/* examples/* infra/* logging/* media/* modules/* ortc/* p2p/* pc/* rtc_base/* rtc_tools/* sdk/* stats/* system_wrappers/* voice_engine/* video/* SymToTemasysCode/*
  fi
}

export LD_LIBRARY_PATH=$LIBWEBRTC_BUILD_DIR:$LD_LIBRARY_PATH
# -------------------------------- END - NEW MCU --------------------------------

# -------------------------------- OLD MCU --------------------------------
# Some variables to be used later in this file
MCU_ROOT_DIR=$PROJECT_DIR/temasys-sfu-mcu

alias mcuzshrc='vim $PROJECT_DIR/configs/Temasys/mcu.zshrc'
alias cdm='cd $MCU_ROOT_DIR'
alias cdlicode='cd $MCU_ROOT_DIR/licode/erizo/src/erizo'
alias cdr='cd $PROJECT_DIR/recording'
alias rmm='rm $MCU_ROOT_DIR/logs/erizo-cores/*.log;rm $MCU_ROOT_DIR/logs/*.log*';
alias lsLastLicodeLog='ls -t $MCU_ROOT_DIR/logs/erizo-cores/*.log | head -1'
alias licodelog='vim `lsLastLicodeLog`'
alias mculog='vim $MCU_ROOT_DIR/logs/skylink-mcu-node.log'
alias tailmculog='tail -F $LIBWEBRTC_BUILD_DIR/Logs/FullLog_0'
alias cdlicodelog='cd $MCU_ROOT_DIR/logs/erizo-cores/'
alias vimex='vim $MCU_ROOT_DIR/licode/erizo/src/erizo/media/ExternalOutput.cpp'
alias vimmcu='vim $MCU_ROOT_DIR/app/sfu/MCU.js'
alias bl='cdm; ./licodeCompile.sh; rmm; pm2 restart mcu;'

# tail licode log. If no arguments given, last modified log will be tailed
function taillicode
{
    if (( $# != 0 )) then
        tail -f *$1*
    else
        tail -f `lsLastLicodeLog`
    fi
}

function gdblicode
{
    # first find the processID of licode thread
    local erizoProcessName=''
    if (( $# != 0 )) then
        erizoProcessName=$1
    else
        # Finding the erizo process name if not provided
        if [[ `lsLastLicodeLog` =~ sky-(.*)\.log$ ]]; then
            erizoProcessName=${match[1]}
        fi
    fi
    echo "Finding PID of erizo process: $erizoProcessName"
    local erizoPID=`ps aux | grep $erizoProcessName | grep node | awk '{print $2}'`
    echo "Found PID: $erizoPID, starting gdb..."
    sudo gdb -x ~/gdbconf attach $erizoPID
}

# -------------------------------- END - OLD MCU --------------------------------
