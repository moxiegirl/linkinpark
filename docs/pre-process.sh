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
      "/docs/content/linkinpark/")
        y=${i##*/}
        find $i -type f -name "*.md" -exec ssed -R -i.old \
        -e '/^<!.*metadata]>/g' \
        -e '/^<!.*end-metadata.*>/g' \
        -e 's/(\]\()(?!https)(\.{1,2}\/){1,4}(.[\S]*.md)(\#.[\S]*)?(\))/\1\{\{< relref "'$dir'\/\3\4" >\}\}\)/g' \
        -e 's/(\]\()(?!https)(\/)(.[\S]*)(.md)(\#.[\S]*)?(\))/\1\{\{< relref "'$dir'\/\3\4" >\}\}\)/g' \
        -e 's/(\()(?!http)(.[\S]*)(.md)(\#.[\S]*)?(\))/\1\{\{< relref "'$dir'\/\2\3\4" >\}\}\)/g' \
        -e 's/(\]\()(?!https)(\.\/[A-z].*)(.gif|.png|.svg)(\))/\1.\2\3\4/g' {} \;  

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

