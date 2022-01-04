# App config in container volume
CONFIG_VOLUME="/app_config/appsettings.yml"
# App config in volatile storage
CONFIG_TARGET="/app/appsettings.yml"

# The things Ian can say
IAN_NOISES=("Woof" "Bork" "Bark" "Wau" "Ruff" "Hau Hau" "Awroo")
# Random number from 0 to 32767
RANDOM=$$$(date +%s)
DOG_NOISE=${IAN_NOISES[$RANDOM % ${#RANDOM[@]}]}

bs_print () { echo "[IAN BOOTSTRAP] "$@"" }

bs_print "
######\  ######\  ##\   ##\ 
\_##  _|##  __##\ ###\  ## |
  ## |  ## /  ## |####\ ## |   The Nanotrasen approved
  ## |  ######## |## ##\## |        Space Station 14
  ## |  ##  __## |## \#### |      Watchdog
  ## |  ## |  ## |## |\### |
######\ ## |  ## |## | \## |   Horizon Container Edition
\______|\__|  \__|\__|  \__|
"

if [ ! -f "$CONFIG_VOLUME" ]; then
  bs_print "Daemon configuration not found, copying from deployment..."
  # Copy fresh config to mount
  cp $CONFIG_TARGET $CONFIG_VOLUME
fi

# Delete the fresh config
bs_print "Wiping volatile config..."
rm $CONFIG_TARGET

# Symlink the real config to the app dir
bs_print "Linking mounted config to watchdog..."
ln -vsf $CONFIG_VOLUME $CONFIG_TARGET

# Check if we succeeded with creating the link
if [ ! -f "$CONFIG_TARGET" ]; then
  bs_print "Failed to create symlink for config!"
  exit 1
fi

bs_print "Handing over to Ian! $DOG_NOISE"
exec ./SS14.Watchdog "$@"
