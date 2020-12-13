#!/bin/bash

#find . -maxdepth 3 -name "*.sh" -exec chmod +x {} \;
find . -maxdepth 3 -name "*.sh"|xargs -i chmod +x {}
