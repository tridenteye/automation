## User create with group wheel as wheel as sudo access by default, cat etc/sudoerc
useradd ${username}
passwd ${username}

usermod -aG wheel ${username}

# //
useradd -G wheel testuser
passwd ${username}