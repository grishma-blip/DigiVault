---
name: Sovereign Trust
colors:
  surface: '#f9f9ff'
  surface-dim: '#d2daf0'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f3ff'
  surface-container: '#e9edff'
  surface-container-high: '#e0e8ff'
  surface-container-highest: '#dbe2f9'
  on-surface: '#141b2c'
  on-surface-variant: '#444651'
  inverse-surface: '#293041'
  inverse-on-surface: '#edf0ff'
  outline: '#757682'
  outline-variant: '#c5c5d2'
  surface-tint: '#465aa1'
  primary: '#072369'
  on-primary: '#ffffff'
  primary-container: '#253b80'
  on-primary-container: '#94a8f5'
  inverse-primary: '#b6c4ff'
  secondary: '#4f5c8e'
  on-secondary: '#ffffff'
  secondary-container: '#b7c4fd'
  on-secondary-container: '#435081'
  tertiary: '#00302b'
  on-tertiary: '#ffffff'
  tertiary-container: '#004842'
  on-tertiary-container: '#4cbcaf'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dce1ff'
  primary-fixed-dim: '#b6c4ff'
  on-primary-fixed: '#00164f'
  on-primary-fixed-variant: '#2d4287'
  secondary-fixed: '#dce1ff'
  secondary-fixed-dim: '#b7c4fd'
  on-secondary-fixed: '#071747'
  on-secondary-fixed-variant: '#374475'
  tertiary-fixed: '#89f5e7'
  tertiary-fixed-dim: '#6bd8cb'
  on-tertiary-fixed: '#00201d'
  on-tertiary-fixed-variant: '#005049'
  background: '#f9f9ff'
  on-background: '#141b2c'
  surface-variant: '#dbe2f9'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
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
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  mono-code:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The design system establishes a balance between sovereign public infrastructure and refined consumer fintech. Built primarily for Flutter mobile environments, the visual language avoids both the sterile austerity of legacy government portals and the playful informality of consumer social apps. Instead, it evokes institutional credibility, technological precision, and absolute document integrity.

The design movement is **Premium Minimalism** anchored in high-structure Material 3 and modern Indian digital public infrastructure principles:
- **Tone:** Authoritative, cryptographic, effortless, and protective.
- **Visual Rhythm:** Crisp white surface planes hovering over soft slate-tinted canvas backdrops, punctuated by deliberate deep-sea navies and an emerald-and-teal verification accent system.
- **Affordance Philosophy:** High-clarity tactile affordances with generous hit targets (minimum 44px, standard 48–56px interactive controls) adapted for one-handed thumb reachability within mobile viewports (393×852 base).

## Colors
The color hierarchy is engineered to differentiate verified government instruments (Aadhaar, PAN, Academic Degrees, Driving Licenses) through precise color signaling without visual clutter.

### Palette Architecture
- **Primary (`#253B80`)**: Institutional deep navy. Used for active navigation destinations, primary call-to-action buttons, high-priority interactive triggers, and core branding elements.
- **Secondary (`#172554`)**: Midnight indigo. Applied to prominent credential headers, modal title bars, and critical security containers.
- **Tertiary (`#0D9488`)**: Security teal. Represents cryptographic verification, active sync states, and secure digital signatures.
- **Neutral Primary (`#101828`)**: Deep charcoal black. Used for high-contrast alphanumeric identifiers, legal entity titles, and primary reading text.
- **Neutral Secondary (`#667085`)**: Slate mist. Dedicated to timestamps, secondary labels, metadata tags, and inactive icons.
- **Canvas Base (`#F5F7FB`)**: Soft blue-gray tinted canvas that provides separation for white document cards without harsh border reliance.
- **Card Surface (`#FFFFFF`)**: Pure light reflection for document credential cards, elevated sheets, and modular inputs.

### Semantic Alerts
- **Success (`#15803D`)**: DigiLocker verified stamp, valid signature, sync complete.
- **Warning (`#D97706`)**: Expiring credential, incomplete metadata, pending issuer confirmation.
- **Error (`#DC2626`)**: Revoked certificate, authentication failure, tampering detected.
- **Structural Border (`#E4E7EC`)**: Ultra-clean separation lines with zero optical vibration.

## Typography
The system couples **Plus Jakarta Sans** for headlines and high-level identity surfaces with **Inter** for dense transactional UI, numeric data, and body copy. 

- **Display & Headings (Plus Jakarta Sans)**: The sculpted geometric curves bring warmth and approachability to official government document headers, preventing the layout from feeling bureaucratic.
- **Body & Data (Inter)**: Delivers x-height uniformity and optical clarity across masked identification strings (e.g., `XXXX-XXXX-3829`), date timestamps, and institutional metadata.
- **Tabular Figures & Masked IDs**: For document keys, Aadhaar numbers, and cryptographic checksums, apply `font-feature-settings: 'tnum' on, 'zero' on` to prevent line shifting during dynamic loading.

## Layout & Spacing
Designed around a strict **8-point spatial grid** tailored for mobile hand geometry on standard 393×852 viewport screens (with seamless scaling across iOS and Android aspect ratios):

- **Screen Margins**: Default to `1.25rem` (20px) on mobile viewports for optimal thumb ergonomics and content framing, compressing down to `1rem` (16px) only for compact viewports (&lt;360dp) and expanding to `1.5rem` (24px) on tablet canvases.
- **Gutters & Cards**: Internal list spacings follow `space-md` (16px), ensuring credentials feel isolated and discrete without fragmenting the vertical feed.
- **Touch Target Integrity**: Any tappable target must evaluate to at least 44×44px bounding area. Form controls, buttons, and verification banners feature 48px to 56px explicit heights for reliable physical handling on moving public transit.
- **Safe Area Insets**: Dynamic padding integrates with top notch/island and gesture home bars, reserving a standard 80px fixed clearance zone above bottom navigation bars.

## Elevation & Depth
Elevation in this system uses ambient atmospheric depth rather than traditional material skeuomorphism, communicating security and tactile confidence.

- **Level 0 (Flat/Base)**: `#F5F7FB` backdrop layer. Completely flat with no shadow.
- **Level 1 (Card & List Tier)**: `#FFFFFF` credential cards and profile modules. Uses a multi-stop ambient shadow: `0px 2px 4px rgba(16, 24, 40, 0.04), 0px 8px 16px rgba(16, 24, 40, 0.04)`, paired with a crisp structural hairline border (`1px solid #E4E7EC`). This dual-treatment prevents card bleed into the pale blue canvas.
- **Level 2 (Interactive Floating Surfaces)**: Pinned search filters, sticky category headers, and active filter chips. `0px 4px 12px rgba(37, 59, 128, 0.08)`.
- **Level 3 (Modal Sheets & Action Overlays)**: Bottom sheets, QR scanner viewports, and verification popups. `0px -8px 24px rgba(16, 24, 40, 0.12)`.
- **Level 4 (High-Priority Prompts)**: Biometric re-authentication overlays and cryptographic signature dialogues. `0px 16px 32px rgba(23, 37, 84, 0.16)`.

## Shapes
A roundedness tier of `2` provides a friendly yet structured form language, balancing contemporary mobile OS paradigms with civic authority:

- **Cards & Document Tiles**: Standardized `16px` (`rounded-lg`) corner radii to mimic physical PVC smart cards, Aadhaar laminates, and driving license forms.
- **Buttons & Large Fields**: `12px` (`rounded`) corner radii for inputs, select triggers, and action buttons, creating clear interactive boundaries.
- **Badges, Pills & Verification Stamps**: Full pill shape (`9999px`) for state indicators (`VERIFIED`, `ISSUED`, `PENDING`), facilitating instant visual recognition.
- **Modal Sheets**: `24px` top-left and top-right radii for bottom pull-up drawers to visually cradle content against the bottom edge.

## Components

### Buttons
- **Primary Button**: Height `52px`, background `#253B80`, text `#FFFFFF` (Label-LG), corner radius `12px`. Subtle inward press state (opacity `0.9`, scale `0.98`).
- **Secondary Button**: Height `52px`, background `#FFFFFF`, border `1.5px solid #E4E7EC`, text `#101828`. Hover/pressed fill `#F5F7FB`.
- **Tertiary / Ghost Button**: Height `48px`, background transparent, text `#253B80` with trailing security icon.
- **Destructive Action**: Height `48px`, background `#DC2626` at 10% fill, text `#DC2626`, zero border.

### Document Cards (Fintech/Govtech Specialized)
- **Credential Tile**: Pure `#FFFFFF` surface, `16px` border radius, `1px solid #E4E7EC`, padded `16px`. Left icon displays the issuer emblem (e.g., UIDAI, Ministry of Road Transport, CBSE); center stack features title (`title-md`) and document identifier (`body-sm` in tabular digits); right side hosts the verified badge pill.
- **Featured Identity Card**: Gradient base from `#253B80` to `#172554`, white text, micro-textured guilloche watermark pattern, gold/teal hologram badge in top corner.

### Chips & Verification Badges
- **Verified Stamp**: Background `#15803D` at 10% opacity, border `1px solid rgba(21, 128, 61, 0.2)`, text `#15803D` (Label-SM), height `24px`, padding horizontal `8px`, pill radius. Accompanied by a `12px` solid checkmark shield.
- **Filter Chips**: Height `36px`, background `#FFFFFF`, border `1px solid #E4E7EC`, text `#667085`. Selected state: background `#253B80`, text `#FFFFFF`, border `#253B80`.

### Form Fields & Inputs
- **Input Field**: Height `54px`, surface `#FFFFFF`, border `1.5px solid #E4E7EC`, text `#101828` (`body-md`), label floating above in `label-md` (`#667085`).
- **Focused State**: Border shifts to `#253B80` with a 2px soft glow (`rgba(37, 59, 128, 0.15)`).
- **Masked Pin/Aadhaar Box**: Grouped segmented inputs (4 character buckets), height `56px`, centered text with mono spacing.

### Selection Controls
- **Checkbox & Radio**: Active state `#253B80` fill with `#FFFFFF` inner glyph. Unselected border `2px solid #E4E7EC`. Hit zone padded to `44x44px`.
- **Toggle Switch**: Track width `48px`, height `28px`. Inactive track `#E4E7EC`, active track `#0D9488`. Thumb `#FFFFFF` with drop shadow `0 2px 4px rgba(0,0,0,0.1)`.

### Navigation & Bottom Sheets
- **M3 NavigationBar**: Height `80px` (including safe area), background `#FFFFFF`, top border `1px solid #E4E7EC`. Active icon framed by a soft tinted pill (`#253B80` at 10% opacity). Label `#253B80` (Label-SM). Inactive elements use `#667085`.
- **Pull Drawer / Bottom Sheet**: Background `#FFFFFF`, corner radius `24px 24px 0 0`, drag handle `36x4px` `#E4E7EC` centered `8px` from top edge.