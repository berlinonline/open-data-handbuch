---
title: SimpleSearch API
path: /simplesearch-api
---

[SimpleSearch-Anwendungen](https://support.berlin.de/wiki/SimpleSearch) machen einen tabellarischen Datenbestand (die „SimpleSearch-Tabelle“) auf einer Webseite durchsuchbar.
Dabei bildet jede Zeile der Tabelle einen Eintrag bzw. ein Datenobjekt ab, während die Spalten der Tabelle die verschiedenen Eigenschaften der Objekte definieren.

So sind z.B. in der SimpleSearch-Anwendung [Liste der Badestellen](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/) die Datenobjekte (also Zeilen) die einzelnen Badestellen.
Eigenschaften wie Name, Ort, Wasserqualität etc. werden über die Spalten abgebildet.

id | badname | bezirk | cb | eco | ente | sicht | temp | profil | …
-- | ------- | ------ | -- | --- | ---- | ----- | ---- | ------ | ---
… | … | … | … | … | … | … | … | … | …
48 | Heiligensee, Freibad | Reinickendorf | <300 | 30 | 390 | 150 | 22,1 | Heiligensee | …
51 | Jungfernheide, Freibad | Charlottenburg-Wilmersdorf | <300 | 61 | 30 | >180 | 20,8 | Jungfernheideteich | …
54 | Kleine Badewiese | Spandau | <300 | <15 | <15 | >50 | 21,1 | Unterhavel | …
… | … | … | … | … | … | … | … | … | …

Typische Bestandteile einer SimpleSearch-Anwendung sind das Suchformular, Detailseiten, Karten etc.
Jede SimpleSearch-Anwendung verfügt außerdem über eine einfache REST-API.
Damit kann der Datenbestand in verschiedenen strukturierten, maschinenlesbaren Formaten abgefragt werden.

Wie Anfragen bzw. Requests an die API einer SimpleSearch-Anwendung fomuliert werden, wird in der folgenden Dokumentation beschrieben.

## Anfrage / Request

### URLs

#### `BASE_URL`

Um die API einer beliebigen SimpleSearch-Anwendung zu nutzen, braucht man zunächst die URL ihrer Startseite (`BASE_URL`).
Für das Beispiel der Liste der Badestellen ist die `BASE_URL` also:
[https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/)

#### `API_ENDPOINT`

Aus der `BASE_URL` ergibt sich der `API_ENDPOINT` durch Anhängen von `index.php`: `${BASE_URL}/index.php`.
Der API-Endpunkt ist der Einstieg für alle API-Anfragen.
Für das Beispiel ist der `API-ENDPOINT`:
[https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php)


#### Dokumentation

Ausgehend  vom `API_ENDPOINT` kann man eine detaillierte Dokumentation spezifisch für jede SimpleSearch-Anwendung aufrufen. Dies geschieht nach dem Muster `${API_ENDPOINT}/api`.
Für die Badestellen-SimpleSearch wird die API-Dokumentation also über folgenden Link erreicht:
[https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/api](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/api)

Insbesondere für die veränderlichen Teile einer SimpleSearch-Anwendung – welche Spalten/Felder sind in der SimpleSearch-Tabelle enthalten – ist die Dokumentation hilfreich.
Die Felder der Tabelle können aber auch explorativ in der Anwendung selbst ermittelt werden.
Dazu geht man wie folgt vor:

1. Rufen Sie die Anwendung, für die Sie sich interessieren, in Ihrem Browser auf, z.B. die [Liste der Badestellen](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen).
1. Stellen Sie eine Anfrage über das Suchformular.
1. Die URL der Ergebnisseite enthält die möglichen URL-Parameter für die verschiedene Felder der SimpleSearch-Tabelle.

#### Übersicht URLs

Was | Muster | Beispiel
---------|----------|---------
`BASE_URL` | (URL der Anwendung) | [https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/)
`API_ENDPOINT` | `${BASE_URL}/index.php` | [https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php)
API-Dokumentation | `${API_ENDPOINT}/api` | [https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/api](https://www.berlin.de/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/api)

### Methoden

Alle SimpleSearch-Anwendungen erlauben über ihre API Suchanfragen mit der Methode [`index`](#index).
Zusätzlich können die Redakteur\*innen Detailansichten freischalten, die dann über die Methode [`detail`](#detail) abrufbar sind.
Beide Methoden bieten Ausgaben in verschiedenen Formaten, wobei das Default-Format jeweils HTML ist.
Die HTML-Ausgaben sind vollständige HTML-Dokumente mit Header, Footer etc. im aktuellen berlin.de-Layout, und daher nur bedingt für externe Nutzer*innen sinnvoll einsetzbar.

#### `index`

Mit der `index`-Methode kann man eine Suchabfrage über den Datenbestand einer SimpleSearch-Anwendung durchführen und das Ergebnis im gewünschten Format erhalten.
Die Rückgabe erfolgt dabei entweder aufgeteilt in Seiten (paginiert) oder komplett (wenn möglich).
Die Struktur eines `index`-Aufrufs ist wie folgt:

```bash
${API_ENDPOINT}/index/${PAGINATION_MODE}[.${FORMAT}]?${QUERY_STRING}
```

##### `PAGINATION_MODE`

`index` \| `all`

`PAGINATION_MODE` ist entweder `index` für die seitenweise Ausgabe der Ergebnisse, oder `all`, um den gesamten Datenbestand auf ein Mal anzufordern.
`all`  funktioniert nur, wenn der Datenbestand nicht zu groß ist.
Ansonsten wird die Fehlermeldung _"ERROR - Zu viele Daten, bitte benutzen Sie die Blätter-Funktion"_ zurückgegeben (der genaue Kontext der Fehlermeldung hängt vom Ausgabeformat ab).
In diesem Fall muss der `index`-Modus genutzt werden.

##### `FORMAT`

Jede SimpleSearch-Anwendung kann über die `index`-Methode folgende Formate exportieren:

| [JSON](#json-format-index) | `.json` |
| [XML](#xml-format-index) | `.xml` |
| [CSV](#csv-format-index) | `.csv` |
| [RSS](#rss-format-index) | `.rss` |
| [JSON-RSS](#json-rss-format-index) | `.jrss` |
| HTML (default) | `.html` |

SimpleSearch-Anwendungen mit Geo-Daten und aktivierter Karte können zusätzlich folgende Geo-Formate zurückgeben:

| [GeoJSON](#geojson-format-index) | `.geojson` |
| [KML](#kml-format-index) | `.kml` |


##### `QUERY_STRING`

Über den Query-String kann die Abfrage eingeschränkt oder anders manipuliert werden.
Die folgenden Query-Parameter werden von allen SimpleSearch-Anwendungen angeboten:

| Parameter | Beschreibung | Beispiel |
| `q` | Ermöglicht eine Volltextsuche über bestimmte Felder des Datenbestands. Welche Felder genau von der Volltextsuche erfasst werden, muss in der API-Dokumentation der jeweiligen Anwendung nachgesehen werden. Default ist `q=`. | `q=`, `q=see`|
| `page` | Gibt an, welche Seite der paginierten Ausgabe gewünscht ist. Nur sinnvoll im Kombination mit `PAGINATION_MODE` `index`. Default ist `page=1`. | `page=2` |
| `order` | Gibt an, welche Felder für die Sortierung der Ergebnisse genutzt weden sollen. Der Zusatz von `ASC`ending und `DESC`ending ist möglich. Welche Felder möglich sind, muss in der API-Dokumentation der jeweiligen Anwendung nachgesehen werden. Default ist `order=id+ASC`. | `order=bezirk`, `order=bezirk+DESC,badname+ASC` |

SimpleSearch-Anwendungen mit Geo-Koordinaten bieten außerdem die Möglichkeit, über `q_geo` und `q_radius` eine adressbasierte Suche durchzuführen.

Zudem werden i.d.R. auch die weiteren Spalten bzw. Felder der SimpleSearch-Tabelle als Query-Parameter zu nutzen (z.B. `?bezirk=Spandau`).
Welche zusätzlichen Parameter verfügbar sind, lässt sich in der API-Dokumentation der jeweiligen Anwendung nachlesen.

#### `detail`

Mit der `detail`-Methode kann man (wenn ihre Nutzung freigeschaltet wurde) einzelne Einträge des Datenbestandes aufrufen.

```bash
${API_ENDPOINT}/detail/${ITEM_ID}[.${FORMAT}]
```

Ein Beispiel für den Aufruf der `detail`-Methode ist:


##### `ITEM_ID`

Referenz auf die `id`-Spalte der SimpleSearch-Tabelle, die als eindeutiger Identifier dient.

##### `FORMAT`

Jede SimpleSearch-Anwendung kann über die `detail`-Methode folgende Formate exportieren:

| [JSON](#json-format-detail) | `.json` |
| [XML](#xml-format-detail) | `.xml` |


### Einschränkung

Bitte beachten Sie, dass die REST-APIs an der SimpleSearch keine Hochleistungs-APIs sind. Wir bitten also um Caching.

## Rückgabe / Response

### Allgemeine Struktur

Die JSON- und XML-Rückgabeformate haben grundsätzlich diesselbe Struktur:

* `messages`:
  * `messages`: Eine Liste von Meldungen. Bei erfolgreicher Ausführung leer.
  * `success`: Boolean mit Status der Ausführung. Bei `false` ist ein Fehler aufgetreten.
* `results`:
  * `count`: Anzahl der Gesamtergebnisse
  * `items_per_page`: Anzahl der Einträge pro Seite
* `index`: Liste mit Ergebnissen, wenn die `index`-Methode genutzt wurde.
  * Ergebnis 1: Jedes Ergebnis ist ein Objekt mit Attribut-Wert-Paaren.
  Es ist immer mindestens ein `id`-Attribut vorhanden, über das die Objekte in der Datenbank der Anwendung fortlaufend durchnummeriert sind. Das `id`-Attribut wird von der SimpleSearch-Anwendung automatisch vergeben und ist nicht unter der Kontrolle der veröffentlichenden Stelle.
  Die übrigen Attribute ergeben sich aus der jeweiligen SimpleSearch-Anwendung und müssen dort in Erfahrung gebracht werden.
  * Ergebnis 2
  * Ergebnis 3
  * ...
* `item`: Objekt mit den Daten eines einzelnen Eintrags, wenn die `detail`-Methode genutzt wurde.

### JSON-Format (index)

**Request-URI** | `${API_ENDPOINT}/index/index.json?${QUERY_STRING}`
**Response content-type** | `application/json; charset=UTF-8`

Das von SimpleSearch über die API ausgelieferte JSON folgt der [allgemeinen Struktur](#struktur-der-rückgabeformate) wie oben beschrieben.

Konkret sieht die JSON-Struktur am Beispiel des [Aktenplans der Senatsverwaltung für Finanzen](https://daten.berlin.de/datensaetze/aktenplan-der-senatsverwaltung-für-finanzen) folgendermaßen aus:

```json
{
  "messages": {
    "messages": [],
    "success": null
  },
  "results": {
    "count": 15805,
    "items_per_page": 20
  },
  "index": [
    {
      "id": 37658,
      "teilaktenplan": "TLSD - Tarifreferat Lohnsteuer/Sozialversicherung/Diverses",
      "aktenplannummer": "Beschaffungsmaßnahmen zur Errichtung von Schießständen für die Zollverwaltung",
      "aktentitel": "Wehrpflicht",
      "aufbewahrungsfrist_jahre": "10"
    },
    {
      "id": 2,
      "teilaktenplan": "BT - Beteiligungen des Landes Berlin",
      "aktenplannummer": "BT",
      "aktentitel": "Beteiligungen des Landes Berlin",
      "aufbewahrungsfrist_jahre": "10"
    },
    {
      "id": 5,        
      "teilaktenplan": "BT - Beteiligungen des Landes Berlin",
      "aktenplannummer": "BT 0",
      "aktentitel": "Verwaltung von Beteiligungen",
      "aufbewahrungsfrist_jahre": "10"
    },
    ...
  ],
  "item": []
}
```

### XML-Format (index)

**Request-URI** | `${API_ENDPOINT}/index/index.xml?${QUERY_STRING}`
**Response content-type** | `text/xml; charset=UTF-8`

Das von SimpleSearch über die API ausgelieferte XML folgt der [allgemeinen Struktur](#struktur-der-rückgabeformate) wie oben beschrieben.

Konkret sieht die XML-Struktur am Beispiel des [Aktenplans der Senatsverwaltung für Finanzen](https://daten.berlin.de/datensaetze/aktenplan-der-senatsverwaltung-für-finanzen) folgendermaßen aus:

```xml
<?xml version="1.0"?>
<xml xmlns="https://www.berlinonline.net/#xmlify" xmlns:xlink="http://www.w3.org/1999/xlink">
  <messages>
    <messages/>
    <success/>
  </messages>
  <results>
    <count>15805</count>
    <items_per_page>20</items_per_page>
  </results>
  <index type="array">
    <item original="0">
      <id>37658</id>
      <teilaktenplan><![CDATA[TLSD - Tarifreferat Lohnsteuer/Sozialversicherung/Diverses]]></teilaktenplan>
      <aktenplannummer><![CDATA[Beschaffungsmaßnahmen zur Errichtung von Schießständen für die Zollverwaltung]]></aktenplannummer>
      <aktentitel><![CDATA[Wehrpflicht]]></aktentitel>
      <aufbewahrungsfrist_jahre>10</aufbewahrungsfrist_jahre>
    </item>
    <item original="1">
      <id>2</id>
      <teilaktenplan><![CDATA[BT - Beteiligungen des Landes Berlin]]></teilaktenplan>
      <aktenplannummer><![CDATA[BT]]></aktenplannummer>
      <aktentitel><![CDATA[Beteiligungen des Landes Berlin]]></aktentitel>
      <aufbewahrungsfrist_jahre>10</aufbewahrungsfrist_jahre>
    </item>
    <item original="2">
      <id>5</id>
      <teilaktenplan><![CDATA[BT - Beteiligungen des Landes Berlin]]></teilaktenplan>
      <aktenplannummer><![CDATA[BT 0]]></aktenplannummer>
      <aktentitel><![CDATA[Verwaltung von Beteiligungen]]></aktentitel>
      <aufbewahrungsfrist_jahre>10</aufbewahrungsfrist_jahre>
    </item>
    <!-- ... -->
  </index>
  <item/>
</xml>
```

### CSV-Format (index)


**Request-URI** | `${API_ENDPOINT}/index/index.csv?${QUERY_STRING}`
**Response content-type** | `application/csv`

Das CSV-Format gibt die Ergebnisse der Anfrage als `;`-separiertes CSV zurück.

Konkret sieht die CSV-Rückgabe am Beispiel des [Aktenplans der Senatsverwaltung für Finanzen](https://daten.berlin.de/datensaetze/aktenplan-der-senatsverwaltung-für-finanzen) folgendermaßen aus:

```csv
id;teilaktenplan;aktenplannummer;aktentitel;aufbewahrungsfrist_jahre
37658;"TLSD - Tarifreferat Lohnsteuer/Sozialversicherung/Diverses";"Beschaffungsmaßnahmen zur Errichtung von Schießständen für die Zollverwaltung";Wehrpflicht;10
2;"BT - Beteiligungen des Landes Berlin";BT;"Beteiligungen des Landes Berlin";10
5;"BT - Beteiligungen des Landes Berlin";"BT 0";"Verwaltung von Beteiligungen";10
...
```

Die Rückgabe besteht aus einer Header-Zeile sowie den Ergebniszeilen.
Auch hier ist wieder mindestens die Spalte `id` enthalten, alle anderen Spalten ergeben sich aus der jeweiligen SimpleSearch-Anwendung und müssen dort in Erfahrung gebracht werden.

### RSS-Format (index)

**Request-URI** | `${API_ENDPOINT}/index/index.rss?${QUERY_STRING}`
**Response content-type** | `text/xml; charset=UTF-8`

Die SimpleSearch-API bietet auch einen Feed im [RSS 2.0](https://www.rssboard.org/rss-specification)-Format an.

Die konkrete Rückgabe sieht am Beispiel des [Aktenplans der Senatsverwaltung für Finanzen](https://daten.berlin.de/datensaetze/aktenplan-der-senatsverwaltung-für-finanzen) folgendermaßen aus:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:georss="http://www.georss.org/georss">
    <channel>
        <title>Aktenplan der Senatsverwaltung für Finanzen</title>
        <description>Ein Aktenplan ist die Regelung der systematischen Ordnung des gesamten Schriftgutes einer Verwaltung. Ziel des Aktenplanes ist die übersichtliche, nachvollziehbare und wirtschaftliche Ordnung des Schriftgutes.&#10;&#10;Dieser Aktenplan basiert auf der Grundlage des Aktenplans für die Finanzverwaltung. Es wurden themenspezifische Teilaktenpläne ergänzt.</description>
        <link>https://www.berlin.de/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php</link>
        <managingEditor>&#60;a href=&#34;aktenplan@senfin.berlin.de&#34; &#62;aktenplan@senfin.berlin.de&#60;/a&#62; (Berlin.de - Aktenplan der Senatsverwaltung für Finanzen)</managingEditor>
        <language>de</language>
        <atom:link href="/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/index.rss?page=1&#38;q=" rel="self" type="application/rss+xml" />
        <atom:link href="/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/static.opensearch" rel="search" type="application/opensearchdescription+xml"/>
        <opensearch:itemsPerPage>20</opensearch:itemsPerPage>
        <opensearch:startIndex>1</opensearch:startIndex>
        <opensearch:Query role="request" searchTerms="" startPage="1" />
        <opensearch:totalResults>15805</opensearch:totalResults>
        <item>
            <guid isPermaLink="false">/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/detail/47414</guid>
            <title>47414</title>
            <link>/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/?id=47414&#38;q=</link>
            <description><![CDATA[
                ]]></description>
        </item>
        <item>
            <guid isPermaLink="false">/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/detail/47411</guid>
            <title>47411</title>
            <link>/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/?id=47411&#38;q=</link>
            <description><![CDATA[
                ]]></description>
        </item>
        <item>
            <guid isPermaLink="false">/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/detail/47408</guid>
            <title>47408</title>
            <link>/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/?id=47408&#38;q=</link>
            <description><![CDATA[
                ]]></description>
        </item>
        <!-- weitere items -->
    </channel>
</rss>
```

### JSON-RSS-Format (index)

**Request-URI** | `${API_ENDPOINT}/index/index.jrss?${QUERY_STRING}`
**Response content-type** | `application/rss+json; charset=UTF-8`

Alternativ zum XML-basierten [RSS-Format](#rss-format) bietet die SimpleSearch-API auch einen JSON-basierten Feed.

Die konkrete JSON-Rückgabe sieht am Beispiel des [Aktenplans der Senatsverwaltung für Finanzen](https://daten.berlin.de/datensaetze/aktenplan-der-senatsverwaltung-für-finanzen) folgendermaßen aus:

```json
{
    "version": "2.0",
    "channel": {
        "title": "Aktenplan der Senatsverwaltung für Finanzen",
        "link": "https://www.berlin.de/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php",
        "description": "Ein Aktenplan ist die Regelung der systematischen Ordnung des gesamten Schriftgutes einer Verwaltung. Ziel des Aktenplanes ist die übersichtliche, nachvollziehbare und wirtschaftliche Ordnung des Schriftgutes.\n\nDieser Aktenplan basiert auf der Grundlage des Aktenplans für die Finanzverwaltung. Es wurden themenspezifische Teilaktenpläne ergänzt.",
        "managingEditor": "<a href=\"aktenplan@senfin.berlin.de\" >aktenplan@senfin.berlin.de</a> (Berlin.de - Aktenplan der Senatsverwaltung für Finanzen)",
        "language": "de",
        "items": [
            {
                "title": 47414,
                "link": "/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/?id=47414&q=",
                "guid": "/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/detail/47414"
            },
            {
                "title": 47411,
                "link": "/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/?id=47411&q=",
                "guid": "/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/detail/47411"
            },
            {
                "title": 47408,
                "link": "/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/?id=47408&q=",
                "guid": "/sen/finanzen/ueber-uns/leitung-organisation/aktenplan/index.php/detail/47408"
            },
            ...
        ]
    }
}
```

### GeoJSON-Format (index)

**Request-URI** | `${API_ENDPOINT}/index/index.geojson?${QUERY_STRING}`
**Response content-type** | `application/geo+json; charset=UTF-8`

Wenn die Einträge einer SimpleSearch-Anwendung Geokoordinaten enthalten und die Kartendarstellung in der Anwendung aktiviert ist, bietet die SimpleSearch-API die Daten auch im [GeoJSON](https://geojson.org)-Format.

Die konkrete JSON-Rückgabe sieht am Beispiel der [Liste der Badestellen](https://daten.berlin.de/datensaetze/liste-der-badestellen) folgendermaßen aus:

```json
{
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    13.14228,
                    52.43271
                ]
            },
            "properties": {
                "title": "Alter Hof / Unterhavel",
                "href": "/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/3",
                "description": "<img src=\"/imgscaler/9UbPmeYju8JzN01_S6Ac7xZB3fBwepuHm3-3MhLsFiU/80x60/L3N5czExLXByb2QvbGFnZXNvL2dlc3VuZGhlaXQvZ2VzdW5kaGVpdHNzY2h1dHovYmFkZWdld2Flc3Nlci9saXN0ZS1kZXItYmFkZXN0ZWxsZW4vZ3J1ZW5fYS5qcGc.jpg?ts=1650405782\" alt=\"\" />Steglitz-Zehlendorf<br /> <a href=\"/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/3\">Mehr...</a>",
                "id": "/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/3",
                "data": {
                    "id": 3,
                    "prognoselink": "",
                    "farbe": "gruen_a.jpg",
                    "badestellelink": "\"Alter Hof(Link zur Badestelle Alter Hof)\":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badestellen/artikel.344360.php",
                    "badname": "Alter Hof",
                    "bezirk": "Steglitz-Zehlendorf",
                    "dat": "2023-09-12",
                    "eco": "<15",
                    "ente": "<15",
                    "sicht": "50",
                    "temp": "23,8",
                    "profillink": "\"Unterhavel - Alter Hof(Link zum Badegewässerprofil Unterhavel Alter Hof)\":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badegewaesserprofile/artikel.339134.php",
                    "pdflink": "\"Alle Probeentnamen der aktuellen Saison für diese Badestelle(Link zur PDF-Datei mit allen Probeentnamen der aktuellen Saison)\":https://data.lageso.de/lageso/baden/bad29.pdf",
                    "dat_predict": ""
                }
            }
        },
        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [
                    13.62254,
                    52.4075
                ]
            },
            "properties": {
                "title": "Bammelecke",
                "href": "/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/6",
                "description": "<img src=\"/imgscaler/9UbPmeYju8JzN01_S6Ac7xZB3fBwepuHm3-3MhLsFiU/80x60/L3N5czExLXByb2QvbGFnZXNvL2dlc3VuZGhlaXQvZ2VzdW5kaGVpdHNzY2h1dHovYmFkZWdld2Flc3Nlci9saXN0ZS1kZXItYmFkZXN0ZWxsZW4vZ3J1ZW5fYS5qcGc.jpg?ts=1650405782\" alt=\"\" />Treptow-Köpenick<br /> <a href=\"/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/6\">Mehr...</a>",
                "id": "/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/6",
                "data": {
                    "id": 6,
                    "prognoselink": "",
                    "farbe": "gruen_a.jpg",
                    "badestellelink": "\"Bammelecke(Link zur Badestelle Bammelecke)\":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badestellen/artikel.344320.php",
                    "badname": "Bammelecke",
                    "bezirk": "Treptow-Köpenick",
                    "dat": "2023-09-06",
                    "eco": "<15",
                    "ente": "<15",
                    "sicht": "60",
                    "temp": "",
                    "profillink": "\"Dahme - Bammelecke(Link zum Badegewässerprofil Bammelecke)\":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badegewaesserprofile/artikel.339118.php",
                    "pdflink": "\"Alle Probeentnamen der aktuellen Saison für diese Badestelle(Link zur PDF-Datei mit allen Probeentnamen der aktuellen Saison)\":https://data.lageso.de/lageso/baden/bad1.pdf",
                    "dat_predict": ""
                }
            }
        },
        ...
    ]
}
```

Jeder Eintrag der SimpleSearch-Tabelle wird als ein `Feature` abgebildet.
Jedes `Feature` hat Koordinaten und `properties`.
Die `properties` wiederum enthalten ein `data`-Objekt, das die Attribute der ursprünglichen SimpleSearch-Tabelle enthält.
Auch hier kann wieder mindestens das `id`-Attribut vorrausgesetzt werden, alle andere Attribute müssen der SimpleSearch-Anwendung entnommen werden.

### KML-Format (index)

**Request-URI** | `${API_ENDPOINT}/index/index.kml?${QUERY_STRING}`
**Response content-type** | application/vnd.google-earth.kml; charset=UTF-8

Als alternatives Geodatenformat bietet die SimpleSearch-API auch einen Export im [KML-Format](http://www.opengeospatial.org/standards/kml/).

Ausgehend vom Beispiel der [Liste der Badestellen](https://daten.berlin.de/datensaetze/liste-der-badestellen) sieht die XML-Ausgabe der SimpleSearch-API folgendermaßen aus:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Liste der Badestellen</name>
    <description>Hilfe

Mit der Stichwortsuche können Sie nach den folgenden Informationen suchen: “Badestelle”, “Bezirk” und “Badegewässerprofil”.

Die Freitextsuche findet alle Einträge, die eines der gesuchten Wörter enthalten. Um nach einer genauen Wortgruppe zu suchen, schreiben Sie diese in doppelte Anführungszeichen “”.

Geben Sie einen Straßennamen ein, so werden Ihnen alle Standorte in der Nähe angezeigt. In der Liste werden die Treffer nach der Entfernung zur jeweiligen Straße sortiert.

Es reicht die Eingabe eines Begriffes in eines der Auswahlfelder um ein Ergebnis zu erhalten. Bitte danach auf den Button “Suchen” drücken.</description>
    <Placemark>
      <name>Alter Hof / Unterhavel</name>
      <description><![CDATA[
      <img src="/imgscaler/9UbPmeYju8JzN01_S6Ac7xZB3fBwepuHm3-3MhLsFiU/80x60/L3N5czExLXByb2QvbGFnZXNvL2dlc3VuZGhlaXQvZ2VzdW5kaGVpdHNzY2h1dHovYmFkZWdld2Flc3Nlci9saXN0ZS1kZXItYmFkZXN0ZWxsZW4vZ3J1ZW5fYS5qcGc.jpg?ts=1650405782" alt="" />Steglitz-Zehlendorf<br /> <a href="/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/3">Mehr...</a>    ]]></description>
      <Point>
        <coordinates>13.14228,52.43271,0</coordinates>
      </Point>
    </Placemark>
    <Placemark>
      <name>Bammelecke</name>
      <description><![CDATA[
      <img src="/imgscaler/9UbPmeYju8JzN01_S6Ac7xZB3fBwepuHm3-3MhLsFiU/80x60/L3N5czExLXByb2QvbGFnZXNvL2dlc3VuZGhlaXQvZ2VzdW5kaGVpdHNzY2h1dHovYmFkZWdld2Flc3Nlci9saXN0ZS1kZXItYmFkZXN0ZWxsZW4vZ3J1ZW5fYS5qcGc.jpg?ts=1650405782" alt="" />Treptow-Köpenick<br /> <a href="/lageso/gesundheit/gesundheitsschutz/badegewaesser/liste-der-badestellen/index.php/detail/6">Mehr...</a>    ]]></description>
      <Point>
        <coordinates>13.62254,52.4075,0</coordinates>
      </Point>
    </Placemark>
    <!-- weitere Placemarks -->
  </Document>
</kml>
```

Die KML-Ausgabe ist deutlich einfacher als die GeoJSON-Ausgabe und enthält für jeden Eintrag der SimpleSearch-Tabelle lediglich den Namen, die Koordinaten und einen Beschreibungstext (in diesem Fall HTML-Code mit einem Bild und einem Link).

### JSON-Format (detail)

**Request-URI** | `${API_ENDPOINT}/detail/${ITEM_ID}.json`
**Response content-type** | `application/json; charset=UTF-8`

Das von SimpleSearch über die API ausgelieferte JSON folgt der [allgemeinen Struktur](#struktur-der-rückgabeformate) wie oben beschrieben.

Eine Beispielausgabe für die [Liste der Badestellen](https://daten.berlin.de/datensaetze/liste-der-badestellen) sieht folgendermaßen aus:

```json
{
  "messages": {
    "messages": [],
    "success": null
  },
  "results": {
    "count": 0,
    "items_per_page": 20
  },
  "index": [],
  "item": {
    "id": 33,
    "prognoselink": "",
    "farbe": "gelb_a.jpg",
    "badestellelink": "\"Große Krampe(Link zur Badestelle Große Krampe)\":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badestellen/artikel.344326.php",
    "bezirk": "Treptow-Köpenick",
    "dat": "2023-09-06",
    "eco": "<15",
    "ente": "<15",
    "sicht": "40",
    "temp": "21,9",
    "profillink": "\"Dahme - Große Krampe(Link zum Badegewässerprofil Große Krampe)\":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badegewaesserprofile/artikel.339117.php",
    "pdflink": "\"Alle Probeentnamen der aktuellen Saison für diese Badestelle(Link zur PDF-Datei mit allen Probeentnamen der aktuellen Saison)\":https://data.lageso.de/lageso/baden/bad8.pdf",
    "dat_predict": ""
  }
}
```

Bei allen SimpleSearch-Anwendungen kann man im `item`-Objekt das `id`-Attribut voraussetzen.
Alle anderen Attribute sind abhängig von der jeweiligen Anwendung und müssen in deren API-Dokumentation nachgelesen werden.

### XML-Format (detail)

**Request-URI** | `${API_ENDPOINT}/detail/${ITEM_ID}.xml`
**Response content-type** | `text/xml; charset=UTF-8`

Das von SimpleSearch über die API ausgelieferte XML folgt der [allgemeinen Struktur](#struktur-der-rückgabeformate) wie oben beschrieben.

Eine Beispielausgabe für die [Liste der Badestellen](https://daten.berlin.de/datensaetze/liste-der-badestellen) sieht folgendermaßen aus:

```xml
<?xml version="1.0"?>
<xml xmlns="https://www.berlinonline.net/#xmlify" xmlns:xlink="http://www.w3.org/1999/xlink">
  <messages>
    <messages/>
    <success/>
  </messages>
  <results>
    <count>0</count>
    <items_per_page>20</items_per_page>
  </results>
  <index/>
  <item>
    <id>33</id>
    <prognoselink/>
    <farbe><![CDATA[gelb_a.jpg]]></farbe>
    <badestellelink><![CDATA["Große Krampe(Link zur Badestelle Große Krampe)":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badestellen/artikel.344326.php]]></badestellelink>
    <bezirk><![CDATA[Treptow-Köpenick]]></bezirk>
    <dat timestamp="1693951200" datetime="Wed, 06 Sep 2023 00:00:00 +0200">2023-09-06</dat>
    <eco><![CDATA[<15]]></eco>
    <ente><![CDATA[<15]]></ente>
    <sicht>40</sicht>
    <temp><![CDATA[21,9]]></temp>
    <profillink><![CDATA["Dahme - Große Krampe(Link zum Badegewässerprofil Große Krampe)":/lageso/gesundheit/gesundheitsschutz/badegewaesser/badegewaesserprofile/artikel.339117.php]]></profillink>
    <pdflink><![CDATA["Alle Probeentnamen der aktuellen Saison für diese Badestelle(Link zur PDF-Datei mit allen Probeentnamen der aktuellen Saison)":https://data.lageso.de/lageso/baden/bad8.pdf]]></pdflink>
    <dat_predict/>
  </item>
</xml>
```

Bei allen SimpleSearch-Anwendungen kann man in `/xml/item` das `id`-Element voraussetzen.
Alle anderen Elemente sind abhängig von der jeweiligen Anwendung und müssen in deren API-Dokumentation nachgelesen werden.


## Impressum

**Herausgeber:** Land Berlin, [Senatskanzlei](https://www.berlin.de/rbmskzl/)<br/>
**Text:** Knud Hinnerk Möller ([BerlinOnline GmbH](https://www.berlinonline.net))<br/>
**Grafiken:** Nadine Wohlfahrt ([BerlinOnline GmbH](https://www.berlinonline.net))<br/>
**Lizenz**: Der Text des Handbuchs ist unter einer [Creative Commons Namensnennung 4.0 International Lizenz](https://creativecommons.org/licenses/by/4.0/deed.de) (CC BY 4.0) veröffentlicht.
Bilder und andere Elemente, deren Urheberrecht bei Dritten liegen, sind ausgenommen.
[Quellenverzeichnis](../#quellenverzeichnis) und [Bildverzeichnis](../#bildverzeichnis) mit entsprechenden Urheberrechtsangaben sind im Handbuch enthalten.<br/>
**Quelle**: Der Quelltext für das Handbuch befindet sich in folgendem Repository: <https://github.com/berlinonline/open-data-handbuch>.
Dort können über die _[Issue](https://github.com/berlinonline/open-data-handbuch/issues)_-Funktion auch Anregungen gemacht oder Fehler gemeldet werden (github-Account erforderlich). 
Wer mag, kann auch gleich einen Pull Request stellen!<br/>
**Stand**: 2025-11-20
 ([2.0.2](https://github.com/berlinonline/open-data-handbuch/blob/master/CHANGELOG.md#202))

---

![Europäischer Fonds für regionale Entwicklung (EFRE)](../images/eu_efre_zusatz_unten.png "Logo und Schriftzug 'Europäischer Fonds für regionale Entwicklung (EFRE)'"){:width="205px"}&nbsp;&nbsp;
![Senatskanzlei Berlin](../images/B_RBm_Skzl_Logo_DE_V_PW_RGB.png "Logo und Schriftzug 'Der regierende Bürgermeister von Berlin, Senatskanzlei'"){:width="240px"}

