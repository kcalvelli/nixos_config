{
  config,
  pkgs,
  ...
}: {
  # PWA Desktop entries
  # If you are not me, do not use this
  xdg.desktopEntries = {
    "brave-aghbiahbpaijignceidepookljebhfak-Default" = {
      name = "Google Drive";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=aghbiahbpaijignceidepookljebhfak";
      icon = "brave-aghbiahbpaijignceidepookljebhfak-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_aghbiahbpaijignceidepookljebhfak";
      };
    };
    "brave-agimnkijcaahngcdmfeangaknmldooml-Default" = {
      name = "YouTube";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml";
      icon = "brave-agimnkijcaahngcdmfeangaknmldooml-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_agimnkijcaahngcdmfeangaknmldooml";
      };
      actions = {
        "Subscriptions" = {
          name = "Subscriptions";
          exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml --app-launch-url-for-shortcuts-menu-item=https://www.youtube.com/feed/subscriptions";
        };
        "Explore" = {
          name = "Explore";
          exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml --app-launch-url-for-shortcuts-menu-item=https://www.youtube.com/feed/explore";
        };
      };
    };
    "brave-ejhkdoiecgkmdpomoahkdihbcldkgjci-Default" = {
      name = "Element";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=ejhkdoiecgkmdpomoahkdihbcldkgjci";
      icon = "brave-ejhkdoiecgkmdpomoahkdihbcldkgjci-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_ejhkdoiecgkmdpomoahkdihbcldkgjci";
      };
    };
    "brave-hpfldicfbfomlpcikngkocigghgafkph-Default" = {
      name = "Messages";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=hpfldicfbfomlpcikngkocigghgafkph";
      icon = "brave-hpfldicfbfomlpcikngkocigghgafkph-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_hpfldicfbfomlpcikngkocigghgafkph";
      };
    };
    "brave-kjgfgldnnfoeklkmfkjfagphfepbbdan-Default" = {
      name = "Google Meet";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=kjgfgldnnfoeklkmfkjfagphfepbbdan";
      icon = "brave-kjgfgldnnfoeklkmfkjfagphfepbbdan-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_kjgfgldnnfoeklkmfkjfagphfepbbdan";
      };
    };
    "brave-mdpkiolbdkhdjpekfbkbmhigcaggjagi-Default" = {
      name = "Google Chat";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=mdpkiolbdkhdjpekfbkbmhigcaggjagi";
      icon = "brave-mdpkiolbdkhdjpekfbkbmhigcaggjagi-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_mdpkiolbdkhdjpekfbkbmhigcaggjagi";
      };
    };
    "brave-mnhkaebcjjhencmpkapnbdaogjamfbcj-Default" = {
      name = "Google Maps";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=mnhkaebcjjhencmpkapnbdaogjamfbcj";
      icon = "brave-mnhkaebcjjhencmpkapnbdaogjamfbcj-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_mnhkaebcjjhencmpkapnbdaogjamfbcj";
      };
    };
    "brave-ncmjhecbjeaamljdfahankockkkdmedg-Default" = {
      name = "Google Photos";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=ncmjhecbjeaamljdfahankockkkdmedg";
      icon = "brave-ncmjhecbjeaamljdfahankockkkdmedg-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_ncmjhecbjeaamljdfahankockkkdmedg";
      };
    };
    "brave-ibblmnobmgdmpoeblocemifbpglakpoi-Default" = {
      name = "Telegram Web";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=ibblmnobmgdmpoeblocemifbpglakpoi";
      icon = "brave-ibblmnobmgdmpoeblocemifbpglakpoi-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_ibblmnobmgdmpoeblocemifbpglakpoi";
      };
    };
    "brave-pkooggnaalmfkidjmlhoelhdllpphaga-Default" = {
      name = "Outlook (PWA)";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga %U";
      icon = "brave-pkooggnaalmfkidjmlhoelhdllpphaga-Default";
      terminal = false;
      type = "Application";
      mimeType = ["x-scheme-handler/mailto"];
      settings = {
        StartupWMClass = "crx_pkooggnaalmfkidjmlhoelhdllpphaga";
        Actions = "New-event;New-message;Open-calendar";
      };
      actions = {
        "New-event" = {
          name = "New event";
          exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga --app-launch-url-for-shortcuts-menu-item=https://outlook.office365.com/calendar/deeplink/compose";
        };
        "New-message" = {
          name = "New message";
          exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga --app-launch-url-for-shortcuts-menu-item=https://outlook.office365.com/mail/deeplink/compose";
        };
        "Open-calendar" = {
          name = "Open calendar";
          exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga --app-launch-url-for-shortcuts-menu-item=https://outlook.office365.com/calendar";
        };
      };
    };
    "brave-cifhbcnohmdccbgoicgdjpfamggdegmo-Default" = {
      name = "Microsoft Teams";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo";
      icon = "brave-cifhbcnohmdccbgoicgdjpfamggdegmo-Default";
      terminal = false;
      type = "Application";
      settings = {
      StartupWMClass = "crx_cifhbcnohmdccbgoicgdjpfamggdegmo";
      };
    };
    "brave-cicjgplghpdkjlhjlppobdmdkjlpfpml-Default" = {
      name = "Sonos";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=cicjgplghpdkjlhjlppobdmdkjlpfpml";
      icon = "brave-cicjgplghpdkjlhjlppobdmdkjlpfpml-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_cicjgplghpdkjlhjlppobdmdkjlpfpml";
      };
    };
    "brave-hkhckfoofhljcngmlnlojcbplgkcpcab-Default" = {
      name = "Proton Pass Web App";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=hkhckfoofhljcngmlnlojcbplgkcpcab";
      icon = "brave-hkhckfoofhljcngmlnlojcbplgkcpcab-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_hkhckfoofhljcngmlnlojcbplgkcpcab";
      };
    };
    "brave-jnpecgipniidlgicjocehkhajgdnjekh-Default" = {
      name = "Proton Mail";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=jnpecgipniidlgicjocehkhajgdnjekh";
      icon = "brave-jnpecgipniidlgicjocehkhajgdnjekh-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_jnpecgipniidlgicjocehkhajgdnjekh";
      };
    };
    "brave-fnnddiokljlbkmeppnclajginnfbffgb-Default" = {
      name = "Proton Drive";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=fnnddiokljlbkmeppnclajginnfbffgb";
      icon = "brave-fnnddiokljlbkmeppnclajginnfbffgb-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_fnnddiokljlbkmeppnclajginnfbffgb";
      };
    };
    "brave-ojibjkjikcpjonjjngfkegflhmffeemk-Default" = {
      name = "Proton Calendar";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=ojibjkjikcpjonjjngfkegflhmffeemk";
      icon = "brave-ojibjkjikcpjonjjngfkegflhmffeemk-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_ojibjkjikcpjonjjngfkegflhmffeemk";
      };
    };
    "brave-kdnccncfodjdpogfgcekohdeabddjfke-Default" = {
      name = "Proton Wallet";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=kdnccncfodjdpogfgcekohdeabddjfke";
      icon = "brave-kdnccncfodjdpogfgcekohdeabddjfke-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_kdnccncfodjdpogfgcekohdeabddjfke";
      };
    };

    "brave-jdklklfpinionkgpmghaghehojplfjio-Default" = {
      name = "Photopea";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=jdklklfpinionkgpmghaghehojplfjio %U";
      icon = "brave-jdklklfpinionkgpmghaghehojplfjio-Default";
      terminal = false;
      type = "Application";
      mimeType = [
        "application/pdf"
        "image/ai"
        "image/bmp"
        "image/cdr"
        "image/eps"
        "image/gif"
        "image/jp2"
        "image/jpeg"
        "image/jpx"
        "image/png"
        "image/psb"
        "image/psd"
        "image/pxd"
        "image/sketch"
        "image/svg+xml"
        "image/tiff"
        "image/vnd-ms.dds"
        "image/webp"
        "image/x-icon"
        "image/x-tga"
        "image/xcf"
        "image/xd"
      ];
      settings = {
        StartupWMClass = "crx_jdklklfpinionkgpmghaghehojplfjio";
      };
    };
    "brave-oijgmambjjhcpfnploolbhpnehlkheid-Default" = {
      name = "Windows App";
      exec = "/run/current-system/sw/bin/brave --profile-directory=Default --app-id=oijgmambjjhcpfnploolbhpnehlkheid";
      icon = "brave-oijgmambjjhcpfnploolbhpnehlkheid-Default";
      terminal = false;
      type = "Application";
      settings = {
        StartupWMClass = "crx_oijgmambjjhcpfnploolbhpnehlkheid";
      };
    };    
  };

  systemd.user.services.clear-pwa-desktop-entries = {
    Unit = {
      Description = "Clear PWA Desktop Entries";
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/rm -f $HOME/.local/share/applications/brave-*.desktop'";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
