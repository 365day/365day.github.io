#!/bin/sh
root=/my/blog/path
scriptName=`basename $0`
cd $root
case $1 in
    'blog')
        name=`date +"%H-%M-%S"`
        if [[ $2 ]]; then
            name=`echo $2|sed 's/ /-/g'`
        fi
        path=`rake new_post[$name]|awk -F":" '{print $2}'`
        vi $path
        ;;
    'page')
        if [[ ! $2 ]]; then
            echo 'need page name'
            exit
        fi
        name=`echo $2|sed 's/ /-/g'`
        echo $name
        path=`rake new_page[$name]|awk -F":" '{print $2}'`
        vi $path
        ;;
    'view')
        rake preview
        ;;
    'publish')
        rake gen_deploy
        ;;
    'build')
        rake clean
        rake generate
        ;;
    'open')
        open $root
        ;;
    'edit')
        vi $root
        ;;
    *)
        echo "usage: $scriptName [blog|page|view|publish|build|open|edit]"
        exit 1
        ;;
esac
