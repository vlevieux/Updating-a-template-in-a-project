# Updating-a-template-in-a-project
Small script to update a template in a project based on this template.

# Description

One day, I came across the following problem:

I had several projects based on the same template. Most files are independent between the template and the project except for a few files that come from the template and serve as default files that will be modified later. I needed projects to use the latest version of the template.

It was therefore a question of updating the template on which a project is based.

[update-template.sh](https://github.com/vlevieux/Updating-a-template-in-a-project/blob/master/update-template.sh)
```shell
# Template repository
SSH_TEMPLATE_REPOSITORY="git@example.com:path/to/our/template.git"

# Add the remote repository template
if ! git config remote.our_template.url > /dev/null; then git remote add our_template $SSH_TEMPLATE_REPOSITORY; fi

# Retrieve files & tags
git fetch our_template
git fetch --tags our_template

# Retrieve the lastest tag (X.X.X)
LATEST_TAG_OF_OUR_TEMPLATE=$(git ls-remote --tags $SSH_TEMPLATE_REPOSITORY | tail -n1 | sed 's/.*\///; s/\^{}//')

# Retrieve the commit associated to this tag
COMMIT_LATEST_TAG=$(git rev-list --remotes=remotes/flask_app_template -n 1 $LATEST_TAG_OF_OUR_TEMPLATE)

# Create an orphan branch from the above commit
git checkout --orphan our_template $COMMIT_LATEST_TAG

# Commit files
git add *
git commit -m "Updated with the version $LATEST_TAG_FLASK_APP_TEMPLATE"

# Force a merge
git checkout dev
git merge our_template --allow-unrelated-histories -X theirs

# Remove branch & push
git branch -D our_template
git push origin dev

```

### Note:
*In this case, I chose that the template is the priority and will replace the file if there is a conflict. It is possible to edit that depending on the need.*

## Sources:
* The idea comes from [this answer](https://stackoverflow.com/questions/5572772/how-can-i-use-git-for-projects-templates/5574931#5574931) on StackOverflow
* As well as [this one](https://stackoverflow.com/a/51761312/9515831) to retrieve the last tag
* The commits are supposed to be [unique](https://stackoverflow.com/a/34764586/9515831)
