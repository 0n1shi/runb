#

```bash
root@runc:/# ls -l /dev/pts/
total 0
crw--w---- 1 root tty  136, 0 Dec 25  2018 0
crw-rw-rw- 1 root root   5, 2 Dec 25  2018 ptmx
root@runc:/# ls -l /dev/ptmx
lrwxrwxrwx 1 root root 8 Dec 25 08:51 /dev/ptmx -> pts/ptmx
```

