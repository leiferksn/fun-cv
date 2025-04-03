#!/bin/bash

echo "Generating site ..."

xsltproc cv.xml cv.xsl -o index.html

echo "done."
