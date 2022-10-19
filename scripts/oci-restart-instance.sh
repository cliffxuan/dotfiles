#!/usr/bin/env bash
get_instance() {
  instance_name=${1}
  compartment_id=$(oci iam compartment list | jq -r '.data | .[0] | ."compartment-id"')
  read -r -d '' query <<EOF
.data
| .[]
| select(."display-name" | contains("${instance_name}"))
| {id: .id, name: ."display-name", region: .region, status: ."lifecycle-state"}
EOF
  instance_details=$(oci compute instance list --all --compartment-id "$compartment_id" | jq -r "$query")
  echo "$instance_details"
}

restart_instance() {
  instance_details=${1:?"no instance details specified"}
  echo "instance_details=$instance_details"
  id=$(echo "$instance_details" | jq -r '.id')
  read -r -p "Are you sure? [Y/n]" response
  response=${response,,} # tolower
  if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
    echo "oci compute instance action --instance-id $id --action reset"
    oci compute instance action --instance-id "$id" --action reset >/dev/null 2>&1
  fi
}


name=${1:?"no instance name specified"}
restart_instance "$(get_instance "$name")"
get_instance "$name"
