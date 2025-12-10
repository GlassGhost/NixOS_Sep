# {config, pkgs, ...}:
{ config, pkgs, unstable, locked, unstablelocked, ... }:
let
  # Create a new derivation based on the original gambit package
  gambit-renamed = pkgs.symlinkJoin {
#     Give our new package a name
    name = "gambit-renamed-${pkgs.gambit.version}";
    
#     Use the original gambit package as the source
    paths = [ pkgs.gambit ];
    
#     Run a command after building to rename the conflicting file
    postBuild = ''
      mv $out/bin/gsc $out/bin/gambit-gsc
    '';
  };
in

 {
    home.stateVersion = "25.11";
    home.username = "owner";
    home.homeDirectory = "/home/owner";
    nixpkgs.config.allowUnfree = true;
#    services.gnome-keyring.enable = true;
#     security.pam.services.lightdm.enableGnomeKeyring = true;
    services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
######################################################################

    home.packages = with pkgs; [
#    file Management
#    kompare
#    libsForQt5.kompare #(deprecated and will be removed in 25.11)
    locked.kdePackages.kompare
    locked.grsync
    locked.czkawka #fslint
    locked.transmission_4-qt
    locked.yt-dlp # youtube DL replacement
    locked.geogebra6   # fancy calculator and geometry analysis tool
    locked.inkscape
    locked.gimp
    locked.scid    #     chess stuff
    locked.stockfish   # chess stuff
    locked.gnome-mines
    
    (pkgs.symlinkJoin {
        name = "geogebra5-renamed";
        paths = [ pkgs.geogebra ];
        postBuild = ''
          mv $out/bin/geogebra $out/bin/geogebra5
        '';
    })

#     virtualbox  # Run VMs of other OS
    locked.libreoffice # Spreadsheet, Document, and Presentation editor
    locked.hyphen #helps libreoffice

    locked.obs-studio # streaming and recording app
    locked.blender # 3d programs
    locked.openscad

# 6385mib just for the pkgs above
######################################################################
#     development packages
    locked.nmh # provides "show" command
    locked.qtspim
#    (import /home/owner/sync/pepsi.nix)
#    (import /home/owner/sturdy-adventure/libbf.nix)
#    (import /home/owner/sync/pepsi2.nix)
#    (import /home/owner/sync/mach.nix)

#     development packages
    locked.clang-tools
    locked.gforth

#     clojure packages
    locked.clojure
    locked.openjdk
    locked.leiningen

#    scheme dev pkgs
    locked.racket
    locked.gauche
    locked.gambit
#   (locked.gambit.overrideAttrs (old: {
#     postInstall = ''
#       mv $out/bin/gsc $out/bin/gambit-gsc
#     '';
#   }))
#     gambit
    locked.chez

#     more development packages
    locked.cproto
    locked.arduino

#    pyside libs
#    libgssglue
#    openssh
#    openssh_gssapi
    locked.libkrb5
    locked.krb5
#    end pysdie libs

#    qt dev packages
#     qt5Full
    locked.qtcreator
#    end QT packages

    locked.mesa
    locked.xorg.libxcb
#     numpy packages
    locked.gfortran
#     blas
    locked.openblas
#     end numpy packages
#    libgssglue
#    openssh
#    openssh_gssapi
#    end pysdie libs
#    qt dev packages
#    end QT packages
#     numpy packages
#     end numpy packages
#    kernel-tools
#     example, to use kernel-tools to set the maximum frequency to 2.5 GHz:
#    sudo cpupower frequency-set -u 2500000k



#     libsForQt5.qtbase
#     libsForQt5.qttools
#     libsForQt5.qt5ct
# #    kdePackages.breeze-gtk
#     kdePackages.qt6ct

######################################################################
    locked.f2c #     convert Fortran 77 to C code
    locked.libf2c  # libs for Fortran to C code converter
    locked.poppler-utils
#    jre8
    locked.qpaeq
#    https://github.com/nixos-rocm/nixos-rocm


######################################################################

#    ###latex development packages
    locked.texworks
    locked.texlive.combined.scheme-full
    locked.pandoc
    locked.rPackages.fontawesome

#     (pkgs.symlinkJoin {
#         name = "ghostscript-renamed";
#         paths = [ pkgs.ghostscript ];
#         postBuild = ''
#           mv $out/bin/gsc $out/bin/gscps
#         '';
#     })
#     locked.ghostscript
    locked.tesseract
    locked.ocrfeeder

    locked.pdftk
    locked.stix-otf

    ];
}

######################################################################
# if system already has busybox, you can see it provides the following:
# busybox --list | column
# [                       fsck.minix              mkswap                  slattach
# [[                      fsfreeze                mktemp                  sleep
# acpid                   fstrim                  modinfo                 smemcap
# add-shell               fsync                   modprobe                softlimit
# addgroup                ftpd                    more                    sort
# adduser                 ftpget                  mount                   split
# adjtimex                ftpput                  mountpoint              ssl_client
# arch                    fuser                   mpstat                  start-stop-daemon
# arp                     getopt                  mt                      stat
# arping                  getty                   mv                      strings
# ascii                   grep                    nameif                  stty
# ash                     groups                  nanddump                su
# awk                     gunzip                  nandwrite               sulogin
# base32                  gzip                    nbd-client              sum
# base64                  halt                    nc                      sv
# basename                hd                      netstat                 svc
# bc                      hdparm                  nice                    svlogd
# beep                    head                    nl                      svok
# blkdiscard              hexdump                 nmeter                  swapoff
# blkid                   hexedit                 nohup                   swapon
# blockdev                hostid                  nologin                 switch_root
# bootchartd              hostname                nproc                   sync
# brctl                   httpd                   nsenter                 sysctl
# bunzip2                 hush                    nslookup                syslogd
# bzcat                   hwclock                 ntpd                    tac
# bzip2                   i2cdetect               od                      tail
# cal                     i2cdump                 openvt                  tar
# cat                     i2cget                  partprobe               taskset
# chat                    i2cset                  passwd                  tcpsvd
# chattr                  i2ctransfer             paste                   tee
# chgrp                   id                      patch                   telnet
# chmod                   ifconfig                pgrep                   telnetd
# chown                   ifdown                  pidof                   test
# chpasswd                ifenslave               ping                    tftp
# chpst                   ifplugd                 ping6                   tftpd
# chroot                  ifup                    pipe_progress           time
# chrt                    inetd                   pivot_root              timeout
# chvt                    init                    pkill                   top
# cksum                   insmod                  pmap                    touch
# clear                   install                 popmaildir              tr
# cmp                     ionice                  poweroff                traceroute
# comm                    iostat                  powertop                traceroute6
# conspy                  ip                      printenv                tree
# cp                      ipaddr                  printf                  true
# cpio                    ipcalc                  ps                      truncate
# crc32                   ipcrm                   pscan                   ts
# crond                   ipcs                    pstree                  tsort
# crontab                 iplink                  pwd                     tty
# cryptpw                 ipneigh                 pwdx                    ttysize
# cttyhack                iproute                 raidautorun             tunctl
# cut                     iprule                  rdate                   ubiattach
# date                    iptunnel                rdev                    ubidetach
# dc                      kbd_mode                readahead               ubimkvol
# dd                      kill                    readlink                ubirename
# deallocvt               killall                 readprofile             ubirmvol
# delgroup                killall5                realpath                ubirsvol
# deluser                 klogd                   reboot                  ubiupdatevol
# depmod                  last                    reformime               udhcpc
# devmem                  less                    remove-shell            udhcpc6
# df                      link                    renice                  udhcpd
# dhcprelay               linux32                 reset                   udpsvd
# diff                    linux64                 resize                  uevent
# dirname                 linuxrc                 resume                  umount
# dmesg                   ln                      rev                     uname
# dnsd                    loadfont                rm                      unexpand
# dnsdomainname           loadkmap                rmdir                   uniq
# dos2unix                logger                  rmmod                   unix2dos
# dpkg                    login                   route                   unlink
# dpkg-deb                logname                 rpm                     unlzma
# du                      logread                 rpm2cpio                unshare
# dumpkmap                losetup                 rtcwake                 unxz
# dumpleases              lpd                     run-init                unzip
# echo                    lpq                     run-parts               uptime
# ed                      lpr                     runlevel                users
# egrep                   ls                      runsv                   usleep
# eject                   lsattr                  runsvdir                uudecode
# env                     lsmod                   rx                      uuencode
# envdir                  lsof                    script                  vconfig
# envuidgid               lspci                   scriptreplay            vi
# ether-wake              lsscsi                  sed                     vlock
# expand                  lsusb                   seedrng                 volname
# expr                    lzcat                   sendmail                w
# factor                  lzma                    seq                     wall
# fakeidentd              lzop                    setarch                 watch
# fallocate               makedevs                setconsole              watchdog
# false                   makemime                setfattr                wc
# fatattr                 man                     setfont                 wget
# fbset                   md5sum                  setkeycodes             which
# fbsplash                mdev                    setlogcons              who
# fdflush                 mesg                    setpriv                 whoami
# fdformat                microcom                setserial               whois
# fdisk                   mim                     setsid                  xargs
# fgconsole               mkdir                   setuidgid               xxd
# fgrep                   mkdosfs                 sh                      xz
# find                    mke2fs                  sha1sum                 xzcat
# findfs                  mkfifo                  sha256sum               yes
# flock                   mkfs.ext2               sha3sum                 zcat
# fold                    mkfs.minix              sha512sum               zcip
# free                    mkfs.vfat               showkey
# freeramdisk             mknod                   shred
# fsck                    mkpasswd                shuf
