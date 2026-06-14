{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jdk17
    android-tools
    wget
    unzip
  ];
  env = {
    ANDROID_HOME = "$HOME/.android-sdk";
    ANDROID_SDK_ROOT = "$HOME/.android-sdk";
    PATH = "$HOME/.android-sdk/cmdline-tools/latest/bin:$HOME/.android-sdk/platform-tools:$HOME/.android-sdk/emulator:$HOME/.android-sdk/build-tools/34.0.0:$PATH";
  };
  shellHook = ''
    mkdir -p $HOME/.android-sdk/cmdline-tools
    if [ ! -d "$HOME/.android-sdk/cmdline-tools/latest" ]; then
      cd /tmp
      wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -O cmdline-tools.zip || true
      if [ -f cmdline-tools.zip ]; then
        unzip -q cmdline-tools.zip
        mkdir -p $HOME/.android-sdk/cmdline-tools/latest
        cp -r cmdline-tools/* $HOME/.android-sdk/cmdline-tools/latest/ || true
        rm -rf cmdline-tools.zip cmdline-tools
      fi
    fi
    echo "sdk.dir=$HOME/.android-sdk" > local.properties
  '';
}
