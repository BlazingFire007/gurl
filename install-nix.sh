# get default shell
DEFAULT_SHELL=$(basename $SHELL)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m' # BOLD NO COLOR

# decide if curl or wget should be used
DOWNLOADER=""
if [ -x "$(which curl)" ]; then
  echo "[INFO]: CURL INSTALLED"
  DOWNLOADER="$(which curl)"
else
  echo "[INFO]: CHECKING FOR WGET"
  if [ -x "$(which wget)" ]; then
    echo "[INFO]: WGET INSTALLED"
    DOWNLOADER="$(which wget)"
  else
    echo "${BRED}[ERROR]: PLEASE INSTALL CURL OR WGET"
    exit 1
  fi
fi

# detect platform and arch
PLATFORM='UNKNOWN'
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM='linux'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM='macos'
else
    echo "${BRED}[ERROR]: UNKNOWN OR UNSUPPORTED OS: ${RED}$OSTYPE"
    exit 1
fi
ARCH='UNKNOWN'
if [[ "$(uname -m)" == "x86_64" ]]; then
    ARCH='64bit'
elif [[ "$(uname -m)" == "i386" ]]; then
    ARCH='32bit'
else
    echo "${BRED}[ERROR]: UNKNOWN OR UNSUPPORTED ARCH: ${RED}$(uname -m)"
    exit 1
fi
echo ""
echo "${BOLD}[INFO]: PLATFORM DETECTED: ${BGREEN}$PLATFORM${NC}"
echo "${BOLD}[INFO]: ARCHITECTURE DETECTED: ${BGREEN}$ARCH"
echo "${YELLOW}[WARNING]: IF THIS IS INCORRECT PLEASE EXIT THIS PROGRAM"
echo "${YELLOW}[WARNING]: OTHERWISE ${BGREEN}PRESS ENTER TO CONTINUE${NC}"
read


# check if default shell has a .rc file, if so, make a backup
RC_FILE="${HOME}/.${DEFAULT_SHELL}rc"
if [ -f $RC_FILE ]; then
    cp "${RC_FILE}" "${RC_FILE}.before_gurl"
fi

# check if ~/.gurl exists, if not, create it
if [ ! -d "${HOME}/.gurl" ]; then
    mkdir "${HOME}/.gurl"
fi

# download gurl
mkdir tmpgurlinstall
cd tmpgurlinstall
if [ "$DOWNLOADER" == "$(which curl)" ]; then
    curl -s -L -o "gurl" "https://github.com/BlazingFire007/gurl/releases/download/v0.1.0/gurl-${PLATFORM}-${ARCH}"
else
    wget -q -O "gurl" "https://github.com/BlazingFire007/gurl/releases/download/v0.1.0/gurl-${PLATFORM}-${ARCH}"
fi

echo "${BOLD}[INFO]: DOWNLOAD COMPLETE"
# make executable and move to ~/.gurl
chmod +x "./gurl"
mv "./gurl" "${HOME}/.gurl"

# add ~/.gurl to path
echo "export PATH=\"${HOME}/.gurl:\$PATH\"" >> "${RC_FILE}"

# clean up
cd ..
rm -rf tmpgurlinstall

echo "${BGREEN}[INFO]: INSTALLATION COMPLETE${NC}"
echo "${NC}[INFO]: INSTALLED GURL TO ${HOME}/.gurl"
echo "${NC}[INFO]: ADDED ${HOME}/.gurl TO PATH"
echo "${NC}[INFO]: BACKED UP ${RC_FILE} TO ${RC_FILE}.before_gurl"
echo ""
echo "${BOLD}PLEASE RESTART YOUR TERMINAL OR RUN '${BGREEN}source ${RC_FILE}${NC}${BOLD}' TO USE GURL"