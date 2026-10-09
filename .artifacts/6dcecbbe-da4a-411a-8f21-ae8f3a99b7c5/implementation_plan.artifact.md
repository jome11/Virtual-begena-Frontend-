# Implementation Plan - Orthodox Heritage Sections & Social Login Refactoring

Remove GitHub from social login buttons and add three Orthodox heritage sections (`ScriptureSection`, `SymbolismSection`, `TraditionSection`) to the home screen landing flow.

## User Review Required

> [!IMPORTANT]
> The social login buttons will now display Google only. Three spiritual and heritage sections from the curriculum will be added to the home page.

## Proposed Changes

### 1. Social Login Refactoring
#### [MODIFY] [social_buttons.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/auth/widgets/social_buttons.dart)
- Remove GitHub provider entry, leaving Google as the single OAuth provider.

### 2. Orthodox Heritage Home Sections
#### [NEW] [orthodox_sections.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/home/widgets/orthodox_sections.dart)
- Implement `ScriptureSection` (Psalm 92:3, 1 Sam 16:23, Rev 5:8 verse cards).
- Implement `SymbolismSection` (6 symbolism cards for strings, sound box, cross, posts, plectrum, yoke).
- Implement `TraditionSection` (occasions, player's rule, and St. Yared's 3 modes).
#### [MODIFY] [home_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/home/home_screen.dart)
- Insert `ScriptureSection()`, `SymbolismSection()`, and `TraditionSection()` into the home scroll view.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify static typing and compilation.

### Manual Verification
- Verify home page renders scripture, symbolism, and tradition sections cleanly.
- Verify social login buttons display Google.
