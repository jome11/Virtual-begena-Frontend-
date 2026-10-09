# Walkthrough - Orthodox Heritage Home Sections & Social Login Refactoring

Successfully updated social login to Google only and integrated three new Ethiopian Orthodox heritage sections (`ScriptureSection`, `SymbolismSection`, `TraditionSection`) onto the home screen.

## Changes

### 1. Social Login
#### [social_buttons.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/auth/widgets/social_buttons.dart)
- Configured Google as the single OAuth provider and made the constructor `const`.

### 2. Orthodox Heritage Sections & Home Page
#### [orthodox_sections.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/home/widgets/orthodox_sections.dart)
- Implemented `ScriptureSection` featuring scripture cards for Psalm 92:3, 1 Samuel 16:23, and Revelation 5:8.
- Implemented `SymbolismSection` featuring cards explaining the spiritual symbolism of the ten strings, sound box, cross, posts, plectrum, and yoke.
- Implemented `TraditionSection` featuring occasion cards, the player's rule, and St. Yared's 3 modes.
#### [home_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/home/home_screen.dart)
- Embedded `ScriptureSection()`, `SymbolismSection()`, and `TraditionSection()` within the main home page scroll view.

> [!NOTE]
> Static analysis (`flutter analyze`) verified successfully with zero errors.
