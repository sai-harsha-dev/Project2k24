#!/bin/bash      
script_dir=$(dirname $0)
base_dir=$(dirname $script_dir | xargs realpath)
source $base_dir/Common/pg_status.sh

sudo apt update 1>>output.log 2>>error.log &
status $? 'updated repos' $! 'updating repos'

sudo apt install nginx -y 1>>output.log 2>>error.log &
status $? 'installed nginx' $! 'installing nginx'

sudo cp default.conf.template /etc/nginx/conf.d/ 1>>output.log 2>>error.log &
status $? 'copied new config' $! 'copying new config file'

sudo mv frontend.tar /usr/share/nginx/ 1>>output.log 2>>error.log &
status $? 'moved frontend.tar to nginx source' $! 'moving frontend.tar to nginx source'

cd /usr/share/nginx/; sudo rm html/index.html 1>>output.log 2>>error.log &
status $? 'removed default index.html' $! 'removing default index.html'

sudo tar xvf frontend.tar -C html/ --strip-components=1  1>>output.log 2>>error.log &
status $? 'unzipped source folders' $! 'unzipping source folders'

# sudo mv index.html /usr/share/nginx/html 1>>output.log 2>>error.log &
# status $? 'moved index.html to nginx source' $! 'moving index.html to nginx source'

# sudo mv media -C /usr/share/nginx/html/ 1>>output.log 2>>error.log &
# status $? 'moving media to nginx source' $! 'extracting media'

# sudo tar xvf images.tar -C /usr/share/nginx/html/ 1>>output.log 2>>error.log &
# status $? 'extrated images' $! 'extracting images'

sudo cat include /etc/nginx/conf.d/*; > /etc/nginx/nginx.conf 1>>output.log 2>>error.log &
status $? 'updated nginx.conf' $! 'updating nginx.conf'

sudo systemctl start nginx 1>>output.log 2>>error.log &
status $? 'started nginx' $! 'starting nginx'

sudo systemctl enable nginx 1>>output.log 2>>error.log &
status $? 'enabled nginx' $! 'enabling nginx'

sudo systemctl status nginx