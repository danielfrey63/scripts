# Scripts Repository 🚀

Eine Sammlung nützlicher Shell-Scripts für verschiedene Aufgaben.

## 🔧 Installation

Nach dem Klonen des Repositories kannst du die Scripts automatisch zu deiner PATH-Variable hinzufügen:

### Automatische Installation
```bash
git clone git@github.com:danielfrey63/scripts.git
cd scripts
./setup-scripts.sh
```

### Manuelle Installation
```bash
./setup-scripts.sh install
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

### `setup-scripts.sh`
Das Haupt-Management-Script für das Repository.

**Funktionen:**
- **install**: Scripts zu PATH hinzufügen
- **uninstall**: Scripts aus PATH entfernen  
- **status**: Aktuellen Status anzeigen
- **add**: Neue Scripts hinzufügen und zu GitHub pushen

**Verwendung:**
```bash
./setup-scripts.sh install              # Installation
./setup-scripts.sh status               # Status prüfen
./setup-scripts.sh add script.sh "msg"  # Script hinzufügen
./setup-scripts.sh uninstall            # Deinstallation
```

### `show-users.sh`
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
*Weitere Scripts werden hier automatisch dokumentiert, sobald sie hinzugefügt werden.*

## 🛠️ Script Management

Das `setup-scripts.sh` Script bietet alle notwendigen Funktionen:

```bash
./setup-scripts.sh install           # Scripts zu PATH hinzufügen
./setup-scripts.sh uninstall         # Scripts aus PATH entfernen  
./setup-scripts.sh status            # Aktuellen Status anzeigen
./setup-scripts.sh add <file> [msg]  # Neues Script hinzufügen
```

### Was das Setup Script macht:
- ✅ Erkennt automatisch deine Shell (bash/zsh/etc.)
- ✅ Findet die richtige Konfigurationsdatei
- ✅ Erstellt Backups vor Änderungen
- ✅ Macht alle `.sh` Dateien ausführbar
- ✅ Fügt das Scripts-Verzeichnis zu PATH hinzu
- ✅ Unterstützt Installation und Deinstallation
- ✅ Git-Integration für Script-Management

### Script hinzufügen:
```bash
# Lokales Script hinzufügen
./setup-scripts.sh add my-script.sh "Beschreibung des Scripts"

# Script von anderem Ort hinzufügen
./setup-scripts.sh add /path/to/script.sh

# Interaktive Eingabe der Commit-Message
./setup-scripts.sh add script.sh
```

### Sicherheit:
- 📦 **Backups**: Automatische Backups der Shell-Konfiguration
- 🔍 **Erkennung**: Prüft, ob bereits installiert
- 🗑️ **Saubere Deinstallation**: Vollständiges Entfernen möglich
- 🔒 **Git-Integration**: Versionskontrolle für alle Scripts

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
```bash
# Am einfachsten mit dem Management-Script
./setup-scripts.sh add my-new-script.sh "Fügt neue Funktionalität hinzu"
```

### Script-Konventionen:
- Dateiname: `script-name.sh`
- Shebang: `#!/bin/bash`
- Dokumentation am Anfang des Scripts
- Fehlerbehandlung implementieren

## 🤝 Beitrag leisten

1. Repository forken
2. Feature Branch erstellen (`git checkout -b feature/amazing-script`)
3. Script mit `./setup-scripts.sh add` hinzufügen
4. Pull Request erstellen

## 📄 Lizenz

Dieses Projekt steht unter der MIT Lizenz - siehe [LICENSE](LICENSE) Datei für Details.

## 🆘 Probleme?

Bei Problemen mit der Installation:

1. **Status prüfen**: `./setup-scripts.sh status`
2. **Neuinstallation**: `./setup-scripts.sh uninstall && ./setup-scripts.sh install`
3. **Manuelle Prüfung**: `echo $PATH | grep scripts`
4. **Shell neustarten**: Neues Terminal öffnen

**Häufige Probleme:**
- Script nicht gefunden → Shell-Konfiguration neu laden
- Berechtigung verweigert → `chmod +x script.sh`
- PATH nicht gesetzt → `./setup-scripts.sh status` prüfen

## 🚀 Features

- **🔧 Einfache Installation**: Ein Befehl für alles
- **📦 Script-Management**: Hinzufügen, Entfernen, Status
- **🔄 Git-Integration**: Automatisches Committen und Pushen
- **🛡️ Sicherheit**: Backups und Validierung
- **🎨 Benutzerfreundlich**: Farbige Ausgaben und klare Meldungen
- **🔀 Multi-Shell**: Unterstützt bash, zsh und andere Shells
