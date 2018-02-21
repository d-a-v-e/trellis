#!/bin/bash
shopt -s nullglob

ENVIRONMENTS=( hosts/* )
ENVIRONMENTS=( "${ENVIRONMENTS[@]##*/}" )

show_usage() {
  echo "Usage: media <action> <environment> <site name>

<action> is the direction, "push" or "pull" of media
<environment> is the environment to push/pull to ("staging", "production", etc)
<site name> is the WordPress site to deploy (name defined in "wordpress_sites")

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  media push staging example.com
  media pull production example.com
"
}

[[ $# -lt 2 ]] && { show_usage; exit 0; }

for arg
do
  [[ $arg = -h ]] && { show_usage; exit 0; }
done
MODE="$1"; shift
ENV="$1"; shift
SITE="$1"; shift
DEPLOY_CMD="ansible-playbook media_push_pull.yml -e site=$SITE  -e mode=$MODE -i hosts/$ENV"
HOSTS_FILE="hosts/$ENV"

if [[ ! -e $HOSTS_FILE ]]; then
  echo "Error: $ENV is not a valid environment ($HOSTS_FILE does not exist)."
  echo
  echo "Available environments:"
  ( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )
  exit 0
fi

$DEPLOY_CMD
