# agi_avdpool_sogis
GRETL-Job für Datenumbau der amtlichen Vermessung von der edit-DB "agi_avdm01avso24" in die sogis-DB "avdpool" 

Git clonen:
```
  git clone https://github.com/bjsvwcur/agi_avdpool_sogis.git
```

Docker Container erstellen mit 2 PostgreSQL DBs edit und Pub. Inkl. Schema agi_dm01avso24_sogis in der Edit-DB.

```
  docker-compose down # (this command is optional; it's just for cleaning up any already existing DB containers)
  docker-compose run --rm --user $UID -v $PWD/development_dbs:/home/gradle/project gretl "sleep 20 && cd /home/gradle && gretl -b project/build-dev.gradle createSchemaLandUsePlans"
```

Schemas (aus Sogis-DB) importieren:
```
Für Test "language plpythonu":
psql -h localhost -p 54322 -d pub -U admin -c "SET ROLE admin" --single-transaction -f ./development_dbs/test.sql 
Alle Schemas:
psql -h localhost -p 54322 -d pub -U admin -c "SET ROLE admin" --single-transaction -f ./development_dbs/sogis-schemas.sql 
```

ENV Variablen auf die "Container"-DB setzen:
```
  export ORG_GRADLE_PROJECT_dbUriEdit="jdbc:postgresql://edit-db/edit"
  export ORG_GRADLE_PROJECT_dbUserEdit="gretl"
  export ORG_GRADLE_PROJECT_dbPwdEdit="gretl"
  export ORG_GRADLE_PROJECT_dbUriPub="jdbc:postgresql://pub-db/pub"
  export ORG_GRADLE_PROJECT_dbUserPub="gretl"
  export ORG_GRADLE_PROJECT_dbPwdPub="gretl"

```

mit ili2pg_4.3.1 Daten importieren (Verzeichnis zu ili2pg im File ili2pg_dataimportEdit_X.sh anpassen):
```
./ili2pg_dataimportEdit_dm01avso24_2493.sh-- Grant privileges on schemas
./ili2pg_dataimportEdit_dm01avso24_2499.sh
psql -h localhost -p 54322 -d pub -U admin -c "SET ROLE admin" --single-transaction -f av_avdpool_ng.dump -f av_avdpool_ng_grants.sql
```

Daten von der Edit-DB in die Pub-DB kopieren
```
sudo -E ../start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network agidm01avso24sogis_default --job-directory /home/bjsvwcur/agi_dm01avso24_sogis/agi_dm01avso24_sogis/
  ```
