#!/bin/bash
set -euo pipefail

# Check if LVM partitions exist
if [[ $(lvs | wc -c) -eq 0 ]]; then
    echo "NO LVM partition found....."
    exit -99
fi

# Validate the number of arguments
if [ "$#" -ne 2 ]; then
    echo "################     ERROR!!!    ######################"
    echo "Usage: $0 <name of disk> <LV name>" >&2
    echo "eg: $0 sda root or $0 All root"
    echo "Disk name should be like sda, sdb etc... or you can use All to add all the space available in all the disks to a single LV"
    lsblk -S | grep disk
    lsblk -Sio NAME,SIZE,TYPE
    echo "LV name that you want to extend"
    lvs
    exit 99
fi

diskName=$1
lvName=$2

# Function to check command result and exit on failure
check_result() {
    if [ $? -ne 0 ]; then
        echo "####################################"
        echo "ERROR: Failed; Exiting."
        echo "####################################"
        exit 1
    fi
}

# Determine the number of disks
if [[ $diskName == "All" ]]; then
    NumberOfDisks=$(lsblk -S | grep -c disk)
    check_result
    echo "INFO: Number of disks present: ${NumberOfDisks}"
else
    NumberOfDisks=1
fi

# Process each disk
for ((i=1; i<=${NumberOfDisks}; i++)); do
    if [[ $diskName == "All" ]]; then
        disk=$(lsblk -d -n -o NAME | grep -vE 'fd|sr' | sed -n "${i}p")
    else
        disk=$diskName
    fi

    echo "_____________________________ $disk _____________________________"

    # Create disk label if not present
    Disklabel=$(parted /dev/$disk print | grep "Partition Table" | awk '{print $3}')
    if [[ $Disklabel == "unknown" ]]; then
        echo "CATCH: Creating the Disk Label for disk: $disk"
        parted /dev/$disk mklabel msdos
    fi

    # Check free space on the disk
    freeSpace=$(parted /dev/$disk unit GB print free | grep 'Free Space' | tail -n1 | awk '{print $3}' | tr -d GB | awk -F. '{print $1}')
    check_result
    echo "INFO: Total free disk space for disk: $disk is ${freeSpace} GB"

    # Count total number of partitions
    TotalNumberOfPartition=$(lsblk -n -o KNAME,TYPE | grep -c "${disk}p")
    check_result
    echo "INFO: Total number of partitions on $disk is ${TotalNumberOfPartition}"

    # Check if there is enough space and partition slots
    if [[ $freeSpace -lt 1 || ${TotalNumberOfPartition} -eq 4 ]]; then
        echo "ERROR: Cannot create new partition. Disk already has 4 primary partitions or disk size is less than 1GB"
        echo "INFO: Total free disk space for disk: $disk is ${freeSpace} GB"
        echo "INFO: Total number of partitions on $disk is ${TotalNumberOfPartition}"
        continue
    fi

    # Count primary partitions
    numbarOfPrimaryPartition=$(lsblk -n -o KNAME,TYPE | grep "${disk}p" | wc -l)
    check_result
    echo "INFO: Total primary partitions on $disk is ${numbarOfPrimaryPartition}"

    # Calculate new partition number
    newPartition=$(($numbarOfPrimaryPartition + 1))
    check_result

    # Determine the start size for the new partition
    PartitionStartSize=$(parted /dev/$disk unit GB print | tail -n2 | awk 'FNR == 1 {print $3}')
    PartitionStartSize=${PartitionStartSize/GB/}
    PartitionStartSize="${PartitionStartSize:-0.00}GB"

    # Create new partition
    echo "Before partition:"
    parted /dev/$disk unit GB print
    check_result

    parted /dev/$disk mkpart primary ext4 $PartitionStartSize 100%
    check_result

    echo "After partition:"
    parted /dev/$disk unit GB print
    check_result

    # Create Physical Volume
    vgName=$(lvs --noheadings -o vg_name | head -n1 | tr -d ' ')
    check_result
    echo "Extending the VG $vgName"
    
    vgextend $vgName /dev/${disk}${newPartition}
    check_result

    echo "Extending the LV $lvName"
    lvextend -r -l +100%FREE /dev/$vgName/$lvName
    check_result

done

# Display final state of LVM
pvs
vgs
lvs
