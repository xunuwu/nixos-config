{lib, ...}: {
  wireguardPeers = [
    {
      # hopper
      IPs = ["10.0.0.2" "fd12:1e51:ca23::2"];
      PublicKey = ["P5W5/m9VnWcbdR6e3rs4Yars4Qb2rPjkRmCAbgja4Ug="];
      OpenPorts =
        [24001 24002 24003]
        |> map (port: {
          inherit port;
          protocol = "tcp";
        });
    }
    {
      # nixdesk
      IPs = ["10.0.0.3" "fd12:1e51:ca23::3"];
      PublicKey = "DMauL/fv08yXvVtyStsUfg/OM+ZJwMNvguQ59X/KU2Q=";
      OpenPorts =
        lib.range 23000 23010
        |> builtins.concatMap (port: [
          {
            inherit port;
            protocol = "tcp";
          }
          {
            inherit port;
            protocol = "udp";
          }
        ]);
    }
    {
      # alka
      IPs = ["10.0.0.4" "fd12:1e51:ca23::3"];
      PublicKey = "Q90dKQtQTu8RLgkPau7/Y5fY3PVstP0bL6ey3zrdS18=";
      OpenPorts = [
        {
          protocol = "tcp";
          port = 22000;
        }
      ];
    }
    {
      # schoolpc
      IPs = ["10.0.0.5" "fd12:1e51:ca25::5"];
      PublicKey = "XHKbSIf3qsvOFPkLKGspov1o7nAFAvduagdn9w9i+hg=";
      OpenPorts = [];
    }
  ];
}
