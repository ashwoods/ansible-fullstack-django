#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.
# set -u  # "unbound" Exit if uninitialised variable is accessed

# ARGUMENTS
# the target machine
HOST=
# user on HOST machine
REMOTE_USER=
# git repo url
GIT_REPO_URL=
# python project name
PROJECT_NAME=
GIT_VERSION="master"

VERBOSE_OPTION=""
UPDATE_OPTION=""

function show_help {
    echo "USAGE: deploy.sh HOST USER --git GIT_URL --name PROJECTNAME"
    echo "                 [--ref REF(=master)] [--update] [--verbose]"
    echo ""

    echo "  HOST: target remote host"
    echo "  USER: user on remote host responsible for deployment"
    echo "  --git GIT_URL: url to git repo of project source code"
    echo "  --name PROJECTNAME: python project name"
    echo ""

    echo "  OPTIONS:"
    echo "    --ref REF(=master): Git ref to use for deployment."
    echo "                        Defaults to 'master'"
    echo "    --update: Adds '--tags=\"update\"' to ansible-playbook cmd"
    echo "    --verbose: Makes ansible deployment more verbose."
}

# parse required positional [host] argument
if [ -z "$1" ]
then
    printf "ERROR: No '[host]' given! \n\n" >&2
    show_help
    exit 1
fi

# print help message if needed
case $1 in
    -h|-\?|--help)
        show_help
        exit
        ;;
esac

# get host
HOST=$1
# shift arguments by one ($1 is discarded and $2 is new $1)
shift

# get remote user
if [ -z "$1" ]
then
    printf "ERROR: No '[user]' given! \n\n" >&2
    show_help
    exit 1
fi

REMOTE_USER=$1
# shift arguments by one ($1 is discarded and $2 is new $1)
shift

# parse arguments
while :; do
    case $1 in
        # get git repo
        --git)
            if [ ${2:0:1} == \- ]; then
                printf "ERROR: '--git' requires a non-empty option argument.\n\n" >&2
                show_help
                exit 1
            fi
            GIT_REPO_URL=$2
            shift
            ;;
        --git=?*)
            GIT_REPO_URL=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --git=)         # Handle the case of an empty --git=
            printf "ERROR: '--git' requires a non-empty option argument.\n\n" >&2
            show_help
            exit 1
            ;;
        # get project name
        --name)
            if [ ${2:0:1} == \- ]; then
                printf "ERROR: '--name' requires a non-empty option argument.\n\n" >&2
                show_help
                exit 1
            fi
            PROJECT_NAME=$2
            shift
            ;;
        --name=?*)
            PROJECT_NAME=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --name=)         # Handle the case of an empty --name=
            printf "ERROR: '--name' requires a non-empty option argument.\n\n" >&2
            show_help
            exit 1
            ;;
        # get project name
        --ref)
            if [ ${2:0:1} == \- ]; then
                printf "ERROR: '--ref' requires a non-empty option argument.\n\n" >&2
                show_help
                exit 1
            fi
            GIT_VERSION=$2
            shift
            ;;
        --ref=?*)
            GIT_VERSION=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --ref=)         # Handle the case of an empty --ref=
            printf "ERROR: '--ref' requires a non-empty option argument.\n\n" >&2
            show_help
            exit 1
            ;;
        # get optional params
        -v|--verbose)
            VERBOSE_OPTION="-v"
            ;;
        -u|--update)
            UPDATE_OPTION="--tags='update'"
            ;;
        --) # End of all options.
            shift
            break
            ;;
        -?*)
            printf "WARN: Unknown option (ignored): %s\n\n" "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac
    # shift to next argument
    shift
done

# check if required non-positional arguments have been given
if [ -z "$GIT_REPO_URL" ]
then
    printf "ERROR: Required parameter '--git GIT_URL' is missing! \n\n" >&2
    show_help
    exit 1
fi

# check if required non-positional arguments have been given
if [ -z "$PROJECT_NAME" ]
then
    printf "ERROR: Required parameter '--name PROJECTNAME' is missing! \n\n" >&2
    show_help
    exit 1
fi

ansible-playbook -c paramiko -u $REMOTE_USER -i "$HOST," \
   --extra-vars "PROJECT_URL=$GIT_REPO_URL PROJECT_NAME=$PROJECT_NAME REMOTE_USER=$REMOTE_USER GIT_VERSION=$GIT_VERSION" \
   provisioning/site.yml ${VERBOSE_OPTION} ${UPDATE_OPTION}

#echo "ansible-playbook -c paramiko -u $REMOTE_USER -i \"$HOST,\" --extra-vars \"PROJECT_URL=$GIT_REPO_URL PROJECT_NAME=$PROJECT_NAME REMOTE_USER=$REMOTE_USER GIT_VERSION=$GIT_VERSION\" provisioning/site.yml ${VERBOSE_OPTION} ${UPDATE_OPTION}"
