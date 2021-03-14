#!/usr/bin/env bash

VERSION="0.1"

function usage {
    cat << HELP_USAGE
Usage: mbta.sh call [id] [<options>]
  
  POSITIONAL ARGUMENTS
  call             Required. Name of the specific call you wish to make.
  id               Optional. id of a specific element to use in the call.

  KEYWORD ARGUMENTS
  -h, --help       Print usage information
  -v, --version    Print version number
  --fields         Comma-separated list of fields to include in the response
  --include        Comma-separated list of relationships to include in the response
  --page-limit     Max number of elements to return 
  --page-offset    Offset (0-based) of first element in the page
  --sort           Results can be sorted by the id or any /data/{index}/attributes 
                   key. Assumes ascending; may be prefixed with '-' for descending.
  
  NOTES
  Assumes there is an environment variable named "MBTA_API_KEY", with a valid 
  MBTA V3 API key. Queries can be made without a valid key; however, keys are strongly 
  recommended. Keys are available for free at api-v3.mbta.com.
HELP_USAGE
}

function version {
    cat << HELP_VERSION
MBTA.sh, v${VERSION}
Created by Ken Goettler (goettlek@gmail.com)
HELP_VERSION
}

ALLOWED_CALLS=( \
    "alerts" \
    "facilities" \
    "lines" \
    "live_facilities" \
    "predictions" \
    "routes" \
    "route_patterns" \
    "schedules" \
    "services" \
    "shapes" \
    "stops" \
    "trips" \
    "vehicles" \
)
BASEURL="https://api-v3.mbta.com"
SEP="?"
URL="${BASEURL}"

# Help
if [[ "${1}" =~ ^(-h|--help) ]]; then
    usage
    exit 0
fi

# Version info
if [[ "${1}" =~ ^(-v|--version) ]]; then
    version
    exit 0
fi

# First positional argument must be name of the call
if [[ ! " ${ALLOWED_CALLS[@]} " =~ " ${1} " ]]; then
    echo "Error: ${1} is not a recognized call"
    exit 1
fi
CALL="${1}"
URL="${URL}/${1}"
shift 1

# Second (optional) positional argument may be an id
if [[ ! "${1}" =~ ^(-|--*) ]]; then
    URL="${URL}/${1}"
    shift 1
fi

# Keyword arguments
while (( "$#" )); do
    case "$1" in
        --filter)
            URL="${URL}${SEP}filter[${2}]=${3}"
            SEP="&"
            shift 3
            ;;
        --fields)
            URL="${URL}${SEP}fields[${CALL::-1}]=${2}"
            SEP="&"
            shift 2
            ;;
        --include)
            URL="${URL}${SEP}include=${2}"
            SEP="&"
            shift 2
            ;;
        --page-limit)
            URL="${URL}${SEP}page[limit]=${2}"
            SEP="&"
            shift 2
            ;;
        --page-offset)
            URL="${URL}${SEP}page[offset]=${2}"
            SEP="&"
            shift 2
            ;;
        --sort)
            URL="${URL}${SEP}sort=${2}"
            SEP="&"
            shift 2
            ;;
        -*|--*=)
            echo "Error: unsupported flag $1" >&2
            usage
            exit 1
            ;;
        *)
            echo "error: positional arguments must precede keyword arguments"
            usage
            exit 1
            ;;
    esac
done

# Perform query
res=$(curl -H "x-api-key: $MBTA_API_KEY" -s "$URL")
echo "$res" | jq .
