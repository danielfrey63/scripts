# Scripts Repository 🚀

Eine Sammlung nützlicher Shell-Scripts für verschiedene Aufgaben.

## 🔧 Installation

Nach dem Klonen des Repositories kannst du die Scripts automatisch zu deiner PATH-Variable hinzufügen:

### Automatische Installation
```bash
git clone git@github.com:danielfrey63/scripts.git
cd scripts
./setup.sh
```

### Manuelle Installation
```bash
./setup.sh install
```

### Nach der Installation
```bash
# Shell-Konfiguration neu laden
source ~/.bashrc  # für Bash
# oder
source ~/.zshrc   # für Zsh

# Oder einfach ein neues Terminal öffnen
```

## 📋 Verfügbare Scripts

### `show-users.sh`

### `add-script.sh`
Fügt ein neues Script zum Repository hinzu und pushed es automatisch.

**Features:**
- Kopiert Scripts ins Repository
- Macht sie ausführbar
- Erstellt automatisch Commit-Messages
- Pushed direkt zu GitHub

**Verwendung:**
```bash
./add-script.sh my-script.sh "Beschreibung des Scripts"
./add-script.sh /path/to/script.sh
add-script my-script.sh  # nach Installation
```
Zeigt alle "normalen" Benutzer des Systems mit ihrem Login-Status an.

**Features:**
- Zeigt Online/Offline Status
- Anzahl aktiver Sessions
- Letzte Login-Zeit  
- Formatierte Tabelle

**Verwendung:**
```bash
show-users.sh
# oder nach Installation:
show-users
```

### Weitere Scripts
*Weitere Scripts werden hier dokumentiert, sobald sie hinzugefügt werden.*

## 🛠️ Setup Script Funktionen

Das `setup.sh` Script bietet verschiedene Optionen:

```bash
./setup.sh install    # Scripts zu PATH hinzufügen
./setup.sh uninstall  # Scripts aus PATH entfernen  
./setup.sh status     # Aktuellen Status anzeigen
```

### Was das Setup Script macht:
- ✅ Erkennt automatisch deine Shell (bash/zsh/etc.)
- ✅ Findet die richtige Konfigurationsdatei
- ✅ Erstellt Backups vor Änderungen
- ✅ Macht alle `.sh` Dateien ausführbar
- ✅ Fügt das Scripts-Verzeichnis zu PATH hinzu
- ✅ Unterstützt Installation und Deinstallation

### Sicherheit:
- 📦 **Backups**: Automatische Backups der Shell-Konfiguration
- 🔍 **Erkennung**: Prüft, ob bereits installiert
- 🗑️ **Saubere Deinstallation**: Vollständiges Entfernen möglich

## 🔧 Manuelle PATH Konfiguration

Falls du das Setup Script nicht verwenden möchtest:

### Für Bash (~/.bashrc):
```bash
export PATH="/pfad/zum/scripts:$PATH"
```

### Für Zsh (~/.zshrc):
```bash
export PATH="/pfad/zum/scripts:$PATH"  
```

## 📝 Entwicklung

### Neues Script hinzufügen:
1. Script in das Repository-Verzeichnis legen
2. Ausführbar machen: `chmod +x script.sh`
3. In README dokumentieren
4. Committen und pushen

### Script-Konventionen:
- Dateiname: `script-name.sh`
- Shebang: `#!/bin/bash`
- Dokumentation am Anfang des Scripts
- Fehlerbehandlung implementieren

## 🤝 Beitrag leisten

1. Repository forken
2. Feature Branch erstellen (`git checkout -b feature/amazing-script`)
3. Änderungen committen (`git commit -am 'Add amazing script'`)
4. Branch pushen (`git push origin feature/amazing-script`)
5. Pull Request erstellen

## 📄 Lizenz

Dieses Projekt steht unter der MIT Lizenz - siehe [LICENSE](LICENSE) Datei für Details.

## 🆘 Probleme?

Bei Problemen mit der Installation:

1. **Status prüfen**: `./setup.sh status`
2. **Neuinstallation**: `./setup.sh uninstall && ./setup.sh install`
3. **Manuelle Prüfung**: `echo $PATH | grep scripts`
4. **Shell neustarten**: Neues Terminal öffnen

**Häufige Probleme:**
- Script nicht gefunden → Shell-Konfiguration neu laden
- Berechtigung verweigert → `chmod +x script.sh`
- PATH nicht gesetzt → `./setup.sh status` prüfen
