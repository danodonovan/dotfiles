#!/bin/bash
# Set correct permissions for 1Password CLI config directory
# 1Password CLI requires 700 permissions for security
chmod 700 ~/.config/op
chmod 600 ~/.config/op/config
