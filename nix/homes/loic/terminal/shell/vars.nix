{ config, ... }:
{
  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    GOCACHE = "${config.xdg.cacheHome}/go-build";
  };
}
