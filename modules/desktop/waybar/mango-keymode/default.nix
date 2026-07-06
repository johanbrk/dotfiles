{...}: {
  modules.waybar.home = {pkgs, lib, ...}: {
    options.waybar.mangoKeymode = lib.mkOption {
      type = lib.types.package;
      default = (pkgs.runCommand "mmsgKeymode"
        { nativeBuildInputs = [ pkgs.stdenv.cc ]
        ; MMSG_PATH = "${pkgs.mango}/bin/mmsg";
        } ''
          mkdir -p $out/bin
          ${pkgs.rustc}/bin/rustc \
            -C opt-level=s \
            -C target-cpu=native \
            -C panic=abort \
            -C lto=fat \
            -C codegen-units=1 \
            -C strip="symbols" \
            ${./keymodeIPC.rs} -o $out/bin/mmsgKeymode
        '');
    };
  };
}
