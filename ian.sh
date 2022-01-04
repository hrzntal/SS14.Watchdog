# App config in container volume
CONFIG_VOLUME="/app_config/appsettings.yml"
# App config in volatile storage
CONFIG_TARGET="/app/appsettings.yml"

# The things Ian can say, one will be picked at random
IAN_NOISE=`echo "Woof Bork Bark Wau Ruff Hauhau Awroo" |
  awk 'BEGIN { srand() } {split($0,a); print a[1+int(rand()*length(a))]}'`

bs_print () { echo "[IAN BOOTSTRAP] ""$@"""; }

echo "
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
  cp -v $CONFIG_TARGET $CONFIG_VOLUME
fi

# Delete the fresh config
bs_print "Wiping volatile config..."
rm -v $CONFIG_TARGET

# Symlink the real config to the app dir
bs_print "Linking mounted config to watchdog..."
ln -vsf $CONFIG_VOLUME $CONFIG_TARGET

# Check if we succeeded with creating the link
if [ ! -f "$CONFIG_TARGET" ]; then
  bs_print "Failed to create symlink for config!"
  exit 1
fi

bs_print "Handing over to Ian! $IAN_NOISE"
exec ./SS14.Watchdog "$@"
