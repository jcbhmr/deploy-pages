#!/bin/bash
set -e
[[ $RUNNER_DEBUG != 1 ]] || set -x

protocol=$(echo "$GITHUB_SERVER_URL" | cut -d/ -f3)
host=$(echo "$GITHUB_SERVER_URL" | cut -d/ -f3)
git clone "$scheme//x:$INPUT_TOKEN@$host/$GITHUB_REPOSITORY.git" \
  "$RUNNER_TEMP/gh-pages" --depth 1 --branch gh-pages

pushd "$RUNNER_TEMP/gh-pages"

if [[ $INPUT_PREVIEW == true ]]; then
  rsync -av --delete --exclude=.git --exclude=.github "$PAGESDATA" "./preview-$GITHUB_RUN_ID/"
else
  rsync -av --delete --exclude=.git --exclude=.github --exclude='preview-*' "$PAGESDATA" "./"
fi
rm -rf "$PAGESDATA"

touch .nojekyll

git add --all --force
git config --local author.name "github-actions[bot]"
git config --local author.email "github-actions[bot]@github.com"
git commit --allow-empty --message "Deploy pages"
git push origin gh-pages

find . -name 'preview-*' -ctime +90 -exec rm -rf {} \;
git add --all --force
git commit --allow-empty --message "Remove old previews"
git push origin gh-pages

popd
rm -rf "$RUNNER_TEMP/gh-pages"

repository_name=$(echo "$GITHUB_REPOSITORY" | cut -d/ -f2)
if [[ $repository_name == $REPOSITORY_OWNER.github.io ]]; then
  if [[ $INPUT_PREVIEW == true ]]; then
    echo "page_url=http://$REPOSITORY_OWNER.github.io/preview-$GITHUB_RUN_ID/"
  else
    echo "page_url=http://$REPOSITORY_OWNER.github.io/"
  fi
else
  if [[ $INPUT_PREVIEW == true ]]; then
    echo "page_url=http://$REPOSITORY_OWNER.github.io/$repository_name/preview-$GITHUB_RUN_ID/"
  else
    echo "page_url=http://$REPOSITORY_OWNER.github.io/$repository_name/"
  fi
fi
