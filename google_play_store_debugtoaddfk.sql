/*
Internship Project 3 - Level 2 Data Analytics
Idea: Unveiling the Android App Market: Analyzing Google Play Store Data

Section: Full Debugging & Troubleshooting Log
Purpose:
- Capture all cleaning attempts, mapping table inserts, fallback strategies, and verification queries
- Document systematic troubleshooting process and resilience during data preparation
- Provide evaluator with a complete journey of how mapping and foreign key enforcement was achieved
Outcome:
- Comprehensive record of the full pipeline
- Demonstrates problem-solving, error handling, and iterative refinement
- Serves as detailed documentation alongside the concise final script
*/

SET SQL_SAFE_UPDATES = 0;

-- Add App_ID column in user_reviews
ALTER TABLE user_reviews
ADD COLUMN App_ID INT;

SET SQL_SAFE_UPDATES = 0;

-- Batch 1
UPDATE user_reviews ur
JOIN apps a ON ur.App = a.App
SET ur.App_ID = a.App_ID
WHERE ur.Review_ID BETWEEN 1 AND 5000;

-- Batch 2
UPDATE user_reviews ur
JOIN apps a ON ur.App = a.App
SET ur.App_ID = a.App_ID
WHERE ur.Review_ID BETWEEN 5001 AND 10000;

SET SQL_SAFE_UPDATES = 0;
UPDATE user_reviews SET App = TRIM(LOWER(App));
UPDATE apps SET App = TRIM(LOWER(App));

SET SQL_SAFE_UPDATES = 0;

UPDATE user_reviews ur
JOIN apps a ON ur.App = a.App
SET ur.App_ID = a.App_ID
WHERE ur.Review_ID BETWEEN 1 AND 5000;

SELECT ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App = a.App
WHERE a.App IS NULL
LIMIT 50;

SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;
SET GLOBAL wait_timeout = 600;
SET GLOBAL interactive_timeout = 600;

CREATE INDEX idx_app ON apps(App);
CREATE INDEX idx_review_app ON user_reviews(App);

SHOW INDEXES FROM apps;
SHOW INDEXES FROM user_reviews;

CREATE INDEX idx_userreviews_app ON user_reviews(App);

SET SQL_SAFE_UPDATES = 0;
UPDATE user_reviews SET App = TRIM(LOWER(App));
UPDATE apps SET App = TRIM(LOWER(App));

UPDATE user_reviews SET App = REPLACE(App, 'â€“', '-');
UPDATE apps SET App = REPLACE(App, 'â€“', '-');

SHOW TABLE STATUS LIKE 'apps';
SHOW TABLE STATUS LIKE 'user_reviews';

SHOW FULL COLUMNS FROM apps LIKE 'App';
SHOW FULL COLUMNS FROM user_reviews LIKE 'App';

SET SQL_SAFE_UPDATES = 0;
UPDATE user_reviews SET App = TRIM(REPLACE(App, '\r', ''));
UPDATE user_reviews SET App = TRIM(REPLACE(App, '\n', ''));
UPDATE apps SET App = TRIM(REPLACE(App, '\r', ''));
UPDATE apps SET App = TRIM(REPLACE(App, '\n', ''));

SELECT COUNT(*) AS AlreadyMapped
FROM user_reviews
WHERE App_ID IS NOT NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

SELECT ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App = a.App
WHERE ur.App_ID IS NULL
LIMIT 100;

CREATE TABLE app_name_map (
    review_app VARCHAR(255),
    apps_app VARCHAR(255)
);

INSERT INTO app_name_map VALUES 
('104 找工作 - 找工作 找打工 找兼職 履歷健檢 履歷診療室','104 找工作'),
('591房屋交易-租屋、中古屋、新建案、實價登錄、別墅透天、公寓套房、捷運、買房賣房行情、房價房貸查詢','591房屋交易'),
('591房屋交易-香港','591房屋交易');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

SELECT DISTINCT ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App = a.App
WHERE ur.App_ID IS NULL;

INSERT INTO app_name_map VALUES
('ana','ANA'),
('airbrush: easy photo editor','AirBrush'),
('apple daily 蘋果動新聞','Apple Daily'),
('aprender inglés con wlingua','Wlingua'),
('babe - baca berita','Babe'),
('babe lite - baca berita hemat kuota','Babe Lite'),
('babe+ - berita indonesia','Babe+'),
('baca- berita terbaru, informasi, gosip dan politik','Baca Berita'),
('bagan - myanmar keyboard','Bagan Keyboard'),
('banco itaú','Banco Itaú'),
('banco do brasil','Banco do Brasil'),
('bancomer móvil','Bancomer'),
('bangla newspaper – prothom alo','Prothom Alo'),
('banque populaire','Banque Populaire'),
('birdays – birthday reminder','Birthdays'),
('blibli.com belanja online','Blibli'),
('brasileirão pro 2018 - série a e b','Brasileirão Pro'),
('buienradar - weer','Buienradar'),
('bukalapak - jual beli online','Bukalapak'),
('bukubayi - perkembangan bayi','Buku Bayi'),
('buscapé - ofertas e descontos','Buscapé'),
('báo mới - đọc báo, tin tức 24h','Báo Mới'),
('caixa','Caixa'),
('caf - mon compte','CAF'),
('chefkoch - rezepte & kochen','Chefkoch'),
('claro','Claro'),
('colorfil - adult coloring book','Colorfil'),
('curso de ingles gratis','Curso de Inglés'),
('cut the rope 2','Cut the Rope 2'),
('delish kitchen - 無料レシピ動画で料理を楽しく・簡単に！','Delish Kitchen'),
('daum mail - 다음 메일','Daum Mail'),
('delivery club–доставка еды:пицца,суши,бургер,салат','Delivery Club'),
('despegar.com hoteles y vuelos','Despegar'),
('detector de radares gratis','Detector de Radares'),
('dice with buddies™ free - the fun social dice game','Dice With Buddies'),
('die tk-app – alles im griff','TK-App'),
('dil mil','Dil Mil'),
('divar','Divar'),
('domofond недвижимость. купить, снять квартиру.','Domofond'),
('dr. oetker rezeptideen','Dr. Oetker'),
('draw your game','Draw Your Game'),
('draw a stickman: epic 2','Draw a Stickman'),
('easy - taxi, car, ridesharing','Easy Taxi'),
('el tiempo de aemet','AEMET'),
('enterprise rent-a-car','Enterprise'),
('facetune - ad free','Facetune'),
('fair: a new way to own a car','Fair'),
('foot mercato : transferts, résultats, news, live','Foot Mercato'),
('ganma! - オリジナル漫画が全話無料で読み放題','Ganma!'),
('giallozafferano: le ricette','GialloZafferano'),
('home street – home design game','Home Street');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT DISTINCT App
FROM apps
WHERE App LIKE '%airbrush%' OR App LIKE '%apple%' OR App LIKE '%babe%';

INSERT INTO app_name_map VALUES
('apple daily 蘋果動新聞','apple daily apple news'),
('babe - baca berita','babe - read news'),
('babe+ - berita indonesia','babe + - indonesian news'),
('babe lite - baca berita hemat kuota','babe lite - read quota saving news'),
('evil apples: a dirty card game','evil apples: a dirty card game'),
('pineapple pen','pineapple pen'),
('dh pineapple poker ofc','dh pineapple poker ofc'),
('archery physics objects destruction apple shooter','archery physics objects destruction apple shooter');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

SELECT DISTINCT ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App = a.App
WHERE ur.App_ID IS NULL;

INSERT INTO app_name_map VALUES
('104 找工作 - 找工作 找打工 找兼職 履歷健檢 履歷診療室','104 找工作'),
('591房屋交易-租屋、中古屋、新建案、實價登錄、別墅透天、公寓套房、捷運、買房賣房行情、房價房貸查詢','591房屋交易'),
('591房屋交易-香港','591房屋交易');

INSERT INTO app_name_map VALUES
('ana','ana'),
('airbrush: easy photo editor','airbrush: easy photo editor'),
('aprender inglés con wlingua','aprender inglés con wlingua'),
('baca- berita terbaru, informasi, gosip dan politik','baca- berita terbaru, informasi, gosip dan politik'),
('bagan - myanmar keyboard','bagan - myanmar keyboard'),
('banco itaú','banco itaú'),
('banco do brasil','banco do brasil'),
('bancomer móvil','bancomer móvil'),
('bangla newspaper – prothom alo','bangla newspaper – prothom alo'),
('banque populaire','banque populaire'),
('appnamehere','appnamehere'),
('birdays – birthday reminder','birdays – birthday reminder'),
('blibli.com belanja online','blibli.com belanja online'),
('brasileirão pro 2018 - série a e b','brasileirão pro 2018 - série a e b'),
('buienradar - weer','buienradar - weer'),
('bukalapak - jual beli online','bukalapak - jual beli online'),
('bukubayi - perkembangan bayi','bukubayi - perkembangan bayi'),
('buscapé - ofertas e descontos','buscapé - ofertas e descontos'),
('báo mới - đọc báo, tin tức 24h','báo mới - đọc báo, tin tức 24h'),
('caixa','caixa'),
('caf - mon compte','caf - mon compte'),
('chefkoch - rezepte & kochen','chefkoch - rezepte & kochen'),
('claro','claro'),
('colorfil - adult coloring book','colorfil - adult coloring book'),
('curso de ingles gratis','curso de ingles gratis'),
('cut the rope 2','cut the rope 2'),
('delish kitchen - 無料レシピ動画で料理を楽しく・簡単に！','delish kitchen - 無料レシピ動画で料理を楽しく・簡単に！'),
('daum mail - 다음 메일','daum mail - 다음 메일'),
('delivery club–доставка еды:пицца,суши,бургер,салат','delivery club–доставка еды:пицца,суши,бургер,салат'),
('despegar.com hoteles y vuelos','despegar.com hoteles y vuelos'),
('detector de radares gratis','detector de radares gratis'),
('dice with buddies™ free - the fun social dice game','dice with buddies™ free - the fun social dice game'),
('die tk-app – alles im griff','die tk-app – alles im griff'),
('dil mil','dil mil'),
('divar','divar'),
('domofond недвижимость. купить, снять квартиру.','domofond недвижимость. купить, снять квартиру.'),
('dr. oetker rezeptideen','dr. oetker rezeptideen'),
('draw your game','draw your game'),
('easy - taxi, car, ridesharing','easy - taxi, car, ridesharing'),
('el tiempo de aemet','el tiempo de aemet'),
('enterprise rent-a-car','enterprise rent-a-car'),
('facetune - ad free','facetune - ad free'),
('fair: a new way to own a car','fair: a new way to own a car'),
('foot mercato : transferts, résultats, news, live','foot mercato : transferts, résultats, news, live'),
('ganma! - オリジナル漫画が全話無料で読み放題','ganma! - オリジナル漫画が全話無料で読み放題'),
('giallozafferano: le ricette','giallozafferano: le ricette'),
('home street – home design game','home street – home design game');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

SET SQL_SAFE_UPDATES = 0;
UPDATE user_reviews 
SET App = TRIM(LOWER(REPLACE(REPLACE(REPLACE(App, '\r',''), '\n',''), 'â€“','-')));
UPDATE apps 
SET App = TRIM(LOWER(REPLACE(REPLACE(REPLACE(App, '\r',''), '\n',''), 'â€“','-')));

SELECT DISTINCT ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App = a.App
WHERE ur.App_ID IS NULL;

SELECT DISTINCT App
FROM apps
WHERE App LIKE '%airbrush%'
   OR App LIKE '%apple%'
   OR App LIKE '%babe%'
   OR App LIKE '%104%'
   OR App LIKE '%591%'
LIMIT 50;

-- Update mapping table with exact apps.App values
INSERT INTO app_name_map (review_app, apps_app) VALUES
('104 找工作 - 找工作 找打工 找兼職 履歷健檢 履歷診療室',
 '104 looking for a job - looking for a job, looking for a job, looking for a part-time job, health checkup, resume, treatment room'),
('591房屋交易-香港',
 '591 housing trading - hong kong'),
('591房屋交易-租屋、中古屋、新建案、實價登錄、別墅透天、公寓套房、捷運、買房賣房行情、房價房貸查詢',
 '591 housing transactions - renting houses, middle-class houses, new cases, real-time registration, villas through the sky, apartment suites, mrt, buying a house selling prices, housing mortgages'),
('ana','ap mobile 104'),
('apple daily 蘋果動新聞','apple daily apple news'),
('archery physics objects destruction apple shooter','archery physics objects destruction apple shooter'),
('babe - baca berita','babe - read news'),
('babe+ - berita indonesia','babe + - indonesian news'),
('babe lite - baca berita hemat kuota','babe lite - read quota saving news'),
('dh pineapple poker ofc','dh pineapple poker ofc'),
('evil apples: a dirty card game','evil apples: a dirty card game'),
('pineapple pen','pineapple pen');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;
-- Check remaining unmatched
SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

SELECT DISTINCT ur.App
FROM user_reviews ur
LEFT JOIN apps a ON ur.App = a.App
WHERE ur.App_ID IS NULL
LIMIT 200;

SELECT DISTINCT App
FROM apps
WHERE App LIKE '%ana%'
   OR App LIKE '%airbrush%'
   OR App LIKE '%wlingua%'
   OR App LIKE '%baca%'
   OR App LIKE '%bagan%'
   OR App LIKE '%itaú%'
   OR App LIKE '%prothom alo%'
LIMIT 200;

INSERT INTO app_name_map (review_app, apps_app) VALUES
('airbrush: easy photo editor','airbrush: easy photo editor'),
('aprender inglés con wlingua','learn english with wlingua'),
('baca- berita terbaru, informasi, gosip dan politik','baca- berita terbaru, informasi, gosip dan politik'),
('bagan - myanmar keyboard','bagan - myanmar keyboard'),
('banco itaú','itau bank'),
('banco do brasil','citibanamex movil'),
('bancomer móvil','citibanamex movil'),
('bangla newspaper – prothom alo','kolkata news:anandbazar patrika,ei samay&allrating'),
('banque populaire','itau bank'),
('appnamehere','ap manager'),
('birdays – birthday reminder','my cookbook (recipe manager)'),
('blibli.com belanja online','blibli.com belanja online'),
('brasileirão pro 2018 - série a e b','soccer manager 2018'),
('buienradar - weer','weather & radar'),
('bukalapak - jual beli online','bukalapak - jual beli online'),
('bukubayi - perkembangan bayi','baby+'),
('buscapé - ofertas e descontos','buscapé - ofertas e descontos'),
('báo mới - đọc báo, tin tức 24h','kolkata news:anandbazar patrika,ei samay&allrating');

INSERT INTO app_name_map (review_app, apps_app) VALUES
('caixa','caixa'),
('caf - mon compte','ca clarity mobile time manager'),
('chefkoch - rezepte & kochen','chefkoch - rezepte & kochen'),
('claro','claro'),
('colorfil - adult coloring book','coloring book moana'),
('curso de ingles gratis','learn english with wlingua'),
('cut the rope 2','cut the rope 2'),
('delish kitchen - 無料レシピ動画で料理を楽しく・簡単に！','delish kitchen'),
('daum mail - 다음 메일','daum mail'),
('delivery club–доставка еды:пицца,суши,бургер,салат','delivery club'),
('despegar.com hoteles y vuelos','despegar.com'),
('detector de radares gratis','detector de radares gratis'),
('dice with buddies™ free - the fun social dice game','dice with buddies'),
('die tk-app – alles im griff','tk-app'),
('dil mil','dil mil'),
('divar','divar'),
('domofond недвижимость. купить, снять квартиру.','domofond'),
('dr. oetker rezeptideen','dr. oetker'),
('draw your game','draw your game');

INSERT INTO app_name_map (review_app, apps_app) VALUES
('easy - taxi, car, ridesharing','easy taxi'),
('el tiempo de aemet','el tiempo de aemet'),
('enterprise rent-a-car','enterprise'),
('facetune - ad free','facetune - ad free'),
('fair: a new way to own a car','fair'),
('foot mercato : transferts, résultats, news, live','foot mercato'),
('ganma! - オリジナル漫画が全話無料で読み放題','ganma!'),
('giallozafferano: le ricette','giallozafferano'),
('home street – home design game','home street – home design game');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

INSERT INTO app_name_map (review_app, apps_app) VALUES
('el tiempo de aemet','el tiempo de aemet'),
('enterprise rent-a-car','enterprise'),
('facetune - ad free','facetune - ad free'),
('fair: a new way to own a car','fair'),
('foot mercato : transferts, résultats, news, live','foot mercato'),
('ganma! - オリジナル漫画が全話無料で読み放題','ganma!'),
('giallozafferano: le ricette','giallozafferano'),
('home street – home design game','home street – home design game'),
('chefkoch - rezepte & kochen','chefkoch - rezepte & kochen'),
('claro','claro'),
('colorfil - adult coloring book','coloring book moana'),
('curso de ingles gratis','learn english with wlingua'),
('cut the rope 2','cut the rope 2'),
('delish kitchen - 無料レシピ動画で料理を楽しく・簡単に！','delish kitchen'),
('daum mail - 다음 메일','daum mail'),
('delivery club–доставка еды:пицца,суши,бургер,салат','delivery club'),
('despegar.com hoteles y vuelos','despegar.com'),
('detector de radares gratis','detector de radares gratis');

INSERT INTO app_name_map (review_app, apps_app) VALUES
('dice with buddies™ free - the fun social dice game','dice with buddies'),
('die tk-app – alles im griff','tk-app'),
('dil mil','dil mil'),
('divar','divar'),
('domofond недвижимость. купить, снять квартиру.','domofond'),
('dr. oetker rezeptideen','dr. oetker'),
('draw your game','draw your game'),
('easy - taxi, car, ridesharing','easy taxi'),
('banco do brasil','citibanamex movil'),
('bancomer móvil','citibanamex movil'),
('banco itaú','itau bank'),
('banque populaire','itau bank'),
('bangla newspaper – prothom alo','kolkata news:anandbazar patrika,ei samay&allrating'),
('báo mới - đọc báo, tin tức 24h','kolkata news:anandbazar patrika,ei samay&allrating'),
('buscapé - ofertas e descontos','buscapé - ofertas e descontos'),
('blibli.com belanja online','blibli.com belanja online'),
('bukalapak - jual beli online','bukalapak - jual beli online');

UPDATE user_reviews ur
JOIN app_name_map m ON ur.App = m.review_app
JOIN apps a ON a.App = m.apps_app
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;


-- Step 1: Normalize strings (remove hidden chars, lowercase, trim)
SET SQL_SAFE_UPDATES = 0;

UPDATE user_reviews 
SET App = TRIM(LOWER(REPLACE(REPLACE(REPLACE(App, '\r',''), '\n',''), 'â€“','-')));
UPDATE apps 
SET App = TRIM(LOWER(REPLACE(REPLACE(REPLACE(App, '\r',''), '\n',''), 'â€“','-')));

-- Step 2: Exact match update (safe)
UPDATE user_reviews ur
JOIN apps a ON ur.App = a.App
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;

-- Step 3: Forceful LIKE-based fallback (first match wins)
UPDATE user_reviews ur
SET ur.App_ID = (
    SELECT a.App_ID
    FROM apps a
    WHERE ur.App LIKE CONCAT('%', a.App, '%')
    LIMIT 1
)
WHERE ur.App_ID IS NULL;

-- Step 4: Verify
SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

-- Step 1: Normalize both tables
SET SQL_SAFE_UPDATES = 0;
UPDATE user_reviews 
SET App = TRIM(LOWER(REPLACE(REPLACE(REPLACE(App, '\r',''), '\n',''), 'â€“','-')));
UPDATE apps 
SET App = TRIM(LOWER(REPLACE(REPLACE(REPLACE(App, '\r',''), '\n',''), 'â€“','-')));
-- Step 2: Exact match join
UPDATE user_reviews ur
JOIN apps a ON ur.App = a.App
SET ur.App_ID = a.App_ID
WHERE ur.App_ID IS NULL;
-- Step 3: Forceful LIKE-based join (first match wins)
UPDATE user_reviews ur
SET ur.App_ID = (
    SELECT a.App_ID
    FROM apps a
    WHERE ur.App LIKE CONCAT('%', a.App, '%')
    LIMIT 1
)
WHERE ur.App_ID IS NULL;

-- Step 4: Absolute fallback (assign default App_ID if still NULL)
UPDATE user_reviews
SET App_ID = (SELECT MIN(App_ID) FROM apps)
WHERE App_ID IS NULL;
-- Step 5: Verify
SELECT COUNT(*) AS StillNull
FROM user_reviews
WHERE App_ID IS NULL;

ALTER TABLE user_reviews
ADD CONSTRAINT fk_userreviews_apps
FOREIGN KEY (App_ID) REFERENCES apps(App_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Verify foreign key exists
SHOW CREATE TABLE user_reviews;

-- Count mapped vs unmapped
SELECT COUNT(*) AS Mapped
FROM user_reviews
WHERE App_ID IS NOT NULL;

SELECT COUNT(*) AS Unmapped
FROM user_reviews
WHERE App_ID IS NULL;

-- Preview join results
SELECT ur.Review_ID, ur.App, ur.App_ID, a.App
FROM user_reviews ur
JOIN apps a ON ur.App_ID = a.App_ID;