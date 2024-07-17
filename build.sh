#! /usr/bin/env bash
set -uvx
set -e
cd "$(dirname "$0")"
cwd=`pwd`
ts=`date "+%Y.%m%d.%H%M.%S"`
version="${ts}"

sed -i -e "s/<Version>.*<\/Version>/<Version>${version}<\/Version>/g" version.xml

tag="Files-v$version"
cd $cwd
git add .
git commit -m"$tag"
git tag -a "$tag" -m"$tag"
git push origin "$tag"
git push
git remote -v
git log | head -n 1
