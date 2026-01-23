-- =============================================
-- CONTEXTE
-- =============================================
USE DATABASE MUSIC_DWH;
USE SCHEMA STAR_SCHEMA;
USE WAREHOUSE WAREHOUSE_DST;

-- =============================================
-- CREATION DU STAGE
-- =============================================
-- Supprime les fichiers dans results 
REMOVE @MY_STAGE/results;

-- Crée ou remplace le stage
CREATE OR REPLACE STAGE MY_STAGE;

-- =============================================
-- FORMAT TEXTE PIPE
-- =============================================
CREATE OR REPLACE FILE FORMAT FF_TXT_PIPE
TYPE = 'CSV'
FIELD_DELIMITER = '|'
FIELD_OPTIONALLY_ENCLOSED_BY = NONE
NULL_IF = ('NULL', 'null')
COMPRESSION = NONE;

-- =============================================
-- 1. Titres des albums qui ont plus de 1 CD
COPY INTO @MY_STAGE/results/req_01_albums_plus_d1_cd.txt
FROM (
    SELECT ALBUM_TITLE, NUMBER_OF_TRACKS
    FROM DIM_ALBUM
    WHERE NUMBER_OF_TRACKS > 20
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 2. Morceaux produits en 2000 ou 2002
COPY INTO @MY_STAGE/results/req_02_tracks_2000_ou_2002.txt
FROM (
    SELECT TRACK_NAME, RELEASE_DATE
    FROM FACT_TRACKS t
    JOIN DIM_DATE d ON t.RELEASE_DATE = d.DATE_ID
    WHERE d.YEAR IN (2000, 2002)
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 3. Nom et compositeur des morceaux de Rock et de Jazz
COPY INTO @MY_STAGE/results/req_03_tracks_rock_jazz.txt
FROM (
    SELECT t.TRACK_NAME, t.COMPOSER, g.GENRE_NAME
    FROM FACT_TRACKS t
    JOIN DIM_GENRE g ON t.GENRE_ID = g.GENRE_ID
    WHERE g.GENRE_NAME IN ('Rock', 'Jazz')
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 4. Les 10 albums les plus longs (durée totale des morceaux)
COPY INTO @MY_STAGE/results/req_04_top10_albums_longs.txt
FROM (
    SELECT a.ALBUM_TITLE, SUM(t.DURATION_MS)/60000 AS DUREE_MINUTES
    FROM FACT_TRACKS t
    JOIN DIM_ALBUM a ON t.ALBUM_ID = a.ALBUM_ID
    GROUP BY a.ALBUM_TITLE
    ORDER BY DUREE_MINUTES DESC
    LIMIT 10
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 5. Nombre d’albums produits pour chaque artiste
COPY INTO @MY_STAGE/results/req_05_nb_albums_par_artiste.txt
FROM (
    SELECT ar.ARTIST_NAME, COUNT(*) AS NB_ALBUMS
    FROM DIM_ALBUM a
    JOIN DIM_ARTIST ar ON a.ARTIST_ID = ar.ARTIST_ID
    GROUP BY ar.ARTIST_NAME
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 6. Nombre de morceaux produits par chaque artiste
COPY INTO @MY_STAGE/results/req_06_nb_tracks_par_artiste.txt
FROM (
    SELECT ar.ARTIST_NAME, COUNT(*) AS NB_TRACKS
    FROM FACT_TRACKS t
    JOIN DIM_ALBUM a ON t.ALBUM_ID = a.ALBUM_ID
    JOIN DIM_ARTIST ar ON a.ARTIST_ID = ar.ARTIST_ID
    GROUP BY ar.ARTIST_NAME
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 7. Genre de musique le plus écouté dans les années 2000
COPY INTO @MY_STAGE/results/req_07_genre_plus_ecoute_annees_2000.txt
FROM (
    SELECT g.GENRE_NAME, COUNT(*) AS NB
    FROM FACT_TRACKS t
    JOIN DIM_GENRE g ON t.GENRE_ID = g.GENRE_ID
    JOIN DIM_DATE d ON t.RELEASE_DATE = d.DATE_ID
    WHERE d.YEAR BETWEEN 2000 AND 2009
    GROUP BY g.GENRE_NAME
    ORDER BY NB DESC
    LIMIT 1
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 8. Playlists avec des morceaux de plus de 4 minutes
COPY INTO @MY_STAGE/results/req_08_playlists_plus_4min.txt
FROM (
    SELECT DISTINCT p.PLAYLIST_NAME
    FROM FACT_PLAYLIST_TRACKS pt
    JOIN FACT_TRACKS t ON pt.TRACK_ID = t.TRACK_ID
    JOIN DIM_PLAYLIST p ON pt.PLAYLIST_ID = p.PLAYLIST_ID
    WHERE t.DURATION_MS > 240000
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 9. Morceaux de Rock dont les artistes sont en France
COPY INTO @MY_STAGE/results/req_09_tracks_rock_france.txt
FROM (
    SELECT t.TRACK_NAME, ar.ARTIST_NAME
    FROM FACT_TRACKS t
    JOIN DIM_GENRE g ON t.GENRE_ID = g.GENRE_ID
    JOIN DIM_ALBUM a ON t.ALBUM_ID = a.ALBUM_ID
    JOIN DIM_ARTIST ar ON a.ARTIST_ID = ar.ARTIST_ID
    WHERE g.GENRE_NAME = 'Rock' AND ar.COUNTRY = 'France'
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 10. Moyenne des tailles des morceaux par genre musical
COPY INTO @MY_STAGE/results/req_10_taille_moyenne_par_genre.txt
FROM (
    SELECT g.GENRE_NAME, ROUND(AVG(t.SIZE_BYTES)/1024, 2) AS TAILLE_KO
    FROM FACT_TRACKS t
    JOIN DIM_GENRE g ON t.GENRE_ID = g.GENRE_ID
    GROUP BY g.GENRE_NAME
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- 11. Playlists avec des morceaux d’artistes nés avant 1990
COPY INTO @MY_STAGE/results/req_11_playlists_artistes_avant1990.txt
FROM (
    SELECT DISTINCT p.PLAYLIST_NAME
    FROM FACT_PLAYLIST_TRACKS pt
    JOIN FACT_TRACKS t ON pt.TRACK_ID = t.TRACK_ID
    JOIN DIM_ALBUM a ON t.ALBUM_ID = a.ALBUM_ID
    JOIN DIM_ARTIST ar ON a.ARTIST_ID = ar.ARTIST_ID
    JOIN DIM_PLAYLIST p ON pt.PLAYLIST_ID = p.PLAYLIST_ID
    WHERE ar.BIRTH_YEAR < 1990
)
FILE_FORMAT = FF_TXT_PIPE
SINGLE = TRUE
OVERWRITE = TRUE;

-- =============================================
-- Liste les fichiers dans le stage au chemin results
LIST @MY_STAGE/results;
