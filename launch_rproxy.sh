#!/usr/bin/env bash
echo "------------ Cleaning old LB ---------"
docker container list > /dev/null 2>&1
for i in `docker container list | cut -f1 -d " "`; do docker container stop $i > /dev/null 2>&1; done
docker container list > /dev/null 2>&1
docker container prune --force > /dev/null 2>&1

dir=`pwd`
echo "------------ Setting up LB ---------"
echo "Lanching Backend1"
uid=`docker run --name nginx_be1  -v $dir/index_be1.html:/usr/share/nginx/html/index.html:ro  -d nginx`
ip1=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $uid`
echo "BE1 IP: $ip1"

echo "Lanching Backend2"
uid=`docker run --name nginx_be2  -v $dir/index_be2.html:/usr/share/nginx/html/index.html:ro -d nginx`
ip2=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $uid`
echo "BE2 IP: $ip2"

echo "Lanching Reverse proxy"
sed  -e "s/be1/$ip1/g" -e "s/be2/$ip2/g" nginx_rproxy_template.conf > nginx_rproxy.conf
uid=`docker run --name nginx_lb -v $dir/nginx_rproxy.conf:/etc/nginx/nginx.conf:ro -d nginx`
ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $uid`
echo "Rproxy IP: $ip"

echo "------------ Setting up LB complete ---------"
