Sure! Here's a bash script that automates the process of installing and configuring OpenLDAP based on the steps you provided.

### Steps to use the script:
1. **Customize the script**: 
   - Replace `admin_password` with your actual admin password.
   - Replace `your_root_password` with your root password.
   - Replace `your_user_password_hash` with the hashed password for the user Bhavya.

2. **Make the script executable**:
   ```bash
   chmod +x openldap_setup.sh
   ```

3. **Run the script**:
   ```bash
   sudo ./openldap_setup.sh
   ```

This script will install and configure OpenLDAP with the settings provided. It also includes an example for adding a user. You can expand the script to include additional users or groups as needed.