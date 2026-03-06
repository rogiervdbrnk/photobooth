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
