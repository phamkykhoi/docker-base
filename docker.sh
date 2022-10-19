#!/bin/bash

function _up() {
  docker-compose --env-file .env up -d
}

function _stop() {
  docker-compose --env-file .env down 
}

function _rebuild() {
  docker-compose --env-file .env up -d --build --force-recreate --remove-orphans
}

function _ssh() {
  docker-compose --env-file .env exec app bash
}

case $1 in
  "start") _up ;;
  "stop") _stop ;;
  "rebuild") _rebuild ;;
  "ssh") _ssh ;;
esac