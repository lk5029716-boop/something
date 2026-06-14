{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jdk17
    android-tools
  ];
  env = {
    ANDROID_HOME = "$HOME/.android-sdk";
    ANDROID_SDK_ROOT = "$HOME/.android-sdk";
    PATH = "$HOME/.android-sdk/platform-tools:$HOME/.android-sdk/emulator:$PATH";
  };
  shellHook = ''
    mkdir -p $HOME/.android-sdk
    echo "sdk.dir=$HOME/.android-sdk" > local.properties
  '';
}
