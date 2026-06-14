{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jdk17
    android-tools
    android-sdk
    android-platform-tools
    android-ndk
  ];
  env = {
    ANDROID_HOME = "${pkgs.android-sdk}";
    ANDROID_SDK_ROOT = "${pkgs.android-sdk}";
    PATH = "${pkgs.android-sdk}/platform-tools:${pkgs.android-sdk}/emulator:${pkgs.android-tools}/bin:${pkgs.jdk17}/bin:$PATH";
  };
  shellHook = ''
    mkdir -p $HOME/.android
    echo "sdk.dir=${pkgs.android-sdk}" > local.properties
  '';
}
