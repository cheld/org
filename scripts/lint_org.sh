#!/bin/bash
cd "$(dirname "$0")"/..

echo "Linting org.yaml..."

CONFIG=${1:-org.yaml}   
APPROVED_MEMBERS=${2:-ospo-approvals/members.yaml} 
APPROVED_REPOS=${3:-ospo-approvals/repos.yaml} 

rm -Rf ospo-approvals
git clone -q https://github.com/cheld/ospo-approvals.git


# Check if all public repositories have been approved by OSPO
num_of_public_repos=`yq -o json '.orgs.*.repos | with_entries(select(.value.private=="false")) | keys | length - 1' <$CONFIG`
for i in `seq 0 $num_of_public_repos`; do
    repo_name=`yq -o json ".orgs.*.repos | with_entries(select(.value.private==false)) | keys | .[ $i ]" <$CONFIG`
    repo_already_approved=`yq -o json ".*.[] | select(. == $repo_name)" <$APPROVED_REPOS`

    if [ -z "$repo_already_approved" ]; then
        echo "Error: Repository $repo_name is not approved yet. Create a PR in github/allianz/ospo-approvals first."
        exit 1
    fi
done

#Check if all members have been approved by OSPO
number_of_org_members=`yq -o json '.orgs.*.teams | [ .[].maintainers.[] ] | unique | length - 1' <$CONFIG ` 
for i in `seq 0 $number_of_org_members`; do
    member_name=`yq -o json ".orgs.*.teams | [ .[].maintainers.[] ] | unique | .[$i]" <$CONFIG `
    member_already_approved=`yq -o json ". | with_entries (select(.key == $member_name))" <$APPROVED_MEMBERS`

    if [ "$member_already_approved" == "" ] || [ "$member_already_approved" == "{}" ] ; then
        echo "Error: Email of member $member_name is not validated yet. Create a PR in github.com/allianz/ospo-approvals first."
        exit 1
    fi
done
