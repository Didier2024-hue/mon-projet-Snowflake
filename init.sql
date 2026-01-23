--****************************
--************ Emplacement pour lancer le script
use warehouse WAREHOUSE_DST;
use database dst_db;
use schema public;

--************ VAlidation de l'emplacement
SELECT 
    CURRENT_DATABASE() AS database,
    CURRENT_SCHEMA() AS schema,
    CURRENT_WAREHOUSE() AS warehouse,
    CURRENT_ROLE() AS role;

--************ Création des tables de données
-- 1. Table Artist (4 colonnes dans le fichier)
CREATE OR REPLACE TABLE Artist (
    ArtistId NUMERIC PRIMARY KEY,
    Name VARCHAR,
    Birthyear NUMERIC,
    Country VARCHAR
);

-- 2. Table MediaType (2 colonnes  dans le fichier)
CREATE OR REPLACE TABLE MediaType (
    MediaTypeId NUMERIC PRIMARY KEY,
    Name VARCHAR
);

-- 3. Table Genre (2 colonnes  dans le fichier)
CREATE OR REPLACE TABLE Genre (
    GenreId NUMERIC PRIMARY KEY,
    Name VARCHAR
);

-- 4. Table Album (5 colonnes  dans le fichier)
CREATE OR REPLACE TABLE Album (
    AlbumId NUMERIC PRIMARY KEY,
    Title VARCHAR,
    ArtistId NUMERIC,
    Prod_year NUMERIC,
    Cd_year NUMERIC,
    FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId)
);

-- 5. Table Track (9 colonnes dans le fichier)
-- 5.1. D'abord créer un format de fichier spécifique
CREATE OR REPLACE FILE FORMAT music_track_format
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  ESCAPE_UNENCLOSED_FIELD = '\\'
  NULL_IF = ('NULL', '\\N')
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

-- 5.1. Ensuite créer, la table Track
CREATE OR REPLACE TABLE Track (
    TrackId NUMERIC PRIMARY KEY,
    Name VARCHAR,
    MediaTypeId NUMERIC,
    GenreId NUMERIC,
    AlbumId NUMERIC,
    Composer VARCHAR,
    Milliseconds NUMERIC,
    Bytes NUMERIC,
    UnitPrice NUMERIC,
    FOREIGN KEY (MediaTypeId) REFERENCES MediaType(MediaTypeId),
    FOREIGN KEY (GenreId) REFERENCES Genre(GenreId),
    FOREIGN KEY (AlbumId) REFERENCES Album(AlbumId)
);

-- 6. Table Playlist (2 colonnes dans le fichier)
CREATE OR REPLACE TABLE Playlist (
    PlaylistId NUMERIC PRIMARY KEY,
    Name VARCHAR
);

-- 7. Table PlaylistTrack (2 colonnes  dans le fichier)
CREATE OR REPLACE TABLE PlaylistTrack (
    PlaylistId NUMERIC,
    TrackId NUMERIC,
    PRIMARY KEY (PlaylistId, TrackId),
    FOREIGN KEY (PlaylistId) REFERENCES Playlist(PlaylistId),
    FOREIGN KEY (TrackId) REFERENCES Track(TrackId)
);


--************ Tables independantes : Insertion des données
COPY INTO Artist FROM @DST_DB.PUBLIC.S3_DATA/music/Artist.csv
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');

COPY INTO MediaType FROM @DST_DB.PUBLIC.S3_DATA/music/MediaType.csv
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');

COPY INTO Genre FROM @DST_DB.PUBLIC.S3_DATA/music/Genre.csv
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');


--************ Table Album (dépend de Artist):
COPY INTO Album FROM @DST_DB.PUBLIC.S3_DATA/music/Album.csv
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');

--************ Table Track (dépend de Albume, MediaType, Genre):
COPY INTO DST_DB.PUBLIC.Track
FROM @DST_DB.PUBLIC.S3_DATA/music/Track.csv
FILE_FORMAT = (FORMAT_NAME = 'music_track_format')
ON_ERROR = 'CONTINUE';

--************ Table Playlist:
COPY INTO Playlist FROM @DST_DB.PUBLIC.S3_DATA/music/Playlist.csv
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');

--************ Table PlaylistTrack (dépend de Playlist et Track):
COPY INTO PlaylistTrack FROM @DST_DB.PUBLIC.S3_DATA/music/PlaylistTrack.csv
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1, FIELD_DELIMITER = ',');


--****************************