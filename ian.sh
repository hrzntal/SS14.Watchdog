# App config in container volume
CONFIG_VOLUME="/app_config/appsettings.yml"
# App config in volatile storage
CONFIG_TARGET="/app/appsettings.yml"

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
  echo "daemon configuration not found, copying from deployment"
  # Copy fresh config to mount
  cp $CONFIG_TARGET $CONFIG_VOLUME
fi

# Delete the fresh config
rm $CONFIG_TARGET

# Symlink the real config to the app dir
ln -vsf $CONFIG_VOLUME $CONFIG_TARGET

# Check if we succeeded with creating the link
if [ ! -f "$CONFIG_TARGET" ]; then
  echo "failed to create symlink for config!"
  exit 1
fi

exec ./SS14.Watchdog $@