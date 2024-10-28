#!/bin/bash      
real_script_dir=$(dirname $0 | xargs realpath)
base_dir=$(dirname $real_script_dir | xargs realpath)
source $base_dir/Common/pg_status.sh

sudo apt update 1>>output.log 2>>error.log &
status $? 'updated repos' $! 'updating repos'

sudo apt install nginx -y 1>>output.log 2>>error.log &
status $? 'installed nginx' $! 'installing nginx'

sudo sed -i 's/${[A-Z]\+_HOST}/localhost/g' ${real_script_dir}/default.conf.template 1>>output.log 2>>error.log &
status $? 'updated host address to localhost in new config' $! 'updating host address to localhost in copying new config file'

sudo mv  ${real_script_dir}/default.conf.template /etc/nginx/conf.d/ 1>>output.log 2>>error.log &
status $? 'copied new config' $! 'copying new config file'

sudo mv ${real_script_dir}/frontend.tar /usr/share/nginx/ 1>>output.log 2>>error.log &
status $? 'moved frontend.tar to nginx source' $! 'moving frontend.tar to nginx source'

cd /usr/share/nginx/; sudo rm html/index.html 1>>output.log 2>>error.log &
status $? 'removed default index.html' $! 'removing default index.html'

sudo tar xvf /usr/share/nginx/frontend.tar -C /usr/share/nginx/html/ 1>>output.log 2>>error.log &
status $? 'unzipped source folders' $! 'unzipping source folders'

sudo sed -i -e '1i include /etc/nginx/conf.d/* ;' -e '1,$d' /etc/nginx/nginx.conf 1>>output.log 2>>error.log &
status $? 'updated nginx.conf' $! 'updating nginx.conf'

sudo systemctl start nginx 1>>output.log 2>>error.log &
status $? 'started nginx' $! 'starting nginx'

sudo systemctl enable nginx 1>>output.log 2>>error.log &
status $? 'enabled nginx' $! 'enabling nginx'

sudo nginx -s reload 1>>out.log 2>> error.log
status $? "reloaded nginx" $! "reloading nginx"

sudo systemctl status nginx