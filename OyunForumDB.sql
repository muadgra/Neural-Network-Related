--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12rc1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: OyunForumSchema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "OyunForumSchema";


ALTER SCHEMA "OyunForumSchema" OWNER TO postgres;

--
-- Name: adDegisikligi(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."adDegisikligi"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    no INTEGER;
BEGIN
    no := floor(random() * 1000 + 1);
    IF NEW."kullaniciAdi" <> OLD."kullaniciAdi" THEN
        INSERT INTO "OyunForumSchema"."Mesaj"("aliciAdi", "genelKutuNo", "gonderenAdi", "mesajNo","mesaj")
        VALUES(NEW."kullaniciAdi",OLD."genelKutuNo", 'Sistem' ,no ,'Isminiz degisti!');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."adDegisikligi"() OWNER TO postgres;

--
-- Name: baslikAdDegisikligi(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."baslikAdDegisikligi"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    no INTEGER;
BEGIN
    no := floor(random() * 10000 + 1);
    IF NEW."ad" <> OLD."ad" THEN
        INSERT INTO "OyunForumSchema"."Mesaj"("aliciAdi", "genelKutuNo", "gonderenAdi", "mesajNo","mesaj")
        VALUES(NEW."kullaniciAdi",OLD."genelKutuNo", 'Sistem' ,no ,'Basligin adini degistirdiniz!');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."baslikAdDegisikligi"() OWNER TO postgres;

--
-- Name: bilgileriYazdir(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."bilgileriYazdir"() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    sonuc text;
    profil "OyunForumSchema"."Profil"%ROWTYPE;
BEGIN
    sonuc := '';
    FOR profil IN SELECT * FROM "OyunForumSchema"."Profil" LOOP
        sonuc := sonuc || ' '|| profil."age" || ' ' ||profil."gercekAd" || ' ' ||profil."eposta" || ' ' || profil."seviye" || ' ' || 'E\n';
    END LOOP;
    RETURN sonuc;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."bilgileriYazdir"() OWNER TO postgres;

--
-- Name: bolumleriYazdir(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."bolumleriYazdir"() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    sonuc text;
    b "OyunForumSchema"."Bolum"%ROWTYPE;
BEGIN
    
    sonuc := '';
    FOR b IN SELECT "bolumAdi" FROM "OyunForumSchema"."Bolum" LOOP
        sonuc := sonuc || "b" || 'E\n';
    END LOOP;
    RETURN sonuc;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."bolumleriYazdir"() OWNER TO postgres;

--
-- Name: mesajIcerikDegisikligi(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."mesajIcerikDegisikligi"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    no INTEGER;
BEGIN
    no := random() * 10000 + 1;
    IF NEW."mesaj" <> OLD."mesaj" THEN
        INSERT INTO "OyunForumSchema"."Mesaj"("aliciAdi", "genelKutuNo", "gonderenAdi", "mesajNo","mesaj")
        VALUES(NEW."aliciAdi",OLD."genelKutuNo", 'Sistem' ,no ,'Size gonderilen mesajin icerigi degistirildi!');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."mesajIcerikDegisikligi"() OWNER TO postgres;

--
-- Name: mesajlariGoruntule(text); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."mesajlariGoruntule"(gkid text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    sonuc VARCHAR(1000);
    msj "OyunForumSchema"."Mesaj"%ROWTYPE;
BEGIN
    
    sonuc := '';
    FOR msj IN SELECT * FROM "OyunForumSchema"."Mesaj" WHERE "OyunForumSchema"."Mesaj"."genelKutuNo" = gKID  LOOP
        sonuc := sonuc || msj."gonderenAdi" || E': \t '|| msj."mesaj" || E'\n\n';
    END LOOP;
    RETURN sonuc;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."mesajlariGoruntule"(gkid text) OWNER TO postgres;

--
-- Name: personelAra(character varying); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."personelAra"(kullaniciadi character varying) RETURNS TABLE("kullaniciNo" character varying, "kullanıcıAdı" character varying, sifre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "OyunForumSchema"."Kullanici"."kullaniciID", 
    "OyunForumSchema"."Kullanici"."kullaniciAdi", 
    "OyunForumSchema"."Kullanici"."sifre" 
    FROM "OyunForumSchema"."Kullanici"             
    WHERE "kullaniciAdi" = kullaniciAdi;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."personelAra"(kullaniciadi character varying) OWNER TO postgres;

--
-- Name: seviyeDegisikligi(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."seviyeDegisikligi"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."seviye" < '0' THEN
        NEW."seviye" := '0';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."seviyeDegisikligi"() OWNER TO postgres;

--
-- Name: sifreDegisikligi(); Type: FUNCTION; Schema: OyunForumSchema; Owner: postgres
--

CREATE FUNCTION "OyunForumSchema"."sifreDegisikligi"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    no INTEGER;
BEGIN
    no := floor(random() * 1000 + 1);
    IF NEW."sifre" <> OLD."sifre" THEN
        INSERT INTO "OyunForumSchema"."Mesaj"("aliciAdi", "genelKutuNo", "gonderenAdi", "mesajNo","mesaj")
        VALUES(NEW."kullaniciAdi",OLD."genelKutuNo", 'Sistem' ,no ,'Sifreniz degisti!');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "OyunForumSchema"."sifreDegisikligi"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Admin; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Admin" (
    "kullanıcıID" character varying(15) NOT NULL,
    "adminNo" character(15)
);


ALTER TABLE "OyunForumSchema"."Admin" OWNER TO postgres;

--
-- Name: Baslik; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Baslik" (
    "baslikNo" character varying(25) NOT NULL,
    "bolumNo" character(15),
    "kullaniciID" character varying(15),
    ad character varying(50),
    icerik text,
    "goruntulenmeSayisi" integer DEFAULT 1,
    "cevapSayisi" integer DEFAULT 0,
    "sonEditTarihi" integer DEFAULT 0
);


ALTER TABLE "OyunForumSchema"."Baslik" OWNER TO postgres;

--
-- Name: Bolum; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Bolum" (
    "bolumNo" character(15) NOT NULL,
    "bolumAdi" character(15),
    "baslikSayisi" integer DEFAULT 0
);


ALTER TABLE "OyunForumSchema"."Bolum" OWNER TO postgres;

--
-- Name: Destek; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Destek" (
    "bolumNo" character(15) NOT NULL,
    sss text NOT NULL
);


ALTER TABLE "OyunForumSchema"."Destek" OWNER TO postgres;

--
-- Name: EngelliKullanici; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."EngelliKullanici" (
    "kullanıcıID" character varying(15) NOT NULL,
    "kalanEngelGunu" integer DEFAULT 1
);


ALTER TABLE "OyunForumSchema"."EngelliKullanici" OWNER TO postgres;

--
-- Name: Genel Kutu; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Genel Kutu" (
    "genelKutuNo" character varying(15) NOT NULL
);


ALTER TABLE "OyunForumSchema"."Genel Kutu" OWNER TO postgres;

--
-- Name: Kullanici; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Kullanici" (
    "kullaniciID" character varying(15) NOT NULL,
    "kullaniciAdi" character varying(15) NOT NULL,
    sifre character varying(15) NOT NULL,
    "profilNumarasi" character varying(15),
    "genelKutuNo" character varying(15)
);


ALTER TABLE "OyunForumSchema"."Kullanici" OWNER TO postgres;

--
-- Name: Kurallar; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Kurallar" (
    "bolumNo" character(15) NOT NULL,
    kurallar text
);


ALTER TABLE "OyunForumSchema"."Kurallar" OWNER TO postgres;

--
-- Name: Mesaj; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Mesaj" (
    "mesajNo" character varying(150) NOT NULL,
    mesaj text,
    "gonderenAdi" character varying(150),
    "aliciAdi" character varying(150),
    "genelKutuNo" character varying(150)
);


ALTER TABLE "OyunForumSchema"."Mesaj" OWNER TO postgres;

--
-- Name: Moderator; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Moderator" (
    "kullanıcıID" character varying(15) NOT NULL,
    "bolumNo" character(15)
);


ALTER TABLE "OyunForumSchema"."Moderator" OWNER TO postgres;

--
-- Name: OyunDisi; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."OyunDisi" (
    "bolumNo" character(15) NOT NULL
);


ALTER TABLE "OyunForumSchema"."OyunDisi" OWNER TO postgres;

--
-- Name: OyunIci; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."OyunIci" (
    "bolumNo" character(15) NOT NULL,
    tag character(10)
);


ALTER TABLE "OyunForumSchema"."OyunIci" OWNER TO postgres;

--
-- Name: Profil; Type: TABLE; Schema: OyunForumSchema; Owner: postgres
--

CREATE TABLE "OyunForumSchema"."Profil" (
    "profilNo" character varying(15) NOT NULL,
    "gercekAd" character varying(10) NOT NULL,
    seviye character(3) DEFAULT '0'::bpchar,
    age character(3),
    eposta character varying(25)
);


ALTER TABLE "OyunForumSchema"."Profil" OWNER TO postgres;

--
-- Data for Name: Admin; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Admin" VALUES ('K1111', 'A1111          ');


--
-- Data for Name: Baslik; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Baslik" VALUES ('BA111', 'B1111          ', 'K1114', 'Ucuncu bolumu nasıl gecerim?', 'Ucuncu bolumu gecebilmek icin ne yapmam gerekiyor?', 7, 0, 3);
INSERT INTO "OyunForumSchema"."Baslik" VALUES ('BA112', 'B1113          ', 'K1113', 'Esyam kayboldu', 'Envanterimden esyam kayboldu?', 87, 1, 2);
INSERT INTO "OyunForumSchema"."Baslik" VALUES ('BA113', 'B1113          ', 'K1117', 'Oyun ici alimda problem yasiyorum', 'Kredi karti gecersiz hatasi aliyorum. Nedeni nedir?', 997, 5, 2);
INSERT INTO "OyunForumSchema"."Baslik" VALUES ('BA12512', 'B1111          ', 'K1', '1. Koye Maviler Saldırıyor ', 'Arkadaslar yardim edin pazarlari kesiyorlar', 1, 0, 0);
INSERT INTO "OyunForumSchema"."Baslik" VALUES ('2422', 'B1111          ', 'K1', 'baslik deneme', 'deneme123', 1, 0, 0);


--
-- Data for Name: Bolum; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Bolum" VALUES ('B1111          ', 'Oyun Ici       ', 467);
INSERT INTO "OyunForumSchema"."Bolum" VALUES ('B1112          ', 'Kurallar       ', 4);
INSERT INTO "OyunForumSchema"."Bolum" VALUES ('B1113          ', 'Destek         ', 7);
INSERT INTO "OyunForumSchema"."Bolum" VALUES ('B1114          ', 'Oyun Disi      ', 53);


--
-- Data for Name: Destek; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--



--
-- Data for Name: EngelliKullanici; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."EngelliKullanici" VALUES ('K1112', 3);


--
-- Data for Name: Genel Kutu; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1111');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1112');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1113');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1114');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1115');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1116');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1117');
INSERT INTO "OyunForumSchema"."Genel Kutu" VALUES ('GK1118');


--
-- Data for Name: Kullanici; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1113', 'seadra', 'lltq8712', 'P1113', 'GK1113');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1114', 'kjlkasd', '417128Af', 'P1114', 'GK1114');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1115', 'feyyazyigit55', '587zvxk', 'P1115', 'GK1115');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1116', 'erayziman', 'ery364', 'P1116', 'GK1116');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1117', 'miracA', 'd3063', 'P1117', 'GK1117');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1112', 'mert36', 'abdullah1998', 'P1112', 'GK1112');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1111', '1234', '1234', 'P1111', 'GK1111');
INSERT INTO "OyunForumSchema"."Kullanici" VALUES ('K1', 'muadgra', '1234', 'P1', 'GK1118');


--
-- Data for Name: Kurallar; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--



--
-- Data for Name: Mesaj; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('M1112', 'orda mısın?', 'tonychopper', 'muadgra', 'GK1111');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('M1113', 'bi saniye bekle, şu an işim var', 'muadgra', 'tonychopper', 'GK1116');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('581', 'Isminiz degisti!', 'Sistem', 'muadgra1', 'GK1118');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('600', 'Isminiz degisti!', 'Sistem', 'muadgra', 'GK1118');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('717', 'Sifreniz degisti!', 'Sistem', 'muadgra', 'GK1118');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('4182', 'nasilsin?', 'muadgra', 'seadra', 'GK1113');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('4735', 'umarim mesajimi almissindir', 'muadgra', 'seadra', 'GK1113');
INSERT INTO "OyunForumSchema"."Mesaj" VALUES ('M1111', 'bugun kac gibi bulusuruz?', 'tonychopper', 'muadgra', 'GK1111');


--
-- Data for Name: Moderator; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Moderator" VALUES ('K1111', 'B1111          ');
INSERT INTO "OyunForumSchema"."Moderator" VALUES ('K1112', 'B1113          ');


--
-- Data for Name: OyunDisi; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--



--
-- Data for Name: OyunIci; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--



--
-- Data for Name: Profil; Type: TABLE DATA; Schema: OyunForumSchema; Owner: postgres
--

INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1111', 'Mert', '121', '22 ', 'mertcan@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1112', 'Hilmi', '74 ', '43 ', 'hilmiboztepe@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1113', 'Ayse', '3  ', '19 ', 'aysegursu@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1114', 'Mustafa', '64 ', '22 ', 'mustafatarik@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1115', 'Mehmet', '33 ', '51 ', 'mehmetorkun@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1116', 'Eda', '23 ', '36 ', 'edanuray@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1117', 'Erdi', '33 ', '28 ', 'erdikaynar@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P111', 'Mert', '0  ', '27 ', 'mrtcngkmn@hotmail.com');
INSERT INTO "OyunForumSchema"."Profil" VALUES ('P1', 'Mert', '4  ', '21 ', 'bbb@hotmail.com');


--
-- Name: Bolum Bolum_bolumAdi_key; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Bolum"
    ADD CONSTRAINT "Bolum_bolumAdi_key" UNIQUE ("bolumAdi");


--
-- Name: Admin adminPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Admin"
    ADD CONSTRAINT "adminPK" PRIMARY KEY ("kullanıcıID");


--
-- Name: Baslik baslikPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Baslik"
    ADD CONSTRAINT "baslikPK" PRIMARY KEY ("baslikNo");


--
-- Name: Bolum bolumNoPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Bolum"
    ADD CONSTRAINT "bolumNoPK" PRIMARY KEY ("bolumNo");


--
-- Name: Destek destekPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Destek"
    ADD CONSTRAINT "destekPK" PRIMARY KEY ("bolumNo");


--
-- Name: EngelliKullanici engelliKullanıcıIDPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."EngelliKullanici"
    ADD CONSTRAINT "engelliKullanıcıIDPK" PRIMARY KEY ("kullanıcıID");


--
-- Name: Genel Kutu genelKutuPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Genel Kutu"
    ADD CONSTRAINT "genelKutuPK" PRIMARY KEY ("genelKutuNo");


--
-- Name: Kullanici kullanıcıIDPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Kullanici"
    ADD CONSTRAINT "kullanıcıIDPK" PRIMARY KEY ("kullaniciID");


--
-- Name: Kurallar kurallarPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Kurallar"
    ADD CONSTRAINT "kurallarPK" PRIMARY KEY ("bolumNo");


--
-- Name: Mesaj mesajPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Mesaj"
    ADD CONSTRAINT "mesajPK" PRIMARY KEY ("mesajNo");


--
-- Name: Moderator moderatorPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Moderator"
    ADD CONSTRAINT "moderatorPK" PRIMARY KEY ("kullanıcıID");


--
-- Name: OyunDisi oyunDisiPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."OyunDisi"
    ADD CONSTRAINT "oyunDisiPK" PRIMARY KEY ("bolumNo");


--
-- Name: OyunIci oyunIcıPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."OyunIci"
    ADD CONSTRAINT "oyunIcıPK" PRIMARY KEY ("bolumNo");


--
-- Name: Profil profilNoPK; Type: CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Profil"
    ADD CONSTRAINT "profilNoPK" PRIMARY KEY ("profilNo");


--
-- Name: Kullanici adDegisince; Type: TRIGGER; Schema: OyunForumSchema; Owner: postgres
--

CREATE TRIGGER "adDegisince" BEFORE UPDATE ON "OyunForumSchema"."Kullanici" FOR EACH ROW EXECUTE FUNCTION "OyunForumSchema"."adDegisikligi"();


--
-- Name: Mesaj mesajIcerigiDegisince; Type: TRIGGER; Schema: OyunForumSchema; Owner: postgres
--

CREATE TRIGGER "mesajIcerigiDegisince" BEFORE UPDATE ON "OyunForumSchema"."Mesaj" FOR EACH ROW EXECUTE FUNCTION "OyunForumSchema"."mesajIcerikDegisikligi"();


--
-- Name: Profil seviyeKontrol; Type: TRIGGER; Schema: OyunForumSchema; Owner: postgres
--

CREATE TRIGGER "seviyeKontrol" BEFORE INSERT ON "OyunForumSchema"."Profil" FOR EACH ROW EXECUTE FUNCTION "OyunForumSchema"."seviyeDegisikligi"();


--
-- Name: Kullanici sifreDegisince; Type: TRIGGER; Schema: OyunForumSchema; Owner: postgres
--

CREATE TRIGGER "sifreDegisince" BEFORE UPDATE ON "OyunForumSchema"."Kullanici" FOR EACH ROW EXECUTE FUNCTION "OyunForumSchema"."sifreDegisikligi"();


--
-- Name: Baslik bolumBaslikNoFK; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Baslik"
    ADD CONSTRAINT "bolumBaslikNoFK" FOREIGN KEY ("bolumNo") REFERENCES "OyunForumSchema"."Bolum"("bolumNo");


--
-- Name: Destek bolumDestek; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Destek"
    ADD CONSTRAINT "bolumDestek" FOREIGN KEY ("bolumNo") REFERENCES "OyunForumSchema"."Bolum"("bolumNo") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Kurallar bolumKurallar; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Kurallar"
    ADD CONSTRAINT "bolumKurallar" FOREIGN KEY ("bolumNo") REFERENCES "OyunForumSchema"."Bolum"("bolumNo") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OyunDisi bolumOyunDisi; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."OyunDisi"
    ADD CONSTRAINT "bolumOyunDisi" FOREIGN KEY ("bolumNo") REFERENCES "OyunForumSchema"."Bolum"("bolumNo") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OyunIci bolumOyunIci; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."OyunIci"
    ADD CONSTRAINT "bolumOyunIci" FOREIGN KEY ("bolumNo") REFERENCES "OyunForumSchema"."Bolum"("bolumNo") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Kullanici genelKutuFK; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Kullanici"
    ADD CONSTRAINT "genelKutuFK" FOREIGN KEY ("genelKutuNo") REFERENCES "OyunForumSchema"."Genel Kutu"("genelKutuNo");


--
-- Name: Mesaj genelKutuNoFK; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Mesaj"
    ADD CONSTRAINT "genelKutuNoFK" FOREIGN KEY ("genelKutuNo") REFERENCES "OyunForumSchema"."Genel Kutu"("genelKutuNo");


--
-- Name: Baslik kullaniciBaslikFK; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Baslik"
    ADD CONSTRAINT "kullaniciBaslikFK" FOREIGN KEY ("kullaniciID") REFERENCES "OyunForumSchema"."Kullanici"("kullaniciID");


--
-- Name: EngelliKullanici kullaniciEngelliKullanici; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."EngelliKullanici"
    ADD CONSTRAINT "kullaniciEngelliKullanici" FOREIGN KEY ("kullanıcıID") REFERENCES "OyunForumSchema"."Kullanici"("kullaniciID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Moderator kullaniciModerator; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Moderator"
    ADD CONSTRAINT "kullaniciModerator" FOREIGN KEY ("kullanıcıID") REFERENCES "OyunForumSchema"."Kullanici"("kullaniciID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Admin moderatorAdmin; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Admin"
    ADD CONSTRAINT "moderatorAdmin" FOREIGN KEY ("kullanıcıID") REFERENCES "OyunForumSchema"."Moderator"("kullanıcıID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Moderator moderatorBolum; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Moderator"
    ADD CONSTRAINT "moderatorBolum" FOREIGN KEY ("bolumNo") REFERENCES "OyunForumSchema"."Bolum"("bolumNo");


--
-- Name: Kullanici profilFK; Type: FK CONSTRAINT; Schema: OyunForumSchema; Owner: postgres
--

ALTER TABLE ONLY "OyunForumSchema"."Kullanici"
    ADD CONSTRAINT "profilFK" FOREIGN KEY ("profilNumarasi") REFERENCES "OyunForumSchema"."Profil"("profilNo");


--
-- PostgreSQL database dump complete
--

