# About this project

The purpose to this project is to find a linking solution that works in GitHub and with the documentation release process.

## Understand GitHub Link Support

GitHub [supports relative
links](https://help.github.com/articles/relative-links-in-readmes/). We tested
this and, in practice, found that at deeper levels the relative links seem to
break.  Not all relative links work consistently see the [Level 3
root](level2/level3/3-root.md) in comparison to the [Level 3
index](level2/level3/index.md) links.

## Understand how the Build

First, it is important to understand tatic file generators handle files called `index.md` differently than other files.


<table>
<tr>
<td>
<pre>
.
|-- Dockerfile
|-- Makefile
|-- index.md
|-- level2
|   |-- 2-root.md
|   |-- images
|   |   `-- baldwin.gif
|   |-- index.md
|   `-- level3
|       |-- 3-root.md
|       `-- index.md
|-- pre-process.sh
`-- rootfile.md
</pre>
</td>
<td>
<pre>
.
|-- Dockerfile
|-- Makefile
|-- index.html
|-- index.xml
|-- level2
|   |-- 2-root
|   |   `-- index.html
|   |-- images
|   |   `-- baldwin.gif
|   |-- index.html
|   `-- level3
|       |-- 3-root
|       |   `-- index.html
|       `-- index.html
|-- pre-process.sh
`-- rootfile
    `-- index.html
</pre>
</td>
</tr>
</table>







At run time, the build copies the source files from the `*projectname*/docs` directory into a `content/*projectname*` directory. This copy prevents naming collisions between Docker projects which may have files or folders with identical names.

Once the files are copied, a script runs several `seds` over the files to resolve the paths relative to the `projectname` directory.  



 