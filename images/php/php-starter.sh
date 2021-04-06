#!/bin/bash
if [ "$SET_UP_SSH_SERVER" = 'true' ]; then
  supervisord -n
else
  cron && php-fpm
fi
