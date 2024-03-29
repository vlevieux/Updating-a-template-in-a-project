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

# Force a merge w/ the 'dev' branch
git checkout dev
git merge our_template --allow-unrelated-histories -X theirs

# Remove orphan branch & push 'dev' branch
git branch -D our_template
git push origin dev
