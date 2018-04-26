# Exit if any subcommand fails.
set -e

echo "Starting deploy"

# Build the docs page locally
mkdocs build --clean

# Bots need names too
git config --global user.email "circleci@sipgate.de"
git config --global user.name "sipgate CircleCI bot"

# Copy the generated website to the temporary directory
cp -R "site/" "/tmp/site"

git clean -f -d

# Check out gh-pages and clear all files
git reset --hard HEAD
git checkout gh-pages
rm -rf *

# Copy the finished HTML page to the current directory
cp -R /tmp/site/* .

# We need a CNAME file for GitHub
# echo "developer.sipgate.com" > "CNAME"

# Commit all the changes and push it to the remote
git add -A
git commit -m "Deployed with $(mkdocs --version)"
git push origin gh-pages

echo "Deployed successfully."
echo "If you're running this on your local machine, please make sure to reset your git user credentials (username and email) to not be the fastlane-bot-helper"

exit 0
