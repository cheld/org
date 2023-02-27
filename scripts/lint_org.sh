#!/bin/bash
cd "$(dirname "$0")"

CONFIG=../config/org.yaml
APPROVED_REPOS=../config/approved-repos.yaml
APPROVED_MEMBERS=../config/validated-members.yaml

# Check if all public repositories have been approved by OSPO
num_of_public_repos=`yq -o json '.orgs.*.repos | with_entries(select(.value.private=="false")) | keys | length - 1' <$CONFIG`
for i in `seq 0 $num_of_public_repos`; do
    repo_name=`yq -o json ".orgs.*.repos | with_entries(select(.value.private==false)) | keys | .[ $i ]" <$CONFIG`
    repo_already_approved=`yq -o json ".[] | select(. == $repo_name)" <$APPROVED_REPOS`

    if [ -z "$repo_already_approved" ]; then
        echo "Error: Repository $repo_name is not approved yet. Add $repo_name to the file $APPROVED_REPOS and create a pull request to trigger the review process."
        exit 1
    fi
done

#Check if all members have been approved by OSPO
number_of_org_members=`yq -o json '.orgs.*.teams | [ .[].maintainers.[] ] | unique | length - 1' <$CONFIG ` 
for i in `seq 0 $number_of_org_members`; do
    member_name=`yq -o json ".orgs.*.teams | [ .[].maintainers.[] ] | unique | .[$i]" <$CONFIG `
    member_already_approved=`yq -o json ". | with_entries (select(.key == $member_name))" <$APPROVED_MEMBERS`

    if [ "$member_already_approved" == "{}" ]; then
        echo "Error: Email of member $member_name is not validated yet. Add $member_name to the file $APPROVED_MEMBERS and create a pull request to trigger the validation process."
        exit 1
    fi
done
