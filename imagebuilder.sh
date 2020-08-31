#!/bin/bash

###### U S A G E : Help and ERROR ######
function _usage() 
{
  cat <<EOF

   imagebuilder $options
  $*
          Usage: imagebuilder <[options]>
          Options:
                  -r   --repo arg       Required.  Set repo name
                  -t   --tag  arg       Set tag
                  -d   --dev  arg       dev registry
                  -p   --pub  arg       published registry
                  -c   --clean-build    don't build with cache (will be set for pub)
                  -h   --help           Show this message
EOF
}

function addopt() {
  if ! [[ "$build_opts" =~ "$1" ]]; then
    echo "hodor: $1"
    build_opts="$build_opts $1"
  fi
}

SHORT=hd:p:r:t:c
LONG=help,dev:,pub:,repo:,tag:,clean-build


# read the options
OPTS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")
if [ $? != 0 ] ; then echo "Failed to parse options...exiting." >&2 ; _usage; exit 2 ; fi
eval set -- "$OPTS"


# set initial values
tag="dev"
publish=false
dev_registry=""
pub_registry=""
repo=""
build_opts=""

# extract options and their arguments into variables.
while true ; do
  case "$1" in
    -d | --dev )
      dev_registry="$2/"
      shift 2
      ;;
    -p | --pub )
      pub_registry="$2/"
      addopt "--no-cache"
      publish=true
      shift 2
      ;;
    -r | --repo )
      repo="$2"
      shift 2
      ;;
    -t | --tag )
      tag="$2"
      shift 2
      ;;
    -c | --clean-build )
      addopt "--no-cache"
      shift 1
      ;;
    -h | --help )
      _usage
      exit 0
      ;;
    -- )
      shift
      break
      ;;
    *)
      echo "Internal error!"
      _usage
      exit 1
      ;;
  esac
done

if [[ "$repo" == "" ]]; then
  echo "define repo with --repo reponane"
  _usage
  exit 3
fi


# Do local dev tag and push for testing
docker build -t ${repo}:${tag} -f Dockerfiles/Dockerfile.dev $build_opts .  && 

if [[ $dev_registry != "" ]]
then
  docker tag ${repo}:${tag} ${dev_registry}${repo}:${tag}
  docker push ${dev_registry}${repo}:${tag} 
fi

if [[ $pub_registry != "" ]]
then
  docker tag ${repo}:${tag} ${pub_registry}${repo}:${tag}
  docker push ${pub_registry}${repo}:${tag} 
  echo "Don't forget to 'git tag -a -m \"<release version>\""
fi
