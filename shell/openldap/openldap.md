This is a comprehensive guide for installing, configuring, and managing an OpenLDAP server. Here’s a summary:

### **Installation**
1. Install OpenLDAP tools and server:
   ```bash
   sudo apt-get install ldap-utils slapd
   ```
2. Reconfigure slapd:
   ```bash
   sudo dpkg-reconfigure slapd
   ```
   - Set the domain as `openldap.fire.risingcloud.com`.
   - Organization name: `risingcloud`.

### **Service Management**
1. Start and enable the LDAP service:
   ```bash
   sudo systemctl start slapd.service
   sudo systemctl enable slapd.service
   ```
2. Allow LDAP through the firewall:
   ```bash
   sudo ufw allow ldap
   ```

### **Configuration**
1. Configure the LDAP client:
   ```bash
   vi /etc/ldap/ldap.conf
   ```
   ```text
   BASE dc=openldap,dc=fire,dc=risingcloud,dc=com
   URI ldap://openldap.fire.risingcloud.com

   TLS_CACERT /etc/ssl/certs/ca-certificates.crt
   ```

### **Set Root Password**
1. Generate a hashed password:
   ```bash
   slappasswd
   ```
2. Create an LDIF file to set the root password:
   ```bash
   vi rootpw.ldif
   ```
   ```text
   dn: olcDatabase={0}config,cn=config
   changetype: modify
   add: olcRootPW
   olcRootPW: {SSHA}<your-hashed-password>
   ```
3. Apply the root password:
   ```bash
   ldapadd -Y EXTERNAL -H ldapi:/// -f rootpw.ldif
   ```

### **Import LDAP Schemas**
```bash
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/openldap.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dyngroup.ldif
```

### **Configure Manager User**
1. Create an LDIF file for the Manager user:
   ```bash
   vi manager.ldif
   ```
   ```text
   dn: olcDatabase={1}mdb,cn=config
   changetype: modify
   replace: olcSuffix
   olcSuffix: dc=openldap,dc=fire,dc=risingcloud,dc=com

   dn: olcDatabase={1}mdb,cn=config
   changetype: modify
   replace: olcRootDN
   olcRootDN: cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com
   ```
2. Apply the configuration:
   ```bash
   ldapmodify -Y EXTERNAL -H ldapi:/// -f manager.ldif
   ```

### **Create Organization and Groups**
1. Create an LDIF file for the organization and groups:
   ```bash
   vi org.ldif
   ```
   ```text
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
   ```
2. Add the organization and groups:
   ```bash
   ldapadd -x -D cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com -W -f org.ldif
   ```

### **Add Users**
1. Create an LDIF file for each user:
   ```bash
   vi bhavya.ldif
   ```
   ```text
   dn: cn=bhavya,dc=openldap,dc=fire,dc=risingcloud,dc=com
   changetype: add
   objectClass: inetOrgPerson
   uid: bhavyabapna
   cn: Bhavya
   sn: Bapna
   mail: bhavyabapna@in.risingcloud.com
   userPassword: {SSHA}<your-hashed-password>
   ```
2. Add the user:
   ```bash
   ldapadd -D "cn=Manager,dc=openldap,dc=fire,dc=risingcloud,dc=com" -W -f bhavya.ldif
   ```

### **Add Multiple Users**
1. Create an LDIF file with multiple users:
   ```bash
   vi testusers.ldif
   ```
   (Example provided in the original content.)
2. Add the users:
   ```bash
   sudo ldapadd -x -D cn=admin,dc=ldap,dc=local -W -f testusers.ldif
   ```

### **Create Groups**
1. Create an LDIF file for groups:
   ```bash
   vi groups.ldif
   ```
   (Example provided in the original content.)
2. Add the groups:
   ```bash
   sudo ldapadd -x -D cn=admin,dc=ldap,dc=local -W -f groups.ldif
   ```

### **Useful Commands**
- View all users:
   ```bash
   sudo ldapsearch -x -b dc=openldap,dc=fire,dc=risingcloud,dc=com -H ldap://openldap.fire.risingcloud.com
   ```
- Check LDAP service status:
   ```bash
   systemctl status slapd
   ```

This should provide a solid foundation for setting up and managing your OpenLDAP server.