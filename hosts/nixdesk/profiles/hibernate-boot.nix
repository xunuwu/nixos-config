{pkgs, ...}: {
  # hibernate and reboot to firmware
  # this allows me to save linux state and boot into another os (such as windows)
  # make sure not to mount any filesystems from the other os or you risk losing data
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "hib-boot" ''
      set -e

      if [ ! -v 1 ]; then
        echo "no argument provided"
        echo "please provide the id for the os you want to boot"
        echo "these are the valid id's:"
        echo ""
        ${pkgs.efibootmgr}/bin/efibootmgr
        exit
      fi

      if [ ! -w /sys/power/disk -o ! -w /sys/power/state ]; then
        echo "you lack permission to write to /sys/power/{disk,state}, are you not running this script as root?"
        exit
      fi

      ${pkgs.efibootmgr}/bin/efibootmgr -n "$1" >/dev/null
      echo reboot >/sys/power/disk
      echo disk >/sys/power/state
    '')
  ];
}
