#!/bin/sh

DIR=$(dirname "$0")

if [[ $(git status -s) ]];then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/
git branch -D gh-pages

echo "Checking out gh-pages branch into public"
git worktree add -fB gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"
echo "Pushing the changes..."
git push --force