#!/bin/bash
cd immortalwrt

cat ../wh3000pro.config > .config
echo "make defconfig"
make defconfig || { echo "defconfig failed"; exit 1; }
echo "diff initial config and new config:"
diff ../wh3000pro.config .config
echo "diff initial config and new config (from old config only):"
diff ../wh3000pro.config .config | grep -e "^<" | grep -v "^< #"
echo "diff initial config and new config (from new config only):"
diff ../wh3000pro.config .config | grep -e "^>" | grep -v "^> #"
echo "check device exist"
grep -Fxq "CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_huasifei_wh3000-pro-emmc=y" .config || exit 1

MAKE_V=${1:-0}
echo "make immortalwrt"
make V=$MAKE_V -j$(nproc) || {
    echo "make failed";
    if [ "$MAKE_V" -eq 0 ]; then
        echo "Retrying with make V=s -j1";
        make V=s -j1 || { echo "Retry failed"; exit 1; }
    else
        exit 1;
    fi
}