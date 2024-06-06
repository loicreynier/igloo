# `$MO2_OVERWRITE` and `$MO2_DOWNLOADS` are read from `.env`

set dotenv-load := true

spriggit := "Spriggit.CLI"
spriggit_output := "./plugins"
plugins := spriggit_output / '*.esp/'
data_dir := './data'
esp_plugins := data_dir / '*.esp/'
dist_dir := './dist'
name := `basename $(git rev-parse --show-toplevel)`
release := dist_dir / name + "-`git describe --always --dirt`.zip"

_list:
    @just --list --unsorted

serialize-all: (serialize esp_plugins)

serialize plugins:
    for plugin in {{ plugins }}; do \
        {{ spriggit }} serialize \
            -i "$plugin" \
            -o {{ spriggit_output }}/$(basename "$plugin") \
            -g SkyrimSE \
            -p Spriggit.Yaml.Skyrim; \
        done

deserialize-all path="/tmp/Spriggit.Output": (deserialize plugins path)

deserialize plugins path="/tmp/Sprigit.Output":
    for plugin in {{ plugins }}; do \
        {{ spriggit }} deserialize \
            -i "$plugin" \
            -o {{ path }}/$(basename "$plugin") \
            -p Spriggit.Yaml.Skyrim; \
        done

install-plugins: (deserialize plugins "$MO2_OVERWRITE")

make-readme:
    pandoc-bbcode_nexus description.md -o description.bbcode

release: make-readme (deserialize plugins data_dir)
    @mkdir -p {{ dist_dir }}
    @cd {{ data_dir }} && zip -9 -r ../{{ release }} *

install-release: release
    @cp -v {{ release }} "$MO2_DOWNLOADS"
