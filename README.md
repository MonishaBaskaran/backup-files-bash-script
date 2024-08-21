# backup-files-bash-script

Write a bash script backups24.sh that runs continuously in the background and performs operations 
as discussed below. 

Synopsis 
backup24.sh $1 $2 $3 
 backup24.sh can have 0-3 arguments 
 $1, $2 and $3 are used to indicate file types (any valid file type) 
o ex: $ backup24.sh .c .txt .pdf 
o ex: $ backup24.sh .zip 
 When no arguments are entered, all file types must be considered
Upon running the bash script with valid arguments as described earlier, the script must continuously run 
in the background and perform the following steps at specified time intervals 

STEP 1 Create a complete backup of the specified file types found in the entire directory tree rooted at 
/home/username by tarring all such files into cbup****.tar stored at ~/home/backup/cbup24s 
 Update backup.log with the timestamp and the name of the tar file (See Fig.1.0 for file naming)
 Note: Naming conventions of the backup files must be followed as per Fig 1.0
(2 minutes interval) 

STEP 2 Create an incremental backup of the specified file types in the entire directory tree rooted at 
/home/username that were newly created or modified (only) after STEP 1
 If there are any newly created/modified files after STEP1, create a tar file of those files (only): 
ib****.tar at ~/home/backup/ibup24s and update backup.log with the timestamp and the name 
of the tar file (see Fig. 1.0 for logging and the file naming)
 Else update backup.log with the timestamp and a message (See Fig.1.0)
(2 minutes interval) 

STEP 3 Create an incremental backup of the specified file types in the entire directory tree rooted at 
/home/username that were newly created or modified (only) after STEP 2 
 If there are any newly created/modified files after STEP 2, create a tar file of those files (only): 
ib****.tar at ~/home/backup/ibup24s and update backup.log with the timestamp and the name 
of the tar file (see Fig. 1.0 for logging and the file naming)
 Else update backup.log with the timestamp and a message (See Fig.1.0)
(2 minutes interval) 

STEP 4 Create a differential backup of the specified file types in the entire directory tree rooted at 
/home/username that were newly created or modified (only) after STEP 1
 If there are any newly created/modified files after STEP1, create a tar file of those files (only): 
db****.tar at ~/home/backup/dbup24s and update backup.log with the timestamp and the 
name of the tar file (see Fig. 1.0 for logging and the file naming)
 Else update backup.log with the timestamp and a message (See Fig.1.0)
(2 minutes Interval) 

STEP 5 Create an incremental backup of the specified file types in the entire directory tree rooted at 
/home/username that were newly created or modified (only) after STEP 4
 If there are any newly created/modified files after STEP 4, create a tar file of those files (only): 
ib****.tar at ~/home/backup/ibup24s and update backup.log with the timestamp and the name 
of the tar file (see Fig. 1.0 for logging and the file naming)
 Else update backup.log with the timestamp and a message (See Fig.1.0)
(PROCEED TO STEP 1 ) //Continuous loop
