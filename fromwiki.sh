#!/bin/sh

# Config git
git config pull.rebase false

git pull

rm -Rf work

git submodule update --init submodules/wiki-content/

git submodule foreach git pull origin main

mkdir -p work
cp -a themes work/themes
for i in ar en es fr ko
do
echo $i
cp -a submodules/wiki-content/$i work/$i 
# Fix for varying defaults
mv work/$i/home.md work/$i/index.md
find work/$i -name "*.md" -exec sed -i 's/\/home.md/\/index.md/g' {} ';'
# Don't use div
find work/$i -name "*.md" -exec sed -i 's|<div|<span|' {} ';'
find work/$i -name "*.md" -exec sed -i 's|</div|</span|' {} ';'
done
cp -a wiki/un work/un
for i in images documents videos
do
echo $i 
cp -a submodules/wiki-content/$i work/themes/gv/assets/$i 
for j in ar en es fr ko
do
echo $i $j
find work/$j -name "*.md" -exec sed -i 's/(\/'$i'\//(\/assets\/'$i'\//g' {} ';'
done
done
rm -Rf site
zensical build -f un.toml
for i in ar en es fr ko
do
echo $i
zensical build -f $i.toml
done
