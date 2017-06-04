---
layout:     post
title:      "【转载】Establishing a Android Build Environment"
date:       2017-06-04 17:39:54 +0800
categories: 技术
tags: ["转载",Android]
---
## Establishing a Build Environment

This section describes how to set up your local work environment to build the Android source files. You will need to use Linux or Mac OS. Building under Windows is not currently supported.

For an overview of the entire code-review and code-update process, see Life of a Patch.
### Choosing a Branch

Some of the requirements for your build environment are determined by which version of the source code you plan to compile. See Build Numbers for a full listing of branches you may choose from. You may also choose to download and build the latest source code (called master), in which case you will simply omit the branch specification when you initialize the repository.

Once you have selected a branch, follow the appropriate instructions below to set up your build environment.
### Setting up a Linux build environment

These instructions apply to all branches, including master.

The Android build is routinely tested in house on recent versions of Ubuntu LTS (14.04), but most distributions should have the required build tools available. Reports of successes or failures on other distributions are welcome.

For Gingerbread (2.3.x) and newer versions, including the master branch, a 64-bit environment is required. Older versions can be compiled on 32-bit systems.

Note: See the Requirements for the complete list of hardware and software requirements. Then follow the detailed instructions for Ubuntu and Mac OS below.
#### Installing the JDK

The master branch of Android in the Android Open Source Project (AOSP) requires Java 8. On Ubuntu, use OpenJDK.

See JDK Requirements for older versions.
##### For Ubuntu >= 15.04

Run the following:
```
$ sudo apt-get update
$ sudo apt-get install openjdk-8-jdk
```
##### For Ubuntu LTS 14.04

There are no available supported OpenJDK 8 packages for Ubuntu 14.04. The Ubuntu 15.04 OpenJDK 8 packages have been used successfully with Ubuntu 14.04. Newer package versions (e.g. those for 15.10, 16.04) were found not to work on 14.04 using the instructions below.

Download the .deb packages for 64-bit architecture from archive.ubuntu.com:
```
        openjdk-8-jre-headless_8u45-b14-1_amd64.deb with SHA256 0f5aba8db39088283b51e00054813063173a4d8809f70033976f83e214ab56c0
        openjdk-8-jre_8u45-b14-1_amd64.deb with SHA256 9ef76c4562d39432b69baf6c18f199707c5c56a5b4566847df908b7d74e15849
        openjdk-8-jdk_8u45-b14-1_amd64.deb with SHA256 6e47215cf6205aa829e6a0a64985075bd29d1f428a4006a80c9db371c2fc3c4c
```
Optionally, confirm the checksums of the downloaded files against the SHA256 string listed with each package above.

For example, with the sha256sum tool:
```
    $ sha256sum {downloaded.deb file}
```

Install the packages:

```
    $ sudo apt-get update
```

Run dpkg for each of the .deb files you downloaded. It may produce errors due to missing dependencies:

```
    $ sudo dpkg -i {downloaded.deb file}
```

To fix missing dependencies:

```
    $ sudo apt-get -f install
```

##### Update the default Java version - optional

Optionally, for the Ubuntu versions above update the default Java version by running:
```
$ sudo update-alternatives --config java
$ sudo update-alternatives --config javac
```
If, during a build, you encounter version errors for Java, set its path as described in the Wrong Java Version section.
#### Installing required packages (Ubuntu 14.04)

You will need a 64-bit version of Ubuntu. Ubuntu 14.04 is recommended.
```
$ sudo apt-get install git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip
```
Note: To use SELinux tools for policy analysis, also install the python-networkx package.

Note: If you are using LDAP and want to run ART host tests, also install the libnss-sss:i386 package.
#### Installing required packages (Ubuntu 12.04)

You may use Ubuntu 12.04 to build older versions of Android. Version 12.04 is not supported on master or recent releases.
```
$ sudo apt-get install git gnupg flex bison gperf build-essential \
  zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
  libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
  libgl1-mesa-dev g++-multilib mingw32 tofrodos \
  python-markdown libxml2-utils xsltproc zlib1g-dev:i386
$ sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
```
#### Installing required packages (Ubuntu 10.04 -- 11.10)

Building on Ubuntu 10.04-11.10 is no longer supported, but may be useful for building older releases of AOSP.
```
$ sudo apt-get install git gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs \
  x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev \
  libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown \
  libxml2-utils xsltproc
```
On Ubuntu 10.10:
```
$ sudo ln -s /usr/lib32/mesa/libGL.so.1 /usr/lib32/mesa/libGL.so
```
On Ubuntu 11.10:
```
$ sudo apt-get install libx11-dev:i386
```
#### Configuring USB Access

Under GNU/Linux systems (and specifically under Ubuntu systems), regular users can't directly access USB devices by default. The system needs to be configured to allow such access.

The recommended approach is to create a file at /etc/udev/rules.d/51-android.rules (as the root user).

To do this, run the following command to download the 51-android.txt file attached to this site, modify it to include your username, and place it in the correct location:
```
$ wget -S -O - http://source.android.com/source/51-android.txt | sed "s/<username>/$USER/" | sudo tee >/dev/null /etc/udev/rules.d/51-android.rules; sudo udevadm control --reload-rules
```
Those new rules take effect the next time a device is plugged in. It might therefore be necessary to unplug the device and plug it back into the computer.
#### Using a separate output directory

By default, the output of each build is stored in the out/ subdirectory of the matching source tree.

On some machines with multiple storage devices, builds are faster when storing the source files and the output on separate volumes. For additional performance, the output can be stored on a filesystem optimized for speed instead of crash robustness, since all files can be re-generated in case of filesystem corruption.

To set this up, export the OUT_DIR_COMMON_BASE variable to point to the location where your output directories will be stored.
```
$ export OUT_DIR_COMMON_BASE=<path-to-your-out-directory>
```
The output directory for each separate source tree will be named after the directory holding the source tree.

For instance, if you have source trees as /source/master1 and /source/master2 and `OUT_DIR_COMMON_BASE` is set to /output, the output directories will be /output/master1 and /output/master2.

It's important in that case to not have multiple source trees stored in directories that have the same name, as those would end up sharing an output directory, with unpredictable results.

This is only supported on Jelly Bean (4.1) and newer, including the master branch.
### Setting up a Mac OS build environment

In a default installation, Mac OS runs on a case-preserving but case-insensitive filesystem. This type of filesystem is not supported by git and will cause some git commands (such as git status) to behave abnormally. Because of this, we recommend that you always work with the AOSP source files on a case-sensitive filesystem. This can be done fairly easily using a disk image, discussed below.

Once the proper filesystem is available, building the master branch in a modern Mac OS environment is very straightforward. Earlier branches require some additional tools and SDKs.
#### Creating a case-sensitive disk image

You can create a case-sensitive filesystem within your existing Mac OS environment using a disk image. To create the image, launch Disk Utility and select "New Image". A size of 25GB is the minimum to complete the build; larger numbers are more future-proof. Using sparse images saves space while allowing to grow later as the need arises. Be sure to select "case sensitive, journaled" as the volume format.

You can also create it from a shell with the following command:
```
# hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/android.dmg
```
This will create a .dmg (or possibly a .dmg.sparseimage) file which, once mounted, acts as a drive with the required formatting for Android development.

If you need a larger volume later, you can also resize the sparse image with the following command:
```
# hdiutil resize -size <new-size-you-want>g ~/android.dmg.sparseimage
```

For a disk image named android.dmg stored in your home directory, you can add helper functions to your `~/.bash_profile`:

To mount the image when you execute mountAndroid:
```
    # mount the android file image
    function mountAndroid { hdiutil attach ~/android.dmg -mountpoint /Volumes/android; }
```
Note: If your system created a .dmg.sparseimage file, replace `~/android.dmg` with `~/android.dmg.sparseimage`.

To unmount it when you execute umountAndroid:
```
    # unmount the android file image
    function umountAndroid() { hdiutil detach /Volumes/android; }
```
Once you've mounted the android volume, you'll do all your work there. You can eject it (unmount it) just like you would with an external drive.
#### Installing the JDK

See Requirements for the version of Java to use when developing various versions of Android.
##### Installing required packages

Install Xcode command line tools with:

```
    $ xcode-select --install
```

For older versions of Mac OS (10.8 or earlier), you need to install Xcode from the Apple developer site. If you are not already registered as an Apple developer, you will have to create an Apple ID in order to download.

Install MacPorts from macports.org.

Note: Make sure that /opt/local/bin appears in your path before /usr/bin. If not, please add the following to your ~/.bash_profile file:

```
    export PATH=/opt/local/bin:$PATH
```

Note: If you do not have a `.bash_profile` file in your home directory, create one.

Get make, git, and GPG packages from MacPorts:

```
    $ POSIXLY_CORRECT=1 sudo port install gmake libsdl git gnupg
```

If using Mac OS X v10.4, also install bison:

```
    $ POSIXLY_CORRECT=1 sudo port install bison
```

##### Reverting from make 3.82

In Android 4.0.x (Ice Cream Sandwich) and earlier, a bug exists in gmake 3.82 that prevents android from building. You can install version 3.81 using MacPorts with these steps:
```
    Edit /opt/local/etc/macports/sources.conf and add a line that says:

    file:///Users/Shared/dports

    above the rsync line. Then create this directory:

    $ mkdir /Users/Shared/dports

    In the new dports directory, run:

    $ svn co --revision 50980 http://svn.macports.org/repository/macports/trunk/dports/devel/gmake/ devel/gmake/

    Create a port index for your new local repository:

    $ portindex /Users/Shared/dports

    Install the old version of gmake with:

    $ sudo port install gmake @3.81
```
##### Setting a file descriptor limit

On Mac OS, the default limit on the number of simultaneous file descriptors open is too low and a highly parallel build process may exceed this limit.

To increase the cap, add the following lines to your `~/.bash_profile:`
```
# set the number of open files to be 1024
ulimit -S -n 1024
```
### Optimizing a build environment (optional)
#### Setting up ccache

You can optionally tell the build to use the ccache compilation tool, which is a compiler cache for C and C++ that can help make builds faster. It is especially useful for build servers and other high-volume production environments. Ccache acts as a compiler cache that can be used to speed up rebuilds. This works very well if you use make clean often, or if you frequently switch between different build products.

Note: If you're instead conducting incremental builds (such as an individual developer rather than a build server), ccache may slow your builds down by making you pay for cache misses.

To use ccache, issue these commands in the root of the source tree:
```
$ export USE_CCACHE=1
$ export CCACHE_DIR=/<path_of_your_choice>/.ccache
$ prebuilts/misc/linux-x86/ccache/ccache -M 50G
```
The suggested cache size is 50-100G.

Put the following in your .bashrc (or equivalent):
```
export USE_CCACHE=1
```
By default the cache will be stored in ~/.ccache. If your home directory is on NFS or some other non-local filesystem, you will want to specify the directory in your .bashrc file too.

On Mac OS, you should replace linux-x86 with darwin-x86:

```
prebuilts/misc/darwin-x86/ccache/ccache -M 50G
```

When building Ice Cream Sandwich (4.0.x) or older, ccache is in a different location:

```
prebuilt/linux-x86/ccache/ccache -M 50G
```

This setting is stored in the `CCACHE_DIR` and is persistent.

On Linux, you can watch ccache being used by doing the following:
```
$ watch -n1 -d prebuilts/misc/linux-x86/ccache/ccache -s
```

### Next: Download the source

Your build environment is good to go! Proceed to downloading the source.

Except as otherwise noted, the content of this page is licensed under the Creative Commons Attribution 3.0 License, and code samples are licensed under the Apache 2.0 License. For details, see our Site Policies. Java is a registered trademark of Oracle and/or its affiliates.

Last updated March 27, 2017.
