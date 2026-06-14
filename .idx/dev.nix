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
    JAVA_HOME = "${pkgs.jdk17}";
    PATH = "${pkgs.jdk17}/bin:$HOME/.android-sdk/cmdline-tools/latest/bin:$HOME/.android-sdk/platform-tools:$HOME/.android-sdk/emulator:$PATH";
  };
  shellHook = ''
    mkdir -p $HOME/.android-sdk/cmdline-tools
    if [ ! -d "$HOME/.android-sdk/cmdline-tools/latest" ]; then
      cd /tmp
      wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -O cmdline-tools.zip || true
      if [ -f cmdline-tools.zip ]; then
        unzip -q cmdline-tools.zip
        mkdir -p $HOME/.android-sdk/cmdline-tools/latest
        mv cmdline-tools/* $HOME/.android-sdk/cmdline-tools/latest/ 2>/dev/null || true
        rm -rf cmdline-tools.zip cmdline-tools
      fi
      yes | sdkmanager --licenses >/dev/null 2>&1 || true
      sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" >/dev/null 2>&1 || true
    fi
    echo "sdk.dir=$HOME/.android-sdk" > local.properties
  '';
}
