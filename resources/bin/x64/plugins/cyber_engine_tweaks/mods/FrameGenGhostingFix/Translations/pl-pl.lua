local translation = {
  __VERSION = { 5, 0, 0 },
  __AUTHOR = "Testing Translation System",
  UIText = {
    General = {
      title_general = "Ustawienia ogolne:",
      title_fps90 = "Ustawienia dla 90+ FPS FG ON:",
      title_fps100 = "Ustawienia dla 100+ FPS FG ON:",
      title_fps120 = "Ustawienia dla 120+ FPS FG ON:",
      yes = "Tak",
      no = "Nie",
      apply = "Zastosuj",
      cancel = "Anuluj",
      default = "Ustaw domyslne",
      disabled = "Wylaczone",
      enabled = "Wlaczone",
      presets_comboBox = "Uzyj tego presetu:",
      presets_comboBox_tooltip = "Wybierz preset anty-ghostingu.",
      save = "Zapisz",
      settings_loaded = "Wczytano ustawienia uzytkownika.",
      settings_loaded_preset = "Wczytano preset",
      settings_applied_veh = "[ ! ] Zastosowano wybrany preset.",
      settings_restored = "Przywrocono poprzednie ustawienia.",
      settings_load = "Wczytaj ustawienia",
      settings_save = "Zapisz ustawienia",
      settings_saved = "[ ! ] Twoje ustawienia zostana zapisane.",
      settings_applied_onfoot = "[ ! ] Wyciagnij ponownie bron, aby zaakceptowac zmiany.",
      settings_default = "Przywrocono ustawienia domyslne.",
      info_getOut = "[ ! ] V musi wyjsc z pojazdu, aby dostosowac ta opcje.",
      info_getIn = "[ ! ] V musi byc w pojezdzie, aby dostosowac ta opcje.",
      info_aimOnFoot = "[ ! ] Mozesz wlaczyc tylko jedna funkcje celowania/blokowania naraz.",
      info_diagnostics = "Wykryto potencjalne konflikty z innymi modami.",
      info_modNotReady = "[ ! ] Mod nie dziala. Sprawdz logi, aby uzyskac szczegoly...",
      info_version = "Wersja moda:",
      info_vectorsMissing = "Nie znaleziono kompatybilnego modulu 'Vectors'.",
      info_frameGenStatus = "Status Generowania klatek:",
      info_frameGenOff = "[ ! ] Generowanie klatek jest wylaczone w ustawieniach gry. Maskowanie ghostingu jest wylaczone.",
      info_noMaskingOnFoot = "[ ! ] Maskowanie ghostingu dla FPP poza pojazdami jest globalnie wylaczone.",
      info_noMaskingVehicles = "[ ! ] Maskowanie ghostingu dla pojazdow jest globalnie wylaczone.",
    },
    Info = {
      tabname = "Informacje",
      aspectRatioChange = "[ ! ] Proporcje ekranu ulegly zmianie.\n\nProsze zrestartowac gre, aby upewnic sie, ze mod\nbedzie dzialal prawidlowo.",
      benchmark = "[ ! ] FrameGen Ghosting 'Fix' przeprowadza test wydajnosci\ntwojej gry. Prosze grac swobodnie: po zakonczeniu testu,\nmod zastosuje optymalne ustawienia dla wydajnosci twojej\ngry. Mozesz pozniej zmienic te ustawienia.\n\nTest jest przeprowadzany podczas pierwszego uruchomienia moda.",
      benchmarkAsk = "[ ! ] Czy chcesz przeprowadzic test wydajnosci, aby mod\nmogi zmierzyc wydajnosc twojej gry i ustawic optymalne\nustawienia anty-ghostingu?\n\nOdbedzie sie to w tle, prosze grac swobodnie.",
      modNotReady = "Mod napotkal problem:",
    },
    Vehicles = {
      tabname = "Pojazdy",
      MaskingPresets = {
        name = "Uzyj tego presetu dla pojazdow:",
        tooltip = "Wybierz preset anty-ghostingu dla pojazdow.",
        description = "Informacje o presecie:",
        author = "Autor presetu:",
      },
      Windshield = {
        name = "Dostosuj maske przedniej szyby motocykla",
        tooltip = "Umozliwia dostosowanie maski anty-ghostingu, aby zatrzymac generowanie\nklatek lokalnie wokol przedniej szyby podczas jazdy motocyklem.",
        textfield_1 = "Ponizsze suwaki pozwalaja dostosowac rozmiar maski przedniej\nszyby motocykla. Zwykle nie jest to konieczne, moze okazac sie\nprzydatne dla niektorych motocykli, takich jak Apollo.",
        setting_1 = "Szerokosc maski anty-ghostingu przedniej szyby:",
        setting_2 = "Wysokosc maski anty-ghostingu przedniej szyby:",
        comment_1 = "Skaluj szerokosc",
        comment_2 = "Skaluj wysokosc",
        warning = "V musi siedziec na nieruchomym motocyklu w perspektywie\npierwszej osoby, aby edytowac ta opcje."
      }
    },
    OnFoot = {
      tabname = "Pieszo",
      BottomCornersMasks = {
        name = "Wlacz maski anty-ghostingu w dolnych rogach",
        tooltip = "Wlacza stale maski anty-ghostingu, aby zatrzymac generowanie klatek\nlokalnie wokol dolnych rogow ekranu i zredukowac ghosting,\ngdy V trzyma bron.",
      },
      VignetteAim = {
        name = "Wlacz winietowanie anty-ghostingu dla celowania/blokowania",
        tooltip = "Wlacza dynamiczne winietowanie anty-ghostingu, aby zatrzymac\ngenerowanie klatek lokalnie wokol krawedzi ekranu i zredukowac\nghosting, gdy V celuje/blokuje bronia. Dla klatek nizszych niz\nzalecane, to ustawienie moze wplynac na postrzegana plynnosc\nw skrajnych obszarach pola widzenia.",
        textfield_1 = "[ ! ] Wlaczenie obu opcji winietowania jednoczesnie moze\npowodowac bardziej zauważalne przyciemnienie wokol krawedzi ekranu."
      },
      Vignette = {
        name = "Wlacz konfigurowalne winietowanie anty-ghostingu",
        tooltip = "Wlacza konfigurowalne winietowanie anty-ghostingu, aby zatrzymac\ngenerowanie klatek lokalnie wokol krawedzi ekranu i zredukowac ghosting,\ngdy V trzyma bron.",
        textfield_1 = "Ponizsze suwaki pozwalaja dostosowac wymiary winiety,\naby pokryc ghosting na krawędziach ekranu. Dla klatek\nnizszych niz zalecane, te ustawienia moga wplynac na\npostrzegana plynnosc w skrajnych obszarach pola widzenia.",
        setting_1 = "Szerokosc winiety:",
        setting_2 = "Wysokosc winiety:",
        setting_3 = "Pozioma pozycja winiety:",
        setting_4 = "Pionowa pozycja winiety:"
      },
      VignettePermament = {
        name = "Pozostaw winiete wlaczona, gdy V chowa bron",
        tooltip = "Domyslnie winieta znika, gdy V chowa bron.\nTo ustawienie pozwala utrzymac winiete wlaczona\nprzez caly czas, gdy V jest pieszo."
      },
      BlockerAim = {
        name = "Wlacz blokowanie generowania klatek dla celowania/blokowania",
        tooltip = "Wlacza kontekstowe blokowanie generowania klatek\ndla calego ekranu, gdy V celuje/blokuje bronia. Moze to\nbyc pomocne przy wyzszych klatek na sekunde, poniewaz celowniki\nmaja tendencje do silnego ghostingu przy wlaczonym generowaniu klatek."
      }
    },
    Contextual = {
      tabname = "Kontekstowe",
      requirement = 'Prosze zaznaczyc "Wlacz generowanie klatek" w zakladce "Ustawienia", aby uzyc tych funkcji.',
      info = "Wybierz konteksty, aby wylaczyc generowanie klatek podczas tych zdarzen.",
      groupOther = "Inne:",
      groupOnFoot = "Pieszo:",
      groupVehicles = "Pojazdy:",
      onFootStanding = "Stanie",
      onFootSlowWalk = "Powolny chod",
      onFootWalk = "Chodzenie",
      onFootSprint = "Sprint",
      onFootSwimming = "Plywanie",
      vehiclesStatic = "Statycznie",
      vehiclesDriving = "Jazda",
      vehiclesStaticWeapon = "Statycznie (z bronia)",
      vehiclesDrivingWeapon = "Jazda (z bronia)",
      braindance = "Braindance",
      cinematics = "Przerywniki filmowe",
      combat = "Walka (Wrogowie zaalarmowani)",
      photoMode = "Tryb fotograficzny",
    },
    Settings = {
      tabname = "Ustawienia",
      groupMod = "Ustawienia moda:",
      enabledDebug = "Wlacz tryb debugowania",
      enabledDebugView = "Wlacz widok debugowania w oknie",
      enabledHelp = "Wlacz podpowiedzi",
      tooltipHelp = "Wlacz podpowiedzi po najechaniu myszka na niektore ustawienia.",
      enabledWindow = "Utrzymuj to okno otwarte",
      tooltipWindow = "Utrzymuj to okno otwarte po zamknieciu nakladki CET.",
      selectTheme = "Motyw okna moda:",
      tooltipTheme = "Wybierz kolory dla okna moda.",
      groupFG = "Ustawienia generowania klatek:",
      enableFG = "Wlacz generowanie klatek",
      tooltipFG = "Wlacz/wylacz generowanie klatek na poziomie moda (ustawienia gry pozostaja niezmienione).",
      gameSettingsFG = "[ ! ] Upewnij sie, ze generowanie klatek jest zawsze wlaczone w menu gry, aby to dzialalo poprawnie.",
      gameNotReadyWarning = "[ ! ] Musisz uruchomic lub wznowic gre, aby zmienic te ustawienia.",
    },
    Benchmark = {
      groupBenchmark = "Test wydajnosci gry:",
      currentFps = "Aktualne FPS bez generowania klatek:",
      currentFrametime = "Aktualny czas klatki bez generowania klatek (ms):",
      averageFps = "Srednie FPS bez generowania klatek:",
      benchmark = "Test wydajnosci wlaczony:",
      benchmarkRemaining = "Pozostaly czas testu (s):",
      benchmarkPause = "[ ! ] Test wstrzymany. Wznow gre, aby kontynuowac.",
      benchmarkPauseOverlay = "[ ! ] Test wstrzymany. Wyjdz z nakladki CET, aby kontynuowac.",
      benchmarkRestart = "[ ! ] Restart testu za:",
      benchmarkRun = "Uruchom test",
      benchmarkSetSuggestedSettings = "Ustaw sugerowane ustawienia",
      benchmarkRevertSettings = "Przywroc moje ustawienia",
      benchmarkStop = "Zatrzymaj test",
      benchmarkEnabled = "Test wydajnosci wlaczony.",
      benchmarkFinished = "Test wydajnosci zakonczony.",
      tooltipRunBench = "Uruchamia test wydajnosci gry i stosuje sugerowane ustawienia\npo zakonczeniu. Po zakonczeniu mozesz przejrzec nowe ustawienia\ni w razie potrzeby przywrocic swoje aktualne."
    },
    Diagnostics = {
      tabname = "Diagnostyka",
      title_warning = "WYKRYTO KONFLIKTY Z INNYMI MODAMI",
      title_info = "DOSTEPNA AKTUALIZACJA",
      textfield_1 = "Wyglada na to, ze masz zainstalowany konfliktujacy mod.\n\nAby upewnic sie, ze anty-ghosting dla generowania klatek\nbedzie dzialal bez problemow, odwiedz strone Nexus moda\nFrameGen Ghosting 'Fix', aby pobrac i zainstalowac najnowsza wersje moda.",
      textfield_2 = "Konfliktujace mody:",
      textfield_3 = "Wyglada na to, ze masz zainstalowany potencjalnie\nkonfliktujacy mod.\n\nAby upewnic sie, ze anty-ghosting dla generowania klatek\nbedzie dzialal bez problemow w przyszlosci, odwiedz strone\nNexus moda FrameGen Ghosting 'Fix', aby pobrac i zainstalowac\nnajnowsza wersje moda.\n\nZ nowa wersja nie potrzebujesz juz zadnych\ndostosowa kompatybilnosci.",
      textfield_4 = "Potencjalnie konfliktujace mody:"
    },
  },
  PresetsList = {
    --[=====[
    Presets are saved using IDs, to translate a preset you need the ID of it. The structure looks like following
    [PresetID] = {
      PresetInfo = {
        name = "Preset's name",
        description = "Preset's description"
      }
    }

    IDs have to be covered by brackets [], else your translation will fail!
    To find the ID of a preset just ask the author or take a look at the website were it'S been published.
    --]=====]
    a000 = {
      PresetInfo = {
        name = "Dostosuj",
        description = "Dostosuj swoj preset.",
      }
    },
    a001 = {
      PresetInfo = {
        name = "Domyslny",
        description = "Preset domyslny.",
      }
    },
    a002 = {
      PresetInfo = {
        name = "Mocniejszy",
        description = "Sila anty-ghostingu masek jest nieco wieksza,\na opoznienie zmiany ich stanu przy naglym\nzmniejszeniu predkosci jest dwukrotnie dluzsze\n(3 sekundy zamiast 1.5).",
      }
    },
    a003 = {
      PresetInfo = {
        name = "Testowy",
        description = "Preset testowy, wszystkie maski widoczne.",
      }
    },
    a004 = {
      PresetInfo = {
        name = "Testowy Mocniejszy",
        description = "Testowy preset 'Mocniejszy', wszystkie maski widoczne. Normalizacja przezroczystosci nie dziala w tym presecie (Maski sa widoczne caly czas).",
      }
    },
    a005 = {
      PresetInfo = {
        name = "Wylacz maskowanie anty-ghostingu",
        description = "Wylacza maski anty-ghostingu TPP i FPP dla wszystkich pojazdow.",
      }
    }
  },
}

return translation