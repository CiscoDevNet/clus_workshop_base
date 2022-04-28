#!/bin/bash
if [ "$#" -lt 1 ] || [ $1 != "${DEVENV_PASSWORD}" ] ; then
      echo "Access denied"  
      exit 0                               
fi                                            
source /home/developer/.bash_profile
/bin/bash
~

