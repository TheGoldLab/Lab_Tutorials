#!/bin/bash
for filename in *.md; do
    root_string=${filename::-3}
    command cp "$filename" README.md
    node /home/adrian/Git/GitHub/markdown-to-html-github-style/convert.js "$root_string"
    mv README.html $root_string".html"
done
echo "don't forget to manually remove the hanging README.md now"
