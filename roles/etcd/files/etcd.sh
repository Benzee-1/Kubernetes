#!/bin/bash
usage() {
        echo "Usage :"
	echo "etcd.sh start|stop|status|destroy"
}
CONFFILE=/app/docker-compose-etcd.yml
DOCOMPOSE=/usr/local/bin/docker-compose

cmd=$1
case "$cmd" in
 start)
  echo "Starting etcd service"
  for ID in $(docker ps -aq)
  do
     NB=$(docker inspect $ID | grep Name |grep etcd |wc -l)
  done
  if [[ $NB -eq 0 ]]
  then
     $DOCOMPOSE -f $CONFFILE up -d
     code=$?
  else
     $DOCOMPOSE -f $CONFFILE start
     code=$?
  fi     
  exit $code;
 ;;

 stop)
  echo "Stopping etcd service"
  $DOCOMPOSE -f $CONFFILE stop
  code=$?
  exit $code;
 ;;

 status)
  echo "Status of etcd service"
  docker ps | grep etcd 
  code=$?
  exit $code;
 ;;

 destroy)
  echo "Destroying etcd service"
  $DOCOMPOSE -f $CONFFILE down
  code=$?
  exit $code;
  ;;

 help)
  usage
  exit 0;
 ;;

 *)
  if [ "$cmd" ]; then
   clear
   echo "Unknown command '$cmd'"
  fi
  usage
 ;;
esac
