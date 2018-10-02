#!/bin/bash
#
# Fix genisoimage errors in Debian-based distributions with cdrtools
#
# ===========================================================================
#
# - Try to install the build-essential package if prompted by the user
# - Get the cdrtools package from SourceForge
# - Compile and install the package
# - Remove links to genisoimage and set them to cdrtools
# - Clear the working directory
#
# Ricardo Jesus <rj (dot) bcjesus (at) gmail (dot) com>
#
# ===========================================================================

# Check if script is run as ROOT. If not, do nothing
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Directory to use temporarily
TMPDIR="/tmp"

# Name of cdrtools package
CDRTOOLS="cdrtools-3.02a01"

# Extension of package (at SourceForge)
EXTENSION=".tar.bz2"

# Base URL at SourceForge
BASEURL="http://sourceforge.net/projects/cdrtools/files/alpha"

while getopts "bd:e:hu:C:" Option
do
  case $Option in
    h ) echo "Usage:"
        echo "  $0 [OPTION] ..."
        echo ""
        echo "The script's parameters are:"
        echo "  -h            This help."
        echo "  -d <tmpdir>   Temporary directory to use for the building"
	echo "                process"
        echo "  -b            Install 'build-essential' from the official"
	echo "                repositories, which is necessary to build cdrtools"
        echo "  -C <cdrtools> Set the package name of cdrtools to get"
        echo "  -e <ext>      Extension of cdrtools package. Defautls to"
	echo "                $EXTENSION which should be correct"
        echo "  -u <url>      Set the base URL where cdrtools is available."
	echo "                Defaults to the repository at SourceForge:"
	echo "                $BASEURL"
        exit
        ;;
    b ) apt install build-essential
        ;;
    d ) TMPDIR=${OPTARG}
	;;
    e ) EXTENSION=${OPTARG}
        ;;
    u ) BASEURL=${OPTARG}
        ;;
    C ) CDRTOOLS=${OPTARG}
        ;;
    * ) echo "You passed an illegal switch to the program."
        echo "Run '$0 -h' for more help."
        exit
        ;;
  esac
done

# Finish setting up variables for the script

CDRTOOLSDIR=$TMPDIR/$CDRTOOLS
CDRTOOLSURL=$BASEURL$CDRTOOLS$EXTENSION

# ---------------------------------------------------------------------------
# Here starts the actual work of the script
# ---------------------------------------------------------------------------

# Make $CDRTOOLSDIR
mkdir "$CDRTOOLSDIR"

# Get latest cdrtools from SourceForge
wget -P "$TMPDIR" "$CDRTOOLSURL"

# Unpack to $CDRTOOLSDIR
tar xfv "$CDRTOOLSDIR""$EXTENSION" -C "$CDRTOOLSDIR" --strip-components=1

# Compile and install
make -C "$CDRTOOLSDIR"
make -C "$CDRTOOLSDIR" install

# Move the following files (some will be links) from /usr/bin to a junk folder
mkdir /opt/schily/replacedfiles
mv /usr/bin/cdrecord /opt/schily/replacedfiles
mv /usr/bin/genisoimage /opt/schily/replacedfiles
mv /usr/bin/mkisofs /opt/schily/replacedfiles
mv /usr/bin/readom /opt/schily/replacedfiles
mv /usr/bin/wodim /opt/schily/replacedfiles

# Create links
ln -s /opt/schily/bin/cdrecord /usr/bin/cdrecord
ln -s /opt/schily/bin/mkisofs /usr/bin/genisoimage
ln -s /opt/schily/bin/mkisofs /usr/bin/mkisofs
ln -s /opt/schily/bin/readcd /usr/bin/readom
ln -s /opt/schily/bin/cdrecord /usr/bin/wodim
ln -s /opt/schily/bin/readcd /usr/bin/readcd
ln -s /opt/schily/bin/mkhybrid /usr/bin/mkhybrid
ln -s /opt/schily/bin/cdda2wav /usr/bin/cdda2wav

# Remove working folder
rm -r "$CDRTOOLSDIR"
