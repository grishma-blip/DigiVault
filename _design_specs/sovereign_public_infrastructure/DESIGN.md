---
name: Sovereign Public Infrastructure
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#43474e'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#74777f'
  outline-variant: '#c4c6cf'
  surface-tint: '#455f88'
  primary: '#002045'
  on-primary: '#ffffff'
  primary-container: '#1a365d'
  on-primary-container: '#86a0cd'
  inverse-primary: '#adc7f7'
  secondary: '#904d00'
  on-secondary: '#ffffff'
  secondary-container: '#fe932c'
  on-secondary-container: '#663500'
  tertiary: '#00270d'
  on-tertiary: '#ffffff'
  tertiary-container: '#003f19'
  on-tertiary-container: '#50b168'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#adc7f7'
  on-primary-fixed: '#001b3c'
  on-primary-fixed-variant: '#2d476f'
  secondary-fixed: '#ffdcc3'
  secondary-fixed-dim: '#ffb77d'
  on-secondary-fixed: '#2f1500'
  on-secondary-fixed-variant: '#6e3900'
  tertiary-fixed: '#95f8a7'
  tertiary-fixed-dim: '#79db8d'
  on-tertiary-fixed: '#00210a'
  on-tertiary-fixed-variant: '#005323'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.005em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-md-medium:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  mono-numeral:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-mobile: 1rem
  margin-desktop: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The brand personality reflects institutional permanence, civic integrity, and cryptographic trust. Designed as an egalitarian Digital Public Infrastructure (DPI) document repository, the UI prioritizes friction-free utility, high legibility across varied device tiers, and an unshakeable sense of security. It avoids playful or hyper-trendy startup tropes in favor of an authoritative, clean, and transparent visual language.

The visual execution adopts a Modern Civic Minimalist aesthetic:
- **Structural Integrity:** Crisp 1px structural hair-lines replace heavy drop shadows, providing clarity without visual noise.
- **Accessible Contrast:** AAA-compliant contrasts ensure operational clarity outdoors, on low-end budget displays, or under direct sunlight.
- **Dignified Accents:** Saffron is deployed strictly as an intentional focal anchor or transitional cue, never as ambient decoration. India Green denotes cryptographic validity and legal verification.
- **Inclusive Utility:** Every state transition, action, and document badge pairs iconography with explicit typographic status to accommodate diverse literacy levels and accessibility requirements.

## Colors
The color palette communicates sovereignty, verification, and absolute stability.

- **Primary (`#1A365D` - Sovereign Navy):** Anchor color used for primary navigation bars, legal attestations, high-emphasis action buttons, and dominant headers. Evokes cryptographic security and institutional trust.
- **Secondary (`#D97706` - Warm Saffron Amber):** Used with strict restraint. Reserved for pending states, verification warnings, action badges, and key contextual callouts.
- **Tertiary (`#15803D` - Sovereign India Green):** Represents legally binding verification, digitally signed credentials, active sync statuses, and tamper-evident badges.
- **Neutral Surface Foundation:**
  - Base canvas: `#F8FAFC` (Slate 50)
  - Card & sheet surfaces: `#FFFFFF` (Pure White)
  - Nested container fill: `#F1F5F9` (Slate 100)
  - Structural dividers and hairline borders: `#CBD5E1` and `#E2E8F0`
  - High-emphasis text: `#0F172A` (Slate 900)
  - Secondary metadata and helper labels: `#475569` (Slate 600)

Never use color as the sole conveyor of information; every semantic status (verified, pending, expired, revoked) must combine color with explicit text labels and standard icons.

## Typography
Typography is engineered for immediate legal comprehension and clear hierarchy across English, Devanagari script transliterations, and tabular reference IDs.

- **Headings (Plus Jakarta Sans):** Geometric clarity with sculpted counters and balanced proportions. Delivers an official, modern public institution presence.
- **Body & Metadata (Inter):** High x-height, neutral letterforms, and comprehensive Unicode support. Selected for flawless rendering on low-density mobile displays.
- **Masked Document Numbers & Alphanumeric Identifiers (`mono-numeral`):** Formatted using `font-feature-settings: "tnum" on, "zero" on` to guarantee fixed-width character alignment for Aadhaar (last 4 digits), PAN, Driving License, and Vehicle Registration strings.
- **Bilingual Stacking:** When sub-labels appear in Hindi or regional languages alongside English, the non-Latin string should sit below the Latin primary label at `label-sm` with a 2px top gap and neutral tone (`#64748B`).

## Layout & Spacing
The layout adheres strictly to an 8-point baseline grid with a 4-point sub-grid for icons, micro-labels, and compact tags.

- **Breakpoints & Fluid Structure:**
  - **Mobile (<640px):** Single-column layout. 16px page margins (`margin-mobile`), 12px column gutters. Primary actions sit persistently within a bottom safe-area container.
  - **Tablet (640px - 1024px):** 6-column grid. 24px margins, 16px gutters. Cards default to 2 or 3 columns.
  - **Desktop (>1024px):** 12-column grid. Maximum content bounding container of 1200px centered with 32px lateral margins (`margin-desktop`).
- **Touch-First Accessibility:** Any interactive element (issuers, cards, table row actions, quick links) enforces a minimum physical target size of 48×48px.
- **Rhythm Rules:** Stack cards with `space-md` (16px) separation. Group related form fields and metadata pairs with `space-sm` (8px). Structural section transitions use `space-xl` (32px).

## Elevation & Depth
Depth in the design system is communicated through structural layering, border contrast, and minimal ambient diffusion rather than blurred dropshadows. This prevents visual muddiness and maintains clarity on budget screens.

- **Level 0 (Canvas):** `#F8FAFC`. Base background for the page.
- **Level 1 (Card / Resting Surface):** `#FFFFFF` paired with a 1px solid hairline border (`#E2E8F0`). Shadow is ultra-subtle: `0 1px 2px 0 rgba(15, 23, 42, 0.05)`.
- **Level 2 (Hover / Active Document / Dropdown):** `#FFFFFF` with border darkened to `#CBD5E1` and ambient elevation: `0 4px 6px -1px rgba(15, 23, 42, 0.08), 0 2px 4px -2px rgba(15, 23, 42, 0.05)`.
- **Level 3 (Modal Sheet / Biometric Prompt / Drawer):** `#FFFFFF` with `0 10px 15px -3px rgba(15, 23, 42, 0.12), 0 4px 6px -4px rgba(15, 23, 42, 0.08)`. Backdrops use a semi-opaque scrim: `rgba(15, 23, 42, 0.6)`.
- **Level Nested (Container Low):** `#F1F5F9`. Recessed background used within white cards to isolate metadata clusters, masked numbers, and QR code wrappers. Uses no shadow and an inset border of `#E2E8F0`.

## Shapes
A disciplined radius scale provides a balanced, civic feel—avoiding both sharp brutalism and overly playful consumer bubbles.

- **Base Corner Radius (`roundedness: 2` = 8px):** Applied to standard text input fields, buttons, action chips, and nested credential data containers.
- **Large Corner Radius (`rounded-lg` = 12px):** Applied to document cards, credential badges, and dialogue containers.
- **Extra Large Corner Radius (`rounded-xl` = 16px):** Exclusively reserved for mobile bottom action sheets and primary biometric auth sheets.
- **Pill / Circular (Fully Rounded):** Restricted to counter pills, verification badge tags, and numeric step indicators.

## Components

### Buttons
- **Primary:** Background `#1A365D`, text `#FFFFFF`, border none, 8px radius. Height 48px. State layers: Hover `#0F2442`, Active `#0A182E`. Focus: 2px offset ring in `#1A365D`.
- **Secondary:** Background `#FFFFFF`, text `#1A365D`, border 1px solid `#CBD5E1`. Height 48px. Hover: `#F1F5F9`.
- **Tertiary / Ghost:** Background transparent, text `#1A365D`. Underline on hover.
- **Destructive:** Background `#DC2626`, text `#FFFFFF`. Used strictly for credential revocation and account deletion.

### Credential Document Card (Material 3 DPI Architecture)
- Surface `#FFFFFF`, 12px corner radius, 1px border `#E2E8F0`.
- Top header: Issuer icon/seal placeholder (32×32px, 6px radius) alongside Issuer Name (`label-md`) and Document Class Name (`headline-sm`).
- Top-right corner: Verification Badge with `#ECFDF5` fill, `#15803D` text, 1px `#A7F3D0` border, featuring a checkmark icon and "Verified" text.
- Center area: Masked ID (e.g., `•••• •••• 9812`) rendered in `mono-numeral` over `#F1F5F9` recessed container with an 8px radius.
- Bottom footer: Issuance / Valid Thru dates (`body-sm`), action split button for "View QR" and "Share Token".

### Chips & Status Badges
- **Verified:** Background `#DCFCE7`, text `#15803D`, 1px border `#86EFAC`. Icon: Shield Checkmark.
- **Pending Sync:** Background `#FEF3C7`, text `#B45309`, 1px border `#FCD34D`. Icon: Clock.
- **Action / Filter Chip:** Height 36px, 8px radius. Inactive: `#FFFFFF` fill, `#475569` text, `#E2E8F0` border. Active: `#1A365D` fill, `#FFFFFF` text.

### Form Inputs & Fields
- Height 48px, 8px radius, `#FFFFFF` background, 1px solid `#CBD5E1` border.
- Text: `body-md` in `#0F172A`. Placeholder: `#94A3B8`.
- Focus state: Border transitions to `#1A365D` with a 1px matching ring.
- Error state: Border `#DC2626`, accompanied below the input by a warning icon and error text in `#DC2626` (`body-sm`).

### Checkboxes & Radios
- Size 20×20px, minimum 48×48px tap target area.
- Unchecked: 1.5px border `#94A3B8`, `#FFFFFF` fill.
- Checked: `#1A365D` fill with white checkmark icon or radio dot.

### Lists
- Separated by 1px horizontal rules in `#F1F5F9`.
- List item height: 56px minimum. Left: Leading 40×40px iconography wrapper in `#F1F5F9`. Right: Chevron right in `#94A3B8`.

### Specialized DPI Components
- **Aadhaar / OTP Consent Dialogue:** High-emphasis container with an explicit legal consent declaration text in `body-sm`, checkbox confirmation, and an e-Sign verification trigger button.
- **Offline QR Code Presenter:** High-contrast `#FFFFFF` square background enclosed by a 1px `#CBD5E1` border with 16px internal padding, displaying a signed Indian DPI cryptographic QR code alongside an explicit timestamp counter.