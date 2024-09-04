#!/bin/bash

# Update and install OpenLDAP
sudo apt-get update
sudo apt-get install -y ldap-utils slapd

# Reconfigure slapd
sudo debconf-set-selections <<< "slapd slapd/internal/generated_adminpw password admin_password"
sudo debconf-set-selections <<< "slapd slapd/internal/adminpw password admin_password"
sudo debconf-set-selections <<< "slapd slapd/password2 password admin_password"
sudo debconf-set-selections <<< "slapd slapd/password1 password admin_password"
sudo debconf-set-selections <<< "slapd slapd/domain string openldap.fire.risingcloud.com"
sudo debconf-set-selections <<< "slapd shared/organization string risingcloud"
sudo dpkg-reconfigure -f noninteractive slapd

# Start and enable the LDAP service
sudo systemctl start slapd.service
sudo systemctl enable slapd.service

# Allow LDAP through the firewall
sudo ufw allow ldap

# Configure the LDAP client
sudo bash -c 'cat << EOF > /etc/ldap/ldap.conf
BASE    dc=openldap,dc=fire,dc=risingcloud,dc=com
URI     ldap://openldap.fire.risingcloud.com

TLS_CACERT  /etc/ssl/certs/ca-certificates.crt
EOF'

# Set root password
rootpw_hash=$(slappasswd -s 'your_root_password')

# Create rootpw.ldif
sudo bash -c 'cat << EOF > rootpw.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: '$rootpw_hash'
EOF'

# Apply root password
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f rootpw.ldif

# Import LDAP schemas
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/openldap.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dyngroup.ldif

# Create manager.ldif
sudo bash -c 'cat << EOF > manager.ldif
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=openldap,dc=fire,dc=risingcloud,dc=com

dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com
EOF'

# Apply manager configuration
sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f manager.ldif

# Create org.ldif
sudo bash -c 'cat << EOF > org.ldif
dn: dc=openldap,dc=fire,dc=risingcloud,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: risingcloud
dc: openldap

dn: cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com
objectClass: organizationalRole
cn: Manager
description: LDAP Manager

dn: ou=users,dc=openldap,dc=fire,dc=risingcloud,dc=com
objectClass: organizationalUnit
ou: Users
EOF'

# Add organization structure
sudo ldapadd -x -D "cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com" -W -f org.ldif

# Example to add a user
# Create user LDIF
sudo bash -c 'cat << EOF > bhavya.ldif
dn: cn=bhavya,dc=openldap,dc=fire,dc=risingcloud,dc=com
changetype: add
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
uid: bhavyabapna
cn: Bhavya
sn: Bapna
mail: bhavyabapna@in.risingcloud.com
userPassword: {SSHA}your_user_password_hash
EOF'

# Add the user
sudo ldapadd -D "cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com" -W -f bhavya.ldif

echo "OpenLDAP installation and configuration complete."
