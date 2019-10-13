#!/usr/bin/env bash

echo "Cleanning vendor folder"
rm -r vendor/*

echo "Updating lesli-css"
cp node_modules/lesli-css/ vendor/ -ra

echo "Updating bulma"
cp node_modules/bulma/ vendor/ -ra

echo "Updating buefy"
cp node_modules/buefy/ vendor/ -ra
