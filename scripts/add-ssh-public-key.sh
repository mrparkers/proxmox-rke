#!/usr/bin/env bash

sudo -H -u rke bash -c 'touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat ~/.ssh/rke.pub >> ~/.ssh/authorized_keys'
