# Template Ontwerpen — Loïs 13 jaar! 🎂

Alle templates zijn **400px breed** en hebben een **staand (portrait)** formaat.  
De achtergrond is altijd donkerpaars (`#1A0033`) met confetti-stippen.  
Elke template is een afgeronde kaart (`cornerRadius: 20`) met schaduw.

---

## Kleurpalet

| Naam            | Hex       | Gebruik                             |
|-----------------|-----------|-------------------------------------|
| Dieppaars       | `#1A0033` | Template-achtergrond                |
| Birthday Pink   | `#FF6B9D` | Bovenbanner, accenten               |
| Birthday Gold   | `#FFD700` | Middelste label-strip               |
| Birthday Purple | `#9B59B6` | Onderbaner, gradient                |
| Wit             | `#FFFFFF` | Foto-kader (padding rondom foto's)  |

---

## Template 1 — Één shot (400 × 560 px)

```
┌─────────────────────────────────────────┐  ← achtergrond #1A0033 + confetti
│                                         │
│  ╔═══════════════════════════════════╗  │
│  ║  🎂  Loïs 13 jaar!  🎂           ║  │  ← banner: #FF6B9D, wit tekst, h=52px
│  ╠═══════════════════════════════════╣  │
│  ║                                   ║  │
│  ║  ┌─────────────────────────────┐  ║  │
│  ║  │                             │  ║  │  ← witte padding 12px
│  ║  │                             │  ║  │
│  ║  │       SELFIE-FOTO           │  ║  │  ← foto: 360 × 360 px, scaledToFill
│  ║  │       (360 × 360)           │  ║  │
│  ║  │                             │  ║  │
│  ║  └─────────────────────────────┘  ║  │
│  ║                                   ║  │
│  ╠═══════════════════════════════════╣  │
│  ║  ⭐️  Happy Birthday!  ⭐️          ║  │  ← strip: #FFD700, dieppaarse tekst
│  ╠═══════════════════════════════════╣  │
│  ║   Photobooth @ Loïs 13            ║  │  ← onderste balk: #9B59B6, witte tekst
│  ║   🎈  🎉  🎈                      ║  │
│  ╚═══════════════════════════════════╝  │
│                                         │
└─────────────────────────────────────────┘

Totale kaarthoogte: ≈ 510px binnen 560px canvas
Maten:
  - Top banner:   384 × 52px
  - Foto-kader:   384 × 384px  (12px padding wit rondom 360×360 foto)
  - Gouden strip: 384 × 38px
  - Onderste balk: 384 × 52px
```

---

## Template 2 — Twee shots (400 × 900 px)

```
┌─────────────────────────────────────────┐  ← achtergrond #1A0033 + confetti + sterren
│                                         │
│  ╔═══════════════════════════════════╗  │
│  ║  🎂  Loïs 13 jaar!  🎂           ║  │  ← banner: #FF6B9D, h=58px
│  ║  Fotostrip                        ║  │
│  ╠═══════════════════════════════════╣  │
│  ║                                   ║  │
│  ║  ┌─────────────────────────────┐  ║  │
│  ║  │                             │  ║  │
│  ║  │       FOTO  1               │  ║  │  ← foto 1: 360 × 280px
│  ║  │                             │  ║  │
│  ║  └─────────────────────────────┘  ║  │
│  ║  ┌─────────────────────────────┐  ║  │  ← 8px gap tussen foto's
│  ║  │                             │  ║  │
│  ║  │       FOTO  2               │  ║  │  ← foto 2: 360 × 280px
│  ║  │                             │  ║  │
│  ║  └─────────────────────────────┘  ║  │
│  ║  (witte achtergrond, 12px padding) ║  │
│  ╠═══════════════════════════════════╣  │
│  ║  🎈  Happy 13th Birthday!  🎈    ║  │  ← strip: #FFD700, h=38px
│  ╠═══════════════════════════════════╣  │
│  ║  🌟  Loïs • 13 jaar  🌟           ║  │  ← onderste balk: #9B59B6, h=46px
│  ╚═══════════════════════════════════╝  │
│                                         │
└─────────────────────────────────────────┘

Totale kaarthoogte: ≈ 842px binnen 900px canvas
Maten:
  - Top banner:    384 × 58px
  - Foto-kader:    384 × 608px  (12px padding + 2× 280px foto + 8px gap)
  - Gouden strip:  384 × 38px
  - Onderste balk: 384 × 46px
```

---

## Template 3 — Drie shots (400 × 1240 px)

```
┌─────────────────────────────────────────┐  ← achtergrond: gradient #1A0033→#2D0A4E
│                                         │     + confetti + sterren + ballonnen
│  ╔═══════════════════════════════════╗  │
│  ║  🎂  Loïs 13 jaar!  🎂           ║  │  ← banner: gradient Pink→Purple, h=64px
│  ║  De klassieke fotostrip            ║  │
│  ╠═══════════════════════════════════╣  │
│  ║                                   ║  │
│  ║  ┌─────────────────────────┬──┐   ║  │
│  ║  │                         │#1│   ║  │  ← foto 1: 360 × 240px
│  ║  │        FOTO  1          └──┘   ║  │     shotlabel #1 rechtsonder
│  ║  │                             │  ║  │
│  ║  └─────────────────────────────┘  ║  │
│  ║  ┌─────────────────────────┬──┐   ║  │  ← 8px gap
│  ║  │                         │#2│   ║  │  ← foto 2: 360 × 240px
│  ║  │        FOTO  2          └──┘   ║  │     shotlabel #2 rechtsonder
│  ║  │                             │  ║  │
│  ║  └─────────────────────────────┘  ║  │
│  ║  ┌─────────────────────────┬──┐   ║  │  ← 8px gap
│  ║  │                         │#3│   ║  │  ← foto 3: 360 × 240px
│  ║  │        FOTO  3          └──┘   ║  │     shotlabel #3 rechtsonder
│  ║  │                             │  ║  │
│  ║  └─────────────────────────────┘  ║  │
│  ║  (witte achtergrond, 12px padding) ║  │
│  ╠═══════════════════════════════════╣  │
│  ║  ⭐️  Happy 13th Birthday Loïs!  ⭐️ ║  │  ← strip: #FFD700, h=38px
│  ╠═══════════════════════════════════╣  │
│  ║  🎈  Loïs • 13 jaar • Photobooth  ║  │  ← balk: gradient Purple→Pink, h=50px
│  ╚═══════════════════════════════════╝  │
│                                         │
└─────────────────────────────────────────┘

Totale kaarthoogte: ≈ 1180px binnen 1240px canvas
Maten:
  - Top banner:    384 × 64px
  - Foto-kader:    384 × 784px  (12px padding + 3× 240px foto + 2× 8px gap)
  - Gouden strip:  384 × 38px
  - Onderste balk: 384 × 50px
```

---

## Shot-nummerlabels (template 3)

In de derde template krijgt elke foto een klein label rechtsonder:

```
┌────────────────────┐
│                    │
│      foto          │
│                ┌──┐│
│                │#1││  ← BirthdayPink achtergrond, wit tekst, 
└────────────────└──┘┘     cornerRadius 6, padding 8×4
```

---

## Decoratieve elementen

### Confetti-patroon (`ConfettiPatternView`)
- **80 willekeurige stippen** verspreid over het canvas
- Kleuren: pink, geel, paars, mint, oranje, wit
- Opacity: 40%
- Grootte: 4–12px diameter
- Worden **eenmalig gegenereerd** in een `let`-eigenschap (niet bij elke render opnieuw)

### Sterren & emoji-decoratie (`StarDecorationView`)
- Posities (vast):
  - ⭐️ grootte 60, positie (30, 80), opacity 30%
  - 🎂 grootte 50, positie (370, 120), opacity 25%
  - 🎈 grootte 55, positie (20, 700), opacity 30%
  - ✨ grootte 45, positie (380, 900), opacity 30%

---

## Exportformaat

| Eigenschap | Waarde |
|---|---|
| Scale | @3x (UIScreen.main.scale = 3.0) |
| Kleurruimte | sRGB |
| Formaat | PNG (via `UIImage`, automatisch door `ImageRenderer`) |
| 1-shot afmeting | 1200 × 1680 px (@3x) |
| 2-shot afmeting | 1200 × 2700 px (@3x) |
| 3-shot afmeting | 1200 × 3720 px (@3x) |

---

## Aanbevelingen voor toekomstige uitbreidingen

- Voeg een **naamveld** toe zodat de naam "Loïs" aanpasbaar is
- Maak de **leeftijd** instelbaar voor hergebruik bij andere verjaardagen
- Voeg een **sticker-laag** toe (SwiftUI `.overlay`) voor extra decoraties
- Ondersteun **landscape-oriëntatie** voor een 2×2 grid template
- Voeg **filters** toe (sepia, zwart-wit) via Core Image op de `UIImage`

---

# Lichtgewicht Visuele Spec — Strip Themes & Party Frames

Deze sectie beschrijft de nieuwe stijlvarianten voor:

- de **achtergrond van de fotostrip**
- de **feestelijke frame- of achtergrondstijl rondom elke foto**

Doel van deze spec:

- snel genoeg voor implementatie door een junior engineer
- duidelijk genoeg voor consistente SwiftUI-uitwerking
- beperkt genoeg om geen volledige designfase nodig te maken

## Algemene ontwerpregels

Deze regels gelden voor alle nieuwe themes en frame styles:

- De bestaande stripmaten blijven gelijk: `400pt` breed, huidige hoogtes per template.
- De layout van fotozones, banner en ondertekst verandert niet.
- Alleen kleur, textuur, decoratie en accentvormen mogen variëren.
- Tekst op de strip moet altijd leesbaar blijven met minimaal hoog contrast.
- Decoratie rond foto's mag speels zijn, maar mag nooit gezichten of ogen overlappen.
- De visuele stijl moet feestelijk en duidelijk "verjaardag" aanvoelen, niet generiek wedding of Christmas.

## Strip Themes

Elke strip theme bepaalt:

- achtergrondkleur of gradient van de strip
- secundaire textuur of patroon
- tekstkleur
- accentkleur voor labels en details

### Theme 1 — Classic White

**Gebruik:** veilige standaard, neutraal, print-achtig photoboothgevoel.

| Eigenschap | Waarde |
|---|---|
| Achtergrond | `#FFFFFF` |
| Tekstkleur | `#111111` |
| Accent 1 | `#FF6B9D` |
| Accent 2 | `#FFD700` |
| Patroon | geen |

Visuele indruk:

```text
helder / clean / klassiek / fotostrip uit een kiosk
```

UI-richtlijn:

- gebruik geen extra patroonlaag
- schaduw mag subtiel blijven
- dit theme is de fallback voor alle foutgevallen

### Theme 2 — Pink Party

**Gebruik:** vrolijk, meisjesachtig, duidelijk verjaardagsthema.

| Eigenschap | Waarde |
|---|---|
| Achtergrond | gradient `#FFD1E6 -> #FF8FB8` |
| Tekstkleur | `#4A1431` |
| Accent 1 | `#FFFFFF` |
| Accent 2 | `#FF4F93` |
| Patroon | subtiele confetti-stippen op 12-18% opacity |

Visuele indruk:

```text
zacht / feestelijk / zoet / confetti-kaartgevoel
```

UI-richtlijn:

- pattern klein en luchtig houden
- geen zware paarse blokken bovenop deze achtergrond
- labels liever wit of donkerroze dan goud

### Theme 3 — Gold Confetti

**Gebruik:** premium feestje, iets chiquer zonder te formeel te worden.

| Eigenschap | Waarde |
|---|---|
| Achtergrond | warm creme `#FFF7E8` |
| Tekstkleur | `#4B3510` |
| Accent 1 | `#FFD700` |
| Accent 2 | `#FF6B9D` |
| Patroon | goudkleurige confetti en kleine sterretjes op 18-22% opacity |

Visuele indruk:

```text
chic / warm / verjaardagskaart / feestelijk zonder drukte
```

UI-richtlijn:

- goud nooit als volle massieve achtergrond gebruiken
- confetti liever verspreid aan randen dan achter tekstblokken
- tekst altijd donkerbruin of paarszwart houden

### Theme 4 — Purple Stars

**Gebruik:** iets meer drama en contrast, goed voor avondfeest-sfeer.

| Eigenschap | Waarde |
|---|---|
| Achtergrond | gradient `#2A0B45 -> #5B2A86` |
| Tekstkleur | `#FFFFFF` |
| Accent 1 | `#FFD700` |
| Accent 2 | `#FF9AC2` |
| Patroon | grote zachte sterren en sparkle-shapes op 10-16% opacity |

Visuele indruk:

```text
avondfeest / glam / neon-achtig maar nog vriendelijk
```

UI-richtlijn:

- pattern alleen in hoeken of langs de buitenrand plaatsen
- ondertekst en shotlabels wit of goud houden
- fotozones altijd op een lichte kaart laten rusten voor contrast

### Theme 5 — Rainbow Cake

**Gebruik:** speels, jong, energiek. Dit is de meest uitbundige variant.

| Eigenschap | Waarde |
|---|---|
| Achtergrond | zachte diagonale banen `#FF8FB8`, `#FFD166`, `#A8E6CF`, `#8EC5FF`, `#C9A7FF` |
| Tekstkleur | `#34214F` |
| Accent 1 | `#FFFFFF` |
| Accent 2 | `#FF6B9D` |
| Patroon | mini sprinkles of stipjes op 10-12% opacity |

Visuele indruk:

```text
speels / verjaardagstaart / kleurrijk / uitgesproken
```

UI-richtlijn:

- zorg dat kleuren pastel blijven, niet verzadigd neon
- tekstblokken op effen vlakken of semi-transparante backing zetten
- gebruik deze stijl alleen als er voldoende contrast blijft met de foto's

## Samenvatting strip themes in thumbnail-formaat

Voor de keuzekaarten op het resultaatscherm:

- kaartformaat: ongeveer `72 × 96pt`
- toon mini-strip met 2 fake foto-blokken en een kleine ondertekstbalk
- zet de theme-naam onder de preview
- highlight selectie met `BirthdayGold` rand `2pt`

Aanbevolen labels:

- `Klassiek`
- `Roze feest`
- `Gouden confetti`
- `Paarse sterren`
- `Rainbow cake`

---

## Party Frame Styles

Deze stijlen gelden per fotozone. Ze decoreren de foto zonder de foto-inhoud te vervangen.

Elke frame style bepaalt:

- randtype rondom de foto
- achtergrondlaag achter de fotozone
- overlay-decoratie in hoeken of randen

### Frame 1 — None

**Gebruik:** standaard en veilig.

| Eigenschap | Waarde |
|---|---|
| Rand | geen extra rand |
| Achtergrond | effen wit of theme-neutrale kaart |
| Decoratie | geen |

Visuele indruk:

```text
clean / rustig / focus op foto
```

### Frame 2 — Confetti Pop

**Gebruik:** de meest universele feeststijl; werkt met bijna elke stripachtergrond.

| Eigenschap | Waarde |
|---|---|
| Rand | witte kaart met dubbele confetti-rand |
| Achtergrond | zeer licht roze of creme |
| Decoratie | confetti in alle vier hoeken |
| Accentkleuren | roze, goud, mint, paars |

Visuele indruk:

```text
feestelijk / licht / energiek / direct begrijpelijk
```

UI-richtlijn:

- confetti vooral in de buitenste 12-16pt van het frame plaatsen
- binnenste rand schoon houden
- geen grote emoji over de foto zelf

### Frame 3 — Balloon Corner

**Gebruik:** duidelijk verjaardagsgevoel, wat speelser voor jonge gebruikers.

| Eigenschap | Waarde |
|---|---|
| Rand | afgeronde witte kaart met dunne roze outline |
| Achtergrond | zacht lila of lichtblauw vlak |
| Decoratie | kleine ballonnen in twee diagonale hoeken |
| Accentkleuren | roze, paars, goud |

Visuele indruk:

```text
jarig / vriendelijk / speels / luchtig
```

UI-richtlijn:

- ballonnen alleen linksboven + rechtsonder of andersom
- touwtjes kort houden en nooit over het gezicht laten lopen
- ballonvormen klein houden: decoratie, geen illustratie-focus

### Frame 4 — Star Glam

**Gebruik:** iets chiquer en beter passend bij donkere paarse themes.

| Eigenschap | Waarde |
|---|---|
| Rand | diepe paarse rand met subtiele inner glow |
| Achtergrond | donkerpaars paneel achter foto |
| Decoratie | sparkle stars op de rand en buitenhoeken |
| Accentkleuren | goud, wit, zachtroze |

Visuele indruk:

```text
glam / avondfeest / podiumgevoel
```

UI-richtlijn:

- gebruik kleine sterren met veel negatieve ruimte
- voorkom drukte door max 5-7 sterren per frame
- foto moet nog steeds de helderste focus blijven

### Frame 5 — Disco Tape

**Gebruik:** meest speelse en opvallende frame style; goed voor één accentvariant in de app.

| Eigenschap | Waarde |
|---|---|
| Rand | off-white frame met hoekstickers of tape-stukken |
| Achtergrond | lavendel of zacht mint vlak |
| Decoratie | disco dots, mini tape-hoeken, kleine sparkles |
| Accentkleuren | zilvergrijs, roze, mint, paars |

Visuele indruk:

```text
DIY party / scrapbook / tienerfeest / opvallend
```

UI-richtlijn:

- tape alleen in de hoeken zetten
- maximaal 4 tape-elementen per foto
- disco dots op lage opacity houden zodat het niet rommelig wordt

## Frame-opbouw per fotozone

Aanbevolen lagenvolgorde voor implementatie:

```text
1. achtergrondvlak van het frame
2. decoratieve shapes achter de foto
3. foto zelf
4. dunne optionele rand
5. hoekdecoraties of kleine overlays bovenop
```

Belangrijke regel:

- laag 5 mag nooit belangrijke delen van een gezicht raken

## Samenvatting frame styles in thumbnail-formaat

Voor de keuzekaarten op het resultaatscherm:

- kaartformaat: ongeveer `72 × 72pt`
- toon één dummy-fotovlak met frame-decoratie
- label onder de kaart
- selectiestaat met gouden border `2pt`

Aanbevolen labels:

- `Geen`
- `Confetti`
- `Ballonnen`
- `Sterren`
- `Disco`

---

## Combinatieregels

Niet elke combinatie hoeft perfect te zijn. Gebruik deze eenvoudige voorkeuren:

| Strip theme | Beste frame matches |
|---|---|
| Classic White | None, Confetti Pop, Balloon Corner |
| Pink Party | Confetti Pop, Balloon Corner, Disco Tape |
| Gold Confetti | None, Confetti Pop, Star Glam |
| Purple Stars | Star Glam, None, Confetti Pop |
| Rainbow Cake | Balloon Corner, Disco Tape, Confetti Pop |

Als een combinatie te druk wordt:

- houd de strip theme leidend
- verlaag opacity van het frame-patroon
- verminder het aantal decoratieve elementen per frame

---

## Niet doen

- Geen volledige achtergrondvervanging van de foto in deze fase.
- Geen zware illustraties die over gezichten liggen.
- Geen te donkere tekst op donkere theme-achtergronden.
- Geen glitter- of confetti-patroon direct achter de hoofdtekst zonder contrastvlak.
- Geen frame-stijl die de effectieve fotoruimte zichtbaar kleiner maakt dan nodig.
