# agi_avdpool_sogis
GRETL-Job für Datenumbau der amtlichen Vermessung von der edit-DB "agi_avdm01avso24" in die sogis-DB "avdpool" 

Git clonen:
```
  git clone https://github.com/bjsvwcur/agi_avdpool_sogis.git
```

1. Docker Container erstellen mit 2 PostgreSQL DBs edit und Pub. Inkl. Schema agi_dm01avso24_sogis in der Edit-DB und Schema avdpool in der Pub-DB.

```
  docker-compose down # (this command is optional; it's just for cleaning up any already existing DB containers)
  docker-compose run --rm --user $UID -v $PWD/development_dbs:/home/gradle/project gretl "sleep 20 && cd /home/gradle && gretl -b project/build-dev.gradle createSchemaLandUsePlans createSchemaLandUsePlansPub"
```

3. ENV Variablen auf die "Container"-DB setzen:
```
  export ORG_GRADLE_PROJECT_dbUriEdit="jdbc:postgresql://edit-db/edit"
  export ORG_GRADLE_PROJECT_dbUserEdit="gretl"
  export ORG_GRADLE_PROJECT_dbPwdEdit="gretl"
  export ORG_GRADLE_PROJECT_dbUriSogis="jdbc:postgresql://pub-db/pub"
  export ORG_GRADLE_PROJECT_dbUserSogis="gretl"
  export ORG_GRADLE_PROJECT_dbPwdSogis="gretl"

```

4. mit ili2pg_4.3.1 Daten importieren (Verzeichnis zu ili2pg im File ili2pg_dataimportEdit_X.sh anpassen):
```
./ili2pg_dataimportEdit_dm01avso24_2493.sh-- Grant privileges on schemas
./ili2pg_dataimportEdit_dm01avso24_2499.sh
```

5. Daten von der Edit-DB in die Pub-DB kopieren
```
sudo -E ../start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network agiavdpoolsogis_default --job-directory /home/bjsvwcur/Meine-Repos/agi_avdpool_sogis/agi_avdpool_sogis/
  ```
