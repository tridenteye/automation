# LVM Partition Extension Script

This script is designed to extend a Logical Volume (LV) in Linux using Logical Volume Manager (LVM). It can add available free space from specified disks (or all disks) to an existing Logical Volume.

## Features

- Checks for existing LVM partitions before proceeding.
- Validates user input and provides detailed usage instructions.
- Automatically identifies and uses all available disks if "All" is specified.
- Creates new partitions if there is sufficient free space and fewer than 4 primary partitions.
- Extends the Volume Group (VG) and Logical Volume (LV) to use the newly added space.

## Requirements

- Linux system with LVM installed.
- `parted` utility installed.
- Sufficient privileges to create partitions and manage LVM (typically requires root access).

## Usage

### Running the Script

1. **Make the script executable:**

   ```bash
   chmod +x extend_lvm.sh
   ```

2. **Run the script with the required arguments:**

   ```bash
   ./extend_lvm.sh <disk name> <LV name>
   ```

   - `<disk name>`: The name of the disk (e.g., `sda`, `sdb`) or "All" to use all available disks.
   - `<LV name>`: The name of the Logical Volume to extend.

### Examples

- Extend the LV `root` using all available disks:

  ```bash
  ./extend_lvm.sh All root
  ```

- Extend the LV `home` using disk `sda`:

  ```bash
  ./extend_lvm.sh sda home
  ```

## Script Breakdown

1. **Initial Checks:**
   - Ensures there are existing LVM partitions.
   - Validates the number of arguments provided.

2. **Disk Identification:**
   - Determines the number of disks based on the input.
   - Handles both individual disk and "All" disk scenarios.

3. **Partition Management:**
   - Checks for existing disk labels and creates them if necessary.
   - Determines available free space and the number of partitions.
   - Creates new partitions if there is enough free space and fewer than 4 primary partitions.

4. **Volume Management:**
   - Creates Physical Volumes (PVs) on new partitions.
   - Extends the Volume Group (VG) to include new PVs.
   - Extends the Logical Volume (LV) to use the newly added space.

## Output

The script provides detailed output at each step, including:
- Disk and partition information.
- Free space availability.
- Partition creation details.
- Volume Group and Logical Volume extension status.

## Notes

- **Backup:** Ensure that important data is backed up before running this script as partition and volume operations can be destructive.
- **Testing:** Test the script in a controlled environment before deploying it on production systems.
- **Customization:** Modify disk label types and partitioning logic as necessary to fit the specific requirements of the target system.

## License

This script is provided "as-is" without any warranties. Use at your own risk.

---

**Author:** [Bhavya Bapna]  
**Contact:** []
