{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jdk17
    android-tools
    wget
    unzip
  ];
  env = {
    JAVA_HOME = "${pkgs.jdk17}";
    ANDROID_HOME = "$HOME/.android-sdk";
    ANDROID_SDK_ROOT = "$HOME/.android-sdk";
    PATH = "${pkgs.jdk17}/bin:$HOME/.android-sdk/cmdline-tools/latest/bin:$HOME/.android-sdk/platform-tools:$HOME/.android-sdk/emulator:$PATH";
  };
  shellHook = ''
    mkdir -p $HOME/.android-sdk/cmdline-tools/latest
    if [ ! -f "$HOME/.android-sdk/cmdline-tools/latest/bin/sdkmanager" ]; then
      cd /tmp
      wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
      unzip -q commandlinetools-linux-11076708_latest.zip
      cp -r cmdline-tools/* $HOME/.android-sdk/cmdline-tools/latest/ 2>/dev/null || true
      rm -rf cmdline-tools commandlinetools-linux-11076708_latest.zip
      yes | sdkmanager --licenses >/dev/null 2>&1 || true
      sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" >/dev/null 2>&1 || true
    fi
    echo "sdk.dir=$HOME/.android-sdk" > local.properties
  '';
}
