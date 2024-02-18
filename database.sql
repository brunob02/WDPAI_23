--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

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
-- Name: skill_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.skill_level AS ENUM (
    'beginner',
    'intermediate',
    'advanced'
);


ALTER TYPE public.skill_level OWNER TO postgres;

--
-- Name: add_user(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_user(p_email character varying, p_name character varying, p_surname character varying, p_password character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    email_count INT;
BEGIN
    BEGIN
        SELECT COUNT(*) INTO email_count FROM public.users WHERE email = p_email;
        
        IF email_count > 0 THEN
            RAISE EXCEPTION 'Podany e-mail jest już używany.';
        ELSE
            
            INSERT INTO public.users (email, name, surname, password)
            VALUES (p_email, p_name, p_surname, p_password);

            COMMIT;
            RAISE NOTICE 'Użytkownik został dodany pomyślnie.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RETURN; 
    END;
END;
$$;


ALTER FUNCTION public.add_user(p_email character varying, p_name character varying, p_surname character varying, p_password character varying) OWNER TO postgres;

--
-- Name: capitalize_name_surname(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.capitalize_name_surname() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.name := INITCAP(NEW.name); 
  NEW.surname := INITCAP(NEW.surname);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.capitalize_name_surname() OWNER TO postgres;

--
-- Name: dodaj_uzytkownika(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dodaj_uzytkownika(p_email character varying, p_name character varying, p_surname character varying, p_password character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    email_count INT;
BEGIN
    BEGIN
        SELECT COUNT(*) INTO email_count FROM public.users WHERE email = p_email;
        
        IF email_count > 0 THEN
            RAISE EXCEPTION 'Podany e-mail jest już używany.';
        ELSE
            INSERT INTO public.users (email, name, surname, password)
            VALUES (p_email, p_name, p_surname, p_password);

            COMMIT;
            RAISE NOTICE 'Użytkownik został dodany pomyślnie.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RETURN;
    END;
END;
$$;


ALTER FUNCTION public.dodaj_uzytkownika(p_email character varying, p_name character varying, p_surname character varying, p_password character varying) OWNER TO postgres;

--
-- Name: update_skill_level(integer, public.skill_level); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_skill_level(IN p_profile_id integer, IN p_new_skill_level public.skill_level)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE id = p_profile_id) THEN
        RAISE EXCEPTION 'Profil o podanym ID nie istnieje.';
    END IF;

    UPDATE public.profiles
    SET skill_level = p_new_skill_level
    WHERE id = p_profile_id;

    RAISE NOTICE 'Zaktualizowano skill_level dla profilu o ID % na %.', p_profile_id, p_new_skill_level;
END;
$$;


ALTER PROCEDURE public.update_skill_level(IN p_profile_id integer, IN p_new_skill_level public.skill_level) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: favourite_recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favourite_recipes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    recipe_id integer NOT NULL
);


ALTER TABLE public.favourite_recipes OWNER TO postgres;

--
-- Name: favourite_recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favourite_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favourite_recipes_id_seq OWNER TO postgres;

--
-- Name: favourite_recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favourite_recipes_id_seq OWNED BY public.favourite_recipes.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredients (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.ingredients OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredients_id_seq OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lists (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(50) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE public.lists OWNER TO postgres;

--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lists_id_seq OWNER TO postgres;

--
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lists_id_seq OWNED BY public.lists.id;


--
-- Name: lists_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lists_ingredients (
    id integer NOT NULL,
    list_id integer NOT NULL,
    ingredient_id integer NOT NULL,
    status boolean DEFAULT false NOT NULL,
    factor real DEFAULT 1,
    unit_id integer NOT NULL
);


ALTER TABLE public.lists_ingredients OWNER TO postgres;

--
-- Name: lists_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lists_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lists_ingredients_id_seq OWNER TO postgres;

--
-- Name: lists_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lists_ingredients_id_seq OWNED BY public.lists_ingredients.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    culinary_interests character varying(200),
    skill_level public.skill_level DEFAULT 'beginner'::public.skill_level NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_id_seq OWNER TO postgres;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200),
    duration smallint NOT NULL,
    no_servings smallint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    preparation text,
    image character varying(50),
    CONSTRAINT duration CHECK ((duration > 0)),
    CONSTRAINT no_servings CHECK ((no_servings > 0))
);


ALTER TABLE public.recipes OWNER TO postgres;

--
-- Name: recipes_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes_ingredients (
    id_recipe integer NOT NULL,
    id_ingredient integer NOT NULL,
    factor real DEFAULT 1,
    unit_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.recipes_ingredients OWNER TO postgres;

--
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    id integer NOT NULL,
    unit character varying(25) NOT NULL,
    abbreviation character varying(5) NOT NULL
);


ALTER TABLE public.units OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    name character varying(25) NOT NULL,
    surname character varying(25) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: recipe_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recipe_details AS
 SELECT r.id,
    r.user_id,
    r.name,
    r.description,
    r.duration,
    r.no_servings,
    r."timestamp",
    r.preparation,
    r.image,
    i.name AS ingredient_name,
    ri.factor,
    un.abbreviation AS unit_abbreviation,
    u.email AS user_email
   FROM ((((public.recipes r
     LEFT JOIN public.recipes_ingredients ri ON ((r.id = ri.id_recipe)))
     LEFT JOIN public.ingredients i ON ((ri.id_ingredient = i.id)))
     LEFT JOIN public.units un ON ((ri.unit_id = un.id)))
     JOIN public.users u ON ((r.user_id = u.id)))
  ORDER BY r.id;


ALTER VIEW public.recipe_details OWNER TO postgres;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_id_seq OWNER TO postgres;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: recipes_ingredients_id_serial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_ingredients_id_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_ingredients_id_serial_seq OWNER TO postgres;

--
-- Name: recipes_ingredients_id_serial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_ingredients_id_serial_seq OWNED BY public.recipes_ingredients.id;


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.units_id_seq OWNER TO postgres;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: users_favourite_recipes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.users_favourite_recipes AS
 SELECT u.email,
    u.name,
    u.surname,
    r.name AS liked_recipe
   FROM ((public.users u
     JOIN public.favourite_recipes fr ON ((u.id = fr.user_id)))
     JOIN public.recipes r ON ((fr.recipe_id = r.id)))
  ORDER BY u.email;


ALTER VIEW public.users_favourite_recipes OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: favourite_recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourite_recipes ALTER COLUMN id SET DEFAULT nextval('public.favourite_recipes_id_seq'::regclass);


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: lists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists ALTER COLUMN id SET DEFAULT nextval('public.lists_id_seq'::regclass);


--
-- Name: lists_ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists_ingredients ALTER COLUMN id SET DEFAULT nextval('public.lists_ingredients_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: recipes_ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes_ingredients ALTER COLUMN id SET DEFAULT nextval('public.recipes_ingredients_id_serial_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: favourite_recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favourite_recipes (id, user_id, recipe_id) FROM stdin;
1	1	1
2	1	2
3	1	6
4	1	3
5	2	1
6	2	5
7	2	8
8	3	4
9	3	7
10	3	2
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredients (id, name) FROM stdin;
1	﻿abalone
2	abiyuch
3	acerola
4	achilleas
5	acorn
6	adobo
7	adobo sauce
8	adzuki bean
9	agar
10	agave
11	akutaq
12	alaska blackfish
13	alaska pollock
14	alaska wild rhubarb
15	albacore tuna
16	ale
17	alfalfa
18	allium
19	allspice
20	almond
21	alpine sweetvetch
22	alpinia
23	amaranth
24	american butterfish
25	american pokeweed
26	american shad
27	anatidae
28	anchovy
29	angelica
30	anguilliformes
31	anise
32	anise brandy
33	anise hyssop
34	anise oil
35	apple
36	apple brandy
37	apple cider vinegar
38	apple juice
39	apple sauce
40	apricot
41	arabica coffee
42	arar
43	arepa
44	armagnac brandy
45	arrack
46	arrowhead
47	arrowroot
48	artemisia
49	artichoke
50	asafoetida
51	ascidians
52	ash gourd
53	ashgourd
54	asparagus
55	atlantic croaker
56	atlantic halibut
57	atlantic herring
58	atlantic mackerel
59	atlantic menhaden
60	atlantic pollock
61	atlantic salmon
62	atlantic wolffish
63	avocado
64	babaco
65	babassu palm
66	bagel
67	baked potato
68	baking mix
69	baking powder
70	bamboo shoots
71	banana
72	bantu beer
73	barbeque sauce
74	barley
75	bartlett pear
76	basil
77	basmati rice
78	bay laurel
79	bayberry
80	bean
81	beans
82	bear
83	bearded seal
84	beaver
85	beech nut
86	beef
87	beef processed
88	beefalo
89	beer
90	beet root
91	beetroot
92	beli
93	beluga whale
94	bergamot
95	berry wine
96	bilberry
97	bilberry wine
98	biscuit
99	bison
100	bitter cherry
101	bitter gourd
102	bitter orange
103	bittergourd
104	bivalvia
105	black bean
106	black bear
107	black crowberry
108	black currant
109	black huckleberry
110	black mulberry
111	black mustard seed oil
112	black pepper
113	black raspberry
114	black salsify
115	black tea
116	blackberry
117	blackberry brandy
118	black-eyed pea
119	blue cheese
120	blue whiting
121	blueberry
122	bluefish
123	bonito
124	borage
125	botrytized wine
126	bottle gourd
127	bottlegourd
128	bourbon whisky
129	bowhead whale
130	boysenberry
131	brandy
132	brazil nut
133	bread
134	breadfruit
135	breakfast cereal
136	broad whitefish
137	broccoli
138	brown bear
139	brown rice
140	brussels sprout
141	buchu
142	buckwheat
143	buffalo
144	buffalo currant
145	bulgur
146	burbot
147	burdock
148	burrito
149	butter
150	buttermilk
151	butternut
152	butternut squash
153	byrsonima crassifolia
154	cabbage
155	cajeput
156	cajun seasoning
157	cake
158	cake mix
159	calamus
160	camembert cheese
161	camphor
162	canada blueberry
163	canadian whisky
164	candied mixed fruit
165	candy bar
166	canola oil
167	capers
168	capsicum
169	caraway
170	caraway seed
171	cardamom
172	cardoon
173	caribou
174	carob
175	carom seed
176	carp bream
177	carrot
178	cascarilla
179	casein
180	cashew
181	cashew apple
182	cashew nut
183	cassava
184	cassia
185	catfish
186	catjang pea
187	cauliflower
188	caviar
189	cayenne
190	cedar
191	celery
192	ceriman
193	cetacea
194	chaat masala
195	chamomile
196	champaca
197	champagne
198	channel catfish
199	chanterelle
200	chard
201	charr
202	chayote
203	cheddar cheese
204	cheese
205	cherimoya
206	cherry
207	cherry brandy
208	cherry pepper
209	cherry tomato
210	chervil
211	chestnut
212	chewing gum
213	chia
214	chicken
215	chicken masala powder
216	chickpea
217	chicory
218	chimichanga
219	chinese bayberry
220	chinese chestnut
221	chinese five spice powder
222	chinese quince
223	chinook salmon
224	chive
225	chocolate
226	chocolate mousse
227	chocolate spread
228	chole masala
229	chum salmon
230	cichlidae
231	cider
232	cider vinegar
233	cinnamon
234	cisco
235	citric acid
236	citronella oil
237	citrus fruits
238	citrus limetta oil
239	citrus peel oil
240	clam
241	clary sage
242	climbing bean
243	cloud ear fungus
244	cloudberry
245	clove
246	clupeinae
247	cluster bean
248	cocktail
249	cocoa
250	cocoa butter
251	cocoa powder
252	coconut
253	coconut milk
254	coconut oil
255	codfish
256	coffee
257	coffee mocha
258	cognac brandy
259	coho salmon
260	cold cut
261	coleslaw
262	colocasia
263	colorado pinyon
264	columbidae
265	common carp
266	common dab
267	common ling
268	common octopus
269	common persimmon
270	common salsify
271	common tuna
272	common verbena
273	comte cheese
274	conch
275	condensed milk
276	cooking oil
277	cooking spray
278	coriander
279	coriander cumin seed powder
280	coriander cumin seeds powder
281	coriander oil
282	coriander seed
283	corn
284	corn chip
285	corn grit
286	corn grits
287	corn oil
288	corn salad
289	cornbread
290	cornmint
291	cottage cheese
292	cottonseed
293	couscous
294	crab
295	cracker crumb
296	cranberry
297	crayfish
298	cream
299	cream cheese
300	creole seasoning
301	creosote
302	crisp bread
303	crispbread
304	croaker
305	croissant
306	cucumber
307	cucurbita
308	cumin
309	cured ham
310	currant
311	curry leaf
312	curry powder
313	cusk
314	custard apple
315	cuttlefish
316	dabeli masala
317	dandelion
318	date
319	dates
320	deer
321	deerberry
322	devilfish
323	dill
324	dock
325	dolphin fish
326	domiati cheese
327	dried mixed fruit
328	drumstick leaf
329	dulce de leche
330	dumpling
331	durian
332	egg
333	egg plant
334	egg roll
335	eggplant
336	elderberry
337	elk
338	elliott's blueberry
339	emmental cheese
340	empanada
341	emu
342	enchilada
343	endive
344	enokitake
345	epazote
346	eucalyptus oil
347	european anchovy
348	european chestnut
349	european rabbit
350	evaporated milk
351	evening primrose
352	falafel
353	fatty fish
354	feijoa
355	fennel
356	fenugreek
357	fermented tea
358	feta cheese
359	fettuccine
360	fig
361	filbert
362	finnish whisky
363	fir
364	fireweed
365	fish
366	fish burger
367	fish oil
368	flatfish
369	flax seed
370	flaxseed
371	florida pompano
372	flour
373	focaccia
374	food coloring
375	frankfurter sausage
376	french bean
377	french plantain
378	french toast
379	freshwater drum
380	freshwater eel
381	fried potato
382	fruit gum
383	fruit juice
384	fruit salad
385	frybread
386	fudge
387	gadiformes
388	garam masala
389	garcinia indica
390	garden cress
391	garfish
392	garland chrysanthemum
393	garlic
394	gefilte fish
395	gelatin
396	gelatin dessert
397	geranium
398	ghee
399	giant butterbur
400	gin
401	ginger
402	ginger garlic coriander leaves
403	ginger garlic paste
404	ginkgo nuts
405	ginseng
406	goat cheese
407	goat milk
408	goda masala
409	gooseberry
410	gram bean
411	grape
412	grapefruit
413	grapefruit peel oil
414	grass
415	grass pea
416	great horned owl
417	greater sturgeon
418	green beans
419	green bell pepper
420	green chutney
421	green tea
422	green turtle
423	green zucchini
424	greenland halibut
425	greenthread tea
426	greylag goose
427	grind ginger garlic and coriander leaves
428	groundcherry
429	grouper
430	gruyere cheese
431	guava
432	guinea hen
433	gulkand
434	haddock
435	half half
436	halibut
437	ham
438	hamburger
439	hard wheat
440	hazelnut
441	heart of palm
442	hedge mustard
443	herbe de provence
444	herring
445	hibiscus tea
446	hippoglossus
447	hogplum
448	hoisin sauce
449	honey
450	honeydew
451	hops
452	hops beer
453	hops oil
454	horchata
455	horned melon
456	horse
457	horseradish
458	hot chocolate
459	hot dog
460	hot sauce
461	hummus
462	hushpuppy
463	hyacinth
464	hyacinth bean
465	hyssop oil
466	ice cream
467	ice cream cone
468	icing
469	irish moss
470	italian seasoning
471	jackfruit
472	jal jeera powder
473	jalapeno
474	japanese chestnut
475	japanese persimmon
476	japanese pumpkin
477	japanese whisky
478	jasmine
479	jellyfish
480	jerusalem artichoke
481	jew's ear
482	jicama
483	jostaberry
484	jujube
485	junket
486	jute
487	kai lan
488	kale
489	kefir
490	kelp
491	kenaf
492	ketchup
493	kewda
494	kidney bean
495	kidney beans
496	king mackerel
497	kiwi
498	kiwifruit
499	kohlrabi
500	komatsuna
501	kombu
502	krill
503	kumquat
504	lake trout
505	lamb
506	lambsquarters
507	lard
508	lasagna
509	laurel
510	lavendar
511	lean fish
512	leather chiton
513	leavening agent
514	leek
515	lemon
516	lemon balm
517	lemon grass
518	lemon juice
519	lemon peel oil
520	lemon sole
521	lemon verbena
522	lemongrass oil
523	lentils
524	lettuce
525	lima beans
526	limburger cheese
527	lime
528	lime peel oil
529	linden
530	lingcod
531	lingonberry
532	liqourice
533	liquid smoke
534	litchi
535	lobster
536	loganberry
537	longan
538	loquat
539	lotus
540	lotus oil
541	lovage
542	lumpsucker
543	lupine
544	macadamia nut
545	macaroni
546	mace
547	mackerel
548	madeira wine
549	madras curry powder
550	maitake
551	malabar plum
552	malabar spinach
553	malay apple
554	malt
555	malt whisky
556	mammee apple
557	mandarin
558	mandarin orange
559	mandarin orange peel oil
560	mango
561	maple syrup
562	margarine
563	marjoram
564	marshmallow
565	marzipan
566	mascarpone
567	mastic gum
568	mate
569	mayonnaise
570	meat
571	meat bouillon
572	meatball
573	meatloaf
574	medlar
575	melon
576	mentha oil
577	meringue
578	mexican groundcherry
579	mexican oregano
580	milk
581	milk fat
582	milk human
583	milk powder
584	milkfish
585	milkshake
586	millet
587	mint
588	miso
589	mixed nuts
590	mixed vegetables
591	molasses
592	mollusc
593	monkfish
594	monosodium glutamate
595	moose
596	morchella
597	moth bean
598	mountain hare
599	mountain papaya
600	mountain yam
601	mozzarella cheese
602	mulberry
603	mule deer
604	multigrain bread
605	mung bean
606	munster cheese
607	muscadine grape
608	mushroom
609	musk melon
610	muskmallow
611	muskmelon
612	muskrat
613	mustard
614	mustard greens oil
615	mustard oil
616	mutton
617	myrrh
618	myrtle
619	nachos
620	nance
621	nanking cherry
622	naranjilla
623	narrowleaf cattail
624	natal plum
625	natto
626	neroli oil
627	new zealand spinach
628	nigella seed
629	nopal
630	north pacific giant octopus
631	northern bluefin tuna
632	northern pike
633	norway haddock
634	norway pout
635	nougat
636	nutmeg
637	nuttall cockle
638	oat
639	oat bread
640	oats
641	ocean pout
642	octopus
643	ohelo berry
644	oil palm
645	oil-seed camellia
646	okra
647	old bay seasoning
648	olive
649	onion
650	opossum
651	orange
652	orange juice
653	orange oil
654	orange roughy
655	oregano
656	oregon yampah
657	oriental wheat
658	orris
659	ostrich
660	ostrich fern
661	oyster
662	oyster mushroom
663	pacific herring
664	pacific jack mackerel
665	pacific ocean perch
666	pacific rockfish
667	pacific sardine
668	painted comber
669	pak choy
670	pan dulce
671	pancake
672	pancetta
673	panch pharon seed
674	paneer
675	papaya
676	papaya brandy
677	parmesan cheese
678	parsley
679	parsnip
680	passionfruit
681	pasta
682	pastry
683	pate
684	pawpaw
685	pea
686	peach
687	peanut
688	peanut butter
689	peanut oil
690	pear
691	pear brandy
692	peas
693	pecans
694	pectin
695	pepino
696	pepper
697	peppermint
698	perch
699	perciformes
700	percoidei
701	persimmon
702	pheasant
703	phyllo
704	phyllo dough
705	pie
706	pie crust
707	pigeon pea
708	pikeperch
709	piki bread
710	pili nut
711	pine
712	pineapple
713	pineappple sage
714	pink salmon
715	pistachio
716	pita bread
717	pitanga
718	pizza
719	pleuronectidae
720	plum
721	plum brandy
722	plum wine
723	plumcot
724	polar bear
725	pollock
726	pomegranate
727	popcorn
728	poppy seed
729	pork
730	port wine
731	pot pie
732	potato
733	potato bread
734	potato chip
735	potato gratin
736	potato puffs
737	poultry seasoning
738	pout
739	prairie turnip
740	prawn
741	prickly pear
742	prosciutto
743	provolone cheese
744	pudding
745	puff pastry
746	pulao masala
747	pummelo
748	pumpkin
749	pumpkinseed sunfish
750	pupusa
751	purple laver
752	purple mangosteen
753	purslane
754	quail
755	quesadilla
756	quince
757	quinoa
758	rabbit
759	raccoon
760	radish
761	rainbow smelt
762	rainbow trout
763	raisin
764	raisin bread
765	rambutan
766	ranch dressing
767	rapini
768	rasam powder
769	raspberry
770	raspberry brandy
771	ravioli
772	red algae
773	red currant
774	red king crab
775	red raspberry
776	red rice
777	red sage
778	red wine
779	redskin onion
780	relish
781	remoulade
782	rhubarb
783	rice
784	rice basmati
785	rice bread
786	rice cake
787	ricotta cheese
788	ringed seal
789	roasted almond
790	roasted onion
791	rock ptarmigan
792	rocket salad
793	roe
794	roibos tea
795	romano cheese
796	roquefort cheese
797	rose
798	rose hip
799	rose wine
800	roseapple
801	roselle
802	rosemary
803	rowal
804	rowanberry
805	rum
806	russian cheese
807	rutabaga
808	rye
809	rye bread
810	sablefish
811	safflower
812	saffron
813	sage
814	sago palm
815	sake
816	salad
817	salad creme
818	salad dressing
819	salmon
820	salmonberry
821	salmonidae
822	salt
823	salt-pepper
824	sambar powder
825	sandalwood
826	sapodilla
827	saskatoon berry
828	sassafras
829	satsuma orange
830	sauerkraut
831	sausage
832	scallop
833	scarlet bean
834	scombridae
835	scotch
836	scotch spearmint
837	scrapple
838	scup
839	sea buckthorns
840	sea cucumber
841	sea trout
842	seal
843	self rising flour
844	semolina
845	sesame
846	sesame oil
847	sesame seed
848	sesbania flower
849	shallot
850	shark
851	shea tree
852	sheefish
853	sheep cheese
854	sheep milk
855	sheepshead
856	shellfish
857	sherry
858	shiitake
859	shortening
860	shrimp
861	silver linden
862	skimmed milk
863	skunk currant
864	small leaf linden
865	smelt
866	smoked fish
867	snack bar
868	snail
869	snapper
870	sockeye salmon
871	soft drink
872	sorghum
873	sorrel
874	soup
875	sour cherry
876	sourdock
877	sourdough
878	soursop
879	southern pea
880	soy cream
881	soy milk
882	soy sauce
883	soy yogurt
884	soybean
885	soybean oil
886	soybean sauce
887	spanish mackerel
888	spanish sage
889	sparkleberry
890	sparkling wine
891	spearmint
892	spelt
893	spinach
894	spinach fettuccine
895	spineless monkey orange
896	spiny dogfish
897	spiny lobster
898	spirit
899	spirulina
900	sponge cake
901	spot croaker
902	spotted seal
903	spread
904	squab
905	squashberry
906	squid
907	squirrel
908	star anise
909	starfruit
910	steller sea lion
911	stew
912	storax
913	strawberry
914	strawberry jam
915	strawberry wine
916	striped bass
917	striped mullet
918	stuffing
919	sturgeon
920	succotash
921	sugar
922	sukiyaki
923	summer savory
924	sunflower
925	sunflower oil
926	swamp cabbage
927	sweet cherry
928	sweet custard
929	sweet grass
930	sweet potato
931	sweetcorn
932	swiss cheese
933	swordfish
934	syrup
935	taco
936	tahini
937	tamale
938	tamarind
939	tandoori masala
940	tandoori paste
941	tangerine
942	tapioca pearl
943	taro
944	tarragon
945	tart shell
946	tartary buckwheat
947	tea
948	tea leaf oil
949	tea leaf willow
950	teff
951	tequila
952	thistle
953	thyme
954	tilefish
955	tilsit cheese
956	tinda
957	tobacco
958	toffee
959	tofu
960	tomato
961	tomato juice
962	tomato paste
963	tomato puree
964	topping
965	tortilla
966	tortilla chip
967	tostada
968	towel gourd
969	trail mix
970	trassi
971	tree fern
972	triticale
973	trout
974	true frog
975	true seal
976	true sole
977	truffle
978	tuna
979	turbot
980	turkey
981	turkey berry
982	turmeric
983	turnip
984	ucuhuba
985	valerian
986	vanilla
987	vanilla oil
988	vegetable broth
989	vegetable juice
990	vegetable stock
991	vermicelli
992	vermouth
993	vinegar
994	vodka
995	waffle
996	wakame
997	walleye
998	walnut
999	walrus
1000	wasabi
1001	water
1002	water chestnut
1003	waterchestnut
1004	watercress
1005	wattle
1006	weinbrand brandy
1007	welsh onion
1008	whale
1009	wheat
1010	wheaten bread
1011	whelk
1012	whey
1013	whisky
1014	white bread
1015	white currant
1016	white lupine
1017	white pepper
1018	white sucker
1019	white wine
1020	whitefish
1021	whiting
1022	wholewheat bread
1023	wild boar
1024	wild duck
1025	wild rice
1026	wine
1027	winged bean
1028	winter savory
1029	winter squash
1030	wonton wrapper
1031	woodapple
1032	worcestershite sauce
1033	wort
1034	yam
1035	yardlong bean
1036	yarrow
1037	yautia
1038	yeast
1039	yellow passionfruit
1040	yellow pond lily
1041	yellowfin tuna
1042	yellowtail amberjack
1043	ylang-ylang
1044	ymer
1045	yogurt
1046	zucchini
1047	zwieback
\.


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lists (id, user_id, name, "timestamp") FROM stdin;
1	1	my first list	2024-01-17 10:00:00
2	1	my 2d list	2024-01-24 10:00:00
3	1	next list	2024-01-25 12:00:00
4	3	tomorrow shopping	2024-01-17 17:00:00
5	3	my new list	2024-01-20 17:00:00
6	2	ingredients	2024-01-17 11:00:00
7	1	shopping list	2024-01-30 13:00:00
\.


--
-- Data for Name: lists_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lists_ingredients (id, list_id, ingredient_id, status, factor, unit_id) FROM stdin;
2	1	73	t	6	12
1	1	15	t	1	5
3	1	712	f	0.5	17
4	2	732	f	2.5	18
5	2	462	t	3	13
6	1	632	t	8	10
7	2	129	t	0.8	3
8	2	932	t	1	6
9	3	732	t	4	8
10	3	215	f	3	10
11	3	642	f	2	18
12	3	226	t	1.5	19
14	3	839	f	0.2	10
13	3	553	f	6	17
34	2	864	t	1	2
33	4	221	t	2	7
32	4	223	f	0.4	4
31	3	321	f	0.5	10
30	3	123	f	5	13
29	2	872	t	4	14
28	1	658	t	2	10
27	7	322	t	1	6
26	7	482	t	1	5
25	7	984	f	6	18
24	7	649	f	1	17
23	6	236	f	0.125	7
22	6	932	f	0.9	6
21	5	329	f	0.8	5
20	5	338	f	3.5	2
19	5	932	t	4	6
18	4	120	t	1	2
17	4	430	t	3	1
16	4	590	t	1	12
15	3	439	t	0.1	6
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, culinary_interests, skill_level) FROM stdin;
2	pasta, Italy	intermediate
4	\N	beginner
7	Ok	intermediate
1		advanced
3	french fries, hot dogs, cheeseburgers	intermediate
5	\N	beginner
6	\N	advanced
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (id, user_id, name, description, duration, no_servings, "timestamp", preparation, image) FROM stdin;
2	1	Apple Pie	I remember coming home sullen one day because we'd lost a softball game. Grandma, in her wisdom, suggested that maybe a slice of hot apple pie would make me feel better. She was right.	80	8	2024-01-01 13:00:00	Preheat oven to 375°. On a lightly floured surface, roll half the dough to a 1/8-in.-thick circle; transfer to a 9-in. pie plate. Chill while preparing filling. In a small bowl, combine sugars, flour and spices. In a large bowl, toss apples with lemon juice. Add sugar mixture; toss to coat. Add filling to crust; dot with butter.\nRoll remaining dough to a 1/8-in.-thick circle. Place over filling. Trim, seal and flute edge. Cut slits in top. Beat egg white until foamy; brush over crust. If desired, sprinkle with turbinado sugar and ground cinnamon.\nBake on the lowest rack 60-70 minutes, until crust is golden brown and filling is bubbly, covering with foil halfway if crust begins to get too dark. Cool on a wire rack. If desired, serve with ice cream and caramel sauce.	apple_pie.jpg
3	3	Cauliflower Soup	This cheesy recipe is way tastier than any other cauliflower soup I've tried! We like it with hot pepper sauce for a little extra kick.	30	6	2024-01-01 20:00:00	In a Dutch oven, combine the cauliflower, carrot, celery, water and bouillon. Bring to a boil. Reduce heat; cover and simmer for 12-15 minutes or until vegetables are tender (do not drain).\nIn a large saucepan, melt butter. Stir in the flour, salt and pepper until smooth. Gradually add milk. Bring to a boil over medium heat; cook and stir for 2 minutes or until thickened. Reduce heat. Stir in the cheese until melted, adding hot pepper sauce if desired. Stir into the cauliflower mixture.	cauliflower_soup.jpg
1	1	Banana Bread	Whenever I pass a display of bananas in the grocery store, I can almost smell the wonderful aroma of my best banana bread recipe. It really is amazingly good!	75	2	2024-01-01 12:00:00	Preheat oven to 350°. In a large bowl, stir together flour, sugar, baking soda and salt. In another bowl, combine the eggs, bananas, oil, buttermilk and vanilla; add to flour mixture, stirring just until combined. If desired, fold in nuts.\nPour into a greased or parchment-lined 9x5-in. loaf pan. Bake until a toothpick comes out clean, 1-1/4 to 1-1/2 hours. Cool in pan for 15 minutes before removing to a wire rack.	banana_bread.jpg
4	1	Pig Pickin' Cake	It’s a summery cake that tastes like a bite of sunshine, and with a name so unique, it’s bound to be a conversation starter.	120	5	2024-01-02 00:00:00	Preheat the oven to 350°F. In a large bowl, use a hand mixer or stand mixer to beat the cake mix, oranges, egg whites and applesauce on low speed for two minutes.\nGrease a 13×9-inch baking dish with cooking spray. Pour in the batter. Using a mini offset spatula or the back of a spoon, evenly spread the cake batter in the dish.\nBake the cake until a toothpick inserted in the center comes out clean, 25 to 30 minutes. Cool the cake completely to room temperature on a wire rack.\nIn a bowl, whisk together the pineapple and pudding mix. Fold in the whipped topping just until blended.\nSpread the topping over the cooled cake. Using the back of a spoon or a mini offset spatula, create swoops in the topping to add more dimension. Refrigerate the cake for at least one hour before serving.	pig_picking_cake.jpg
5	3	Baked Spaghetti	Every time that I make this cheesy baked spaghetti, I get requests for the recipe. It puts a different spin on pasta and is great for any meal.	60	12	2024-01-02 07:00:00	In a large skillet, saute onion and green pepper in butter until tender. Add the tomatoes, mushrooms, olives, oregano and, if desired, ground beef. Simmer, uncovered, for 10 minutes.\nPlace half of the spaghetti in a greased 13x9-in. baking dish. Layer with half of the vegetable mixture and 1 cup cheddar cheese. Repeat layers.\nIn a small bowl, combine soup and water until smooth; pour over casserole. Sprinkle with Parmesan cheese. Bake, uncovered, at 350° until heated through, 30-35 minutes.	baked_spaghetti.jpg
6	1	Pumpkin Bread	A classic autumnal treat, our pumpkin bread recipe uses pantry staples and comes together quickly. It’s so easy, you don’t even need a mixer.	180	10	2024-02-02 08:00:00	First, preheat your oven to 350°F. In a bowl, combine the flour, sugar, baking soda, cinnamon, salt, baking powder, nutmeg and cloves. Whisk together until well combined. In another bowl, whisk together the eggs, pumpkin, oil and water. Stir the flour mixture into the egg mixture until just moistened. If adding walnuts and raisins, gently fold them in last.\nPour the pumpkin mixture into a greased 9×5-inch loaf pan. Bake until a toothpick inserted into the center of the loaf comes out clean, 65 to 70 minutes. If the toothpick tester comes out with crumbs or wet batter, continue cooking in 5-to-10-minute increments, testing the bread until the toothpick comes out clean.\nIt’s almost impossible not to cut a slice right away, but let the bread rest. The bread will be better for it. Let the bread cool in the pan for 10 minutes.	pumpkin_bread.jpg
7	4	Potato Soup	You'll be surprised at the taste of this rich and cheesy easy potato soup. It really is the best potato soup recipe, ever.	30	8	2024-02-07 10:30:00	In a large saucepan, cook bacon over medium heat until crisp, stirring occasionally; drain drippings. Add vegetables, seasonings and broth; bring to a boil. Reduce heat; simmer, covered, until potatoes are tender, 10-15 minutes.\nIn a large saucepan, cook bacon over medium heat until crisp, stirring occasionally; drain drippings. Add vegetables, seasonings and broth; bring to a boil. Reduce heat; simmer, covered, until potatoes are tender, 10-15 minutes.	potato_soup.jpg
8	4	Asian Chicken Thighs	If you’re looking for a chicken dish that’s tender, juicy and loaded with flavor, look to Asian chicken thigh recipes. This recipe in particular is a great choice for anytime-meals.	100	4	2024-02-07 11:30:00	In a large skillet, heat the olive oil over medium heat. Add the chicken thighs, and cook until golden brown, 8 to 10 minutes on each side.\nIn a small bowl, whisk the water, brown sugar, orange juice, soy sauce, ketchup, vinegar, garlic, crushed red pepper flakes and five-spice powder.\nPour the sauce over the chicken in the skillet. Bring the sauce to a boil. Then, reduce the heat. Simmer, uncovered, until the chicken is tender and cooked to at least 165°F, 30 to 35 minutes, turning the chicken occasionally.	asian_chicken_thighs.jpg
94	1	French fries	From potato	20	1	2024-02-13 01:57:00	Very easy	french_fries.jpg
91	1	Classic Ham & Mushroom Pizza	Whip up a delicious ham & mushroom pizza at home! You'll make a simple tomato sauce to spread over our flame-baked pizza bases.	1	2	2024-02-13 01:50:00	Preheat the oven to 200°C/ 180°C (fan)/ 395°F/ Gas 6\r\n\r\nPut a large baking tray (or two) in the oven to heat up (this will stop the pizza bottoms from going soggy!)\r\n\r\nPeel and finely chop (or grate) the garlic\r\nAdd the tomato paste to a bowl with the chopped garlic and a generous pinch of salt, pepper and sugar\r\n	classic_ham_mushroom_pizza.jpg
\.


--
-- Data for Name: recipes_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes_ingredients (id_recipe, id_ingredient, factor, unit_id, id) FROM stdin;
1	1	1	1	1
1	100	4	7	2
1	55	0.7	4	3
1	23	2	4	4
2	33	3	3	5
2	47	5	12	6
2	2	0.2	18	7
2	201	0.7	5	8
2	446	3.5	20	9
3	551	1.2	7	10
3	881	1.9	2	11
3	348	2	13	12
3	660	1	16	13
4	13	1	19	14
4	23	8	18	15
4	33	2	17	16
4	43	2.5	10	17
5	243	1.2	5	18
5	344	0.3	7	19
5	777	3	1	20
5	555	1.2	2	21
5	999	1.3	20	22
6	912	1.5	10	23
6	174	1	16	24
6	374	2	19	25
7	285	1.5	16	26
7	753	0.3	11	27
8	383	0.5	15	28
8	973	4	19	29
8	299	2.5	12	30
8	380	0.1	8	31
8	621	1	1	32
91	732	1	17	39
91	960	250	15	40
94	925	0.5	2	41
94	732	0.5	17	42
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.units (id, unit, abbreviation) FROM stdin;
1	milliliter	ml
2	liter	l
3	deciliter	dl
4	teaspoon	tsp
5	dessertspoon	dsp
6	tablespoon	tbsp
7	fluid ounce	fl oz
8	cup	c
9	pint	pt
10	quart	qt
11	gallon	gal
12	smidgen	sm
13	dash	ds
14	milligram	mg
15	gram	g
16	decigram	dg
17	kilogram	kg
18	pound	lb
19	ounce	oz
20	grain	gr
21	stick	st
22	millimeter	mm
23	centimeter	cm
24	decimeter	dm
25	inch	in
26	each	ea
27	dozen	dz
28	gross	gr
29	score	sc
30	pinch	p
31	handful	hf
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, name, surname, password) FROM stdin;
1	jankowalski@gmail.com	Jan	Kowalski	$2y$10$FP4GWomlGGOBlzELjjuZ2uhJl2NMvQNDU0w8y1wsOibWWOiUB.XOG
2	annanowak@mail.com	Anna	Nowak	$2y$10$RSveaXDLEQI0dEa9.d/MdO/p11LpAsb0Iuvq6RTmJ0dF8MH79HTuK
3	johnsmith@gmail.com	John	Smith	$2y$10$B.XGV7q.KzD3GPjD6hCmeeKhTnQCoNYsQhdC3o26kZ/YupdJD1FV.
4	willjohnson@gmail.com	William	Johnson	$2y$10$j4cU7hBVHpMGVImsrtRILe0cE6un.Jf.PnEkV8kywkjNbwbIM6Bvq
5	antoni@wisniewski.com	Antoni	Wiśniewski	$2y$10$3EXRCJykE/MwMInnU1D7Ye8iT.0lO3vIMBIaJIWIEEbu2kYGA2LeG
6	mariapaj@ak.pl	Maria	Pajak	$2y$10$c7vsR/LP.idbXnXIWclzD.Yh5fkRIN4m59qpCNqyOXjVra2HfGKA2
7	mary@jane.en	Mary	Jane	$2y$10$5Cb53CbNJrIiWk6xqxd9QuWj3L7igPQCIA218fGq.uaDRHlyx4aWO
\.


--
-- Name: favourite_recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favourite_recipes_id_seq', 1, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 1047, true);


--
-- Name: lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lists_id_seq', 1, false);


--
-- Name: lists_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lists_ingredients_id_seq', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profiles_id_seq', 5, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_id_seq', 94, true);


--
-- Name: recipes_ingredients_id_serial_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_ingredients_id_serial_seq', 42, true);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.units_id_seq', 31, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: lists_ingredients factor; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.lists_ingredients
    ADD CONSTRAINT factor CHECK ((factor > (0)::double precision)) NOT VALID;


--
-- Name: recipes_ingredients factor; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.recipes_ingredients
    ADD CONSTRAINT factor CHECK ((factor > (0)::double precision)) NOT VALID;


--
-- Name: favourite_recipes favourite_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourite_recipes
    ADD CONSTRAINT favourite_recipes_pkey PRIMARY KEY (id);


--
-- Name: lists_ingredients id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists_ingredients
    ADD CONSTRAINT id PRIMARY KEY (id);


--
-- Name: recipes_ingredients ids; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT ids UNIQUE (id_recipe, id_ingredient);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: lists_ingredients lists_ingredients_list_id_ingredient_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists_ingredients
    ADD CONSTRAINT lists_ingredients_list_id_ingredient_id_key UNIQUE (list_id, ingredient_id);


--
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: ingredients name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT name UNIQUE (name);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: recipes_ingredients recipes_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: units units_unit_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_unit_key UNIQUE (unit);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users capitalize_name_surname_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER capitalize_name_surname_trigger BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.capitalize_name_surname();


--
-- Name: lists_ingredients ingredient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists_ingredients
    ADD CONSTRAINT ingredient_id FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) NOT VALID;


--
-- Name: lists_ingredients list_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists_ingredients
    ADD CONSTRAINT list_id FOREIGN KEY (list_id) REFERENCES public.lists(id) NOT VALID;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: favourite_recipes recipe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourite_recipes
    ADD CONSTRAINT recipe_id FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: recipes_ingredients recipes_ingredients_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredients(id) NOT VALID;


--
-- Name: recipes_ingredients recipes_ingredients_id_recipe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_id_recipe_fkey FOREIGN KEY (id_recipe) REFERENCES public.recipes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recipes_ingredients recipes_ingredients_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) NOT VALID;


--
-- Name: lists_ingredients unit_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists_ingredients
    ADD CONSTRAINT unit_id FOREIGN KEY (unit_id) REFERENCES public.units(id) NOT VALID;


--
-- Name: favourite_recipes user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourite_recipes
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: lists user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recipes user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

