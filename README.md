While using ACLs is a common and useful thing, determining their effects in conjunction with POSIX permissions can be quite an elusive thing.  Lets start by taking a look at the following:

> ls -ld /archive/acltest/
drwxr-xr-x+ 2 ckerner ckerner 4096 Mar 10 13:22 /archive/acltest/
          ^
          This lets us know that there is an ACL applied to this directory.  

Since we are using IBM SpectrumScale, we can look at the ACL with the mmgetacl command.  We see that it is just the plain POSIX permissions that we saw with the ls.

> mmgetacl /archive/acltest/
#owner:ckerner
#group:ckerner
user::rwxc
group::r-x-
other::r-x-

Now, this looks pretty straight forward.  However, a directory can also have a default ACL that gets applied to all of the files and directories within it when they are created.  Lets look at the default ACL:

> mmgetacl -d /archive/acltest/
#owner:ckerner
#group:ckerner
user::rwxc
group::r-x-
other::r-x-
mask::rwxc
user:ckerner:rwxc

As you can see, it took 3 commands to view all of the information about the ACL. And that was just for a single directory. Imagine checking lots of files.  Hence the need to merge this information together.

> acls /archive/acltest/
Permissions Mode Owner    Group    USER GRUP GEFF OTHR MASK Modification Time   Filename
drwxr-xr-x+ 0755 ckerner  ckerner  rwxc r-x- r-x- r-x- ---- 2020-03-10 13:22:28 /archive/acltest

This output shows the POSIX permissions, numerical file mode, user permissions, group permissions, the effective group permissions, the other permissions and the default mask of the ACL.

If you want to see the default ACL information as well, you can add the -d option as such:

> ./acls -d /archive/acltest/
Default ACL: /archive/acltest
drwxr-xr-x+ 0755 ckerner  ckerner  rwxc r-x- r-x- r-x- rwxc 2020-03-10 13:22:28 /archive/acltest
                                   rwxc                rwxc ckerner             

Permissions Mode Owner    Group    USER GRUP GEFF OTHR MASK Modification Time   Filename
drwxr-xr-x+ 0755 ckerner  ckerner  rwxc r-x- r-x- r-x- ---- 2020-03-10 13:22:28 /archive/acltest

From this you can see that there is a default ACL on the directory, with a special USER ACL created on all new files.

You can also list all of the files within that directory as well with the recurse option, -r:

> ./acls -d -r /archive/acltest/
Default ACL: /archive/acltest
drwxr-xr-x+ 0755 ckerner  ckerner  rwxc r-x- r-x- r-x- rwxc 2020-03-10 13:22:28 /archive/acltest
                                   rwxc                rwxc ckerner             

Permissions Mode Owner    Group    USER GRUP GEFF OTHR MASK Modification Time   Filename
drwxr-xr-x+ 0755 ckerner  ckerner  rwxc r-x- r-x- r-x- ---- 2020-03-10 13:22:28 /archive/acltest

Permissions Mode Owner    Group    USER GRUP GEFF OTHR MASK Modification Time   Filename
-rw-rw-r--+ 0664 ckerner  ckerner  rw-c r-x- r--- r--- rw-c 2020-03-09 08:16:56 /archive/acltest/acl
                                   rwxc                rw-c ckerner             
-rw-rw-r--+ 0664 ckerner  ckerner  rw-c r-x- r--- r--- rw-- 2020-03-10 13:22:28 /archive/acltest/acl.2
                                   rwx-                rw-- ckerner             
-rwxr-xrwx+ 0757 ckerner  ckerner  rwxc rwx- r-x- rwx- r-x- 2020-03-10 11:35:04 /archive/acltest/file1
                                   rwx-                r-x- root                
                                        rwx-           r-x- influxdb            
-rw-rw-r--+ 0664 ckerner  ckerner  rw-c r-x- r--- r--- rw-c 2020-03-10 11:35:26 /archive/acltest/file100
                                   rwxc                rw-c ckerner             
-rwxr-xr--  0754 ckerner  ckerner  rwxc r-x- r-x- r--- ---- 2020-03-09 08:16:44 /archive/acltest/file2
-rwxr-xrwx+ 0757 ckerner  ckerner  rwxc rwx- r-x- rwx- r-x- 2020-03-09 08:16:44 /archive/acltest/file3
                                   rwx-                r-x- root                
                                        rwx-           r-x- influxdb            
-rw-rw-r--+ 0664 ckerner  ckerner  rw-c r-x- r--- r--- rw-c 2020-03-09 08:16:44 /archive/acltest/file4
                                   rwxc                rw-c ckerner             
