#!/bin/sh
echo 'PermitRootLogin yes' >> $TARGET_DIR/etc/ssh/sshd_config
echo 'PermitEmptyPasswords yes' >> $TARGET_DIR/etc/ssh/sshd_config
