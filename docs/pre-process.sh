#!/bin/bash -ex

# Populate an array with just docker dirs and one with content dirs
content_dir=(`ls -d /docs/content/*/`)

# Loop content not of docker/
#
# Sed to process GitHub Markdown
# 1-2 Remove comment code from metadata block
# 3 Remove .md extension from link text
# 4 Change ](/ to ](/project/ in links
# 5 Change ](word) to ](/project/word)
# 6 Change ](../../ to ](/project/
# 7 Change ](../ to ](/project/word)
# 
for i in "${content_dir[@]}"
do
  :
  echo "Directory is" $i
   dir="$(basename $(basename $i))"
   cd $i
   case $i in
      "/docs/content/windows/")
      ;;
      "/docs/content/mac/")
      ;;
      "/docs/content/linux/")
      ;;
      "/docs/content/docker/")
         y=${i##*/}
         find $i -type f -name "*.md" -exec ssed -R -i.old \
         -e '/^<!.*metadata]>/g' \
         -e '/^<!.*end-metadata.*>/g' {} \;
      ;;
      "/docs/content/boober/")
        y=${i##*/}
        find $i -type f -name "*.md" -exec ssed -R -i.old \
        -e '/^<!.*metadata]>/g' \
        -e '/^<!.*end-metadata.*>/g' \
        -e 's/(\]\()(\/docs)(.[\S]*.md)(\#.[\S]*)?(\))/\1\{\{< relref "'$dir'\3\4" >\}\}\5/g' \
        -e 's/(\]\()(\/docs)(.[\S]*)(.gif|.png|.svg)(\))/\1\/'$dir'\3\4\5/g' {} \;  
      ;;
      "/docs/content/linkinpark/")
        y=${i##*/}
        find $i -type f -name "*.md" -not -name "*.compare.md" -exec sed -i.old \
        -e '/^<!\(--\)\{0,1\}\[\(end-\)\{0,1\}metadata\]\(--\)\{0,1\}>/g' \
        -e 's/\(\][(]\)\(\.*\/\)*/\1/g' \
        -e 's/\(\][(]\)\([A-Za-z0-9_/-]\{1,\}\)\(\.md\)\{0,1\}\(#\{0,1\}\(#[A-Za-z0-9_-]*\)\{0,1\}\)[)]/\1\/'$dir'\/\2\4)/g' \
        {} \;
      ;;
      *)
        y=${i##*/}
        find $i -type f -name "*.md" -exec ssed -R -i.old  \
        -e '/^<!.*metadata]>/g' \
        -e '/^<!.*end-metadata.*>/g' \
        -e 's/(\]\()(?!https)(\.{1,2}\/){1,4}(.[\S]*.md)(\#.[\S]*)?(\))/\1\{\{< relref "'$y'\/\3\4\5" >\}\}\)/g' {} \; 
      ;;
      esac
done

#
#  Move docker directories to content
#
for i in "${docker_dir[@]}"
do
   :
    if [ -d $i ]    
      then
        mv $i /docs/content/ 
      fi
done

rm -rf /docs/content/docker
find $i -type f -name "*.old" -exec rm {} \;
