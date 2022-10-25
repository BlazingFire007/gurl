#! bash
DEFAULT_SHELL=$(basename $SHELL)

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
    echo "$[ERROR]: PLEASE INSTALL CURL OR WGET"
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
    echo "[ERROR]: UNKNOWN OR UNSUPPORTED OS: $OSTYPE"
    exit 1
fi
ARCH='UNKNOWN'
if [[ "$(uname -m)" == "x86_64" ]]; then
    ARCH='64bit'
elif [[ "$(uname -m)" == "i386" ]]; then
    ARCH='32bit'
else
    echo "[ERROR]: UNKNOWN OR UNSUPPORTED ARCH: $(uname -m)"
    exit 1
fi
echo ""
echo "[INFO]: PLATFORM DETECTED: $PLATFORM"
echo "[INFO]: ARCHITECTURE DETECTED: $ARCH"


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

echo "[INFO]: DOWNLOAD COMPLETE"
# make executable and move to ~/.gurl
chmod +x "./gurl"
mv "./gurl" "${HOME}/.gurl"

# add ~/.gurl to path
echo "export PATH=\"${HOME}/.gurl:\$PATH\"" >> "${RC_FILE}"

# clean up
cd ..
rm -rf tmpgurlinstall

echo "[INFO]: INSTALLATION COMPLETE"
echo "$[INFO]: INSTALLED GURL TO ${HOME}/.gurl"
echo "$[INFO]: ADDED ${HOME}/.gurl TO PATH"
echo "$[INFO]: BACKED UP ${RC_FILE} TO ${RC_FILE}.before_gurl"
echo ""
echo "PLEASE RESTART YOUR TERMINAL OR RUN 'source ${RC_FILE}' TO USE GURL"