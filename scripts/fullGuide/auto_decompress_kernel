#!/bin/bash -e

#Set Variables
BTPATH=/boot/firmware
CKPATH=$BTPATH/vmlinuz
DKPATH=$BTPATH/vmlinux

#Check if compression needs to be done.
if [ -e $BTPATH/check.md5 ]; then
	if md5sum --status --ignore-missing -c $BTPATH/check.md5; then
	echo -e "\e[32mFiles have not changed, Decompression not needed\e[0m"
	exit 0
	else echo -e "\e[31mHash failed, kernel will be compressed\e[0m"
	fi
fi

#Backup the old decompressed kernel
mv $DKPATH $DKPATH.bak

if [ ! $? == 0 ]; then
	echo -e "\e[31mDECOMPRESSED KERNEL BACKUP FAILED!\e[0m"
	exit 1
else 	echo -e "\e[32mDecompressed kernel backup was successful\e[0m"
fi

#Decompress the new kernel
echo "Decompressing kernel: "$CKPATH".............."

zcat $CKPATH > $DKPATH

if [ ! $? == 0 ]; then
	echo -e "\e[31mKERNEL FAILED TO DECOMPRESS!\e[0m"
	exit 1
else
	echo -e "\e[32mKernel Decompressed Succesfully\e[0m"
fi

#Hash the new kernel for checking
md5sum $CKPATH $DKPATH > $BTPATH/check.md5

if [ ! $? == 0 ]; then
	echo -e "\e[31mMD5 GENERATION FAILED!\e[0m"
	else echo -e "\e[32mMD5 generated Succesfully\e[0m"
fi

#Exit
exit 0