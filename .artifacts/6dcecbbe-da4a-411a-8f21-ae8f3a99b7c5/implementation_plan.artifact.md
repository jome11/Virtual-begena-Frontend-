# Implementation Plan - One-Page Smooth-Scrolling Public Website

Refactor the public portion of the application into a single-page smooth-scrolling layout with sticky navigation (`NavBar`), active section tracking (`SectionNav`), and URL query parameter redirection (`?section=...`).

## User Review Required

> [!IMPORTANT]
> The public pages (Home, How to use, About, Contact) will now reside as scrollable sections on a single home page (`/home`), with smooth scrolling and active indicator highlights in the navigation bar.

## Proposed Changes

### 1. Section Navigation Service
#### [NEW] [section_nav.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/services/section_nav.dart)
- Define `SiteSection` enum (`home`, `howTo`, `about`, `contact`) and `SectionNav` manager for active section tracking and smooth scrolling.

### 2. Home Screen & Navbar
#### [MODIFY] [home_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/home/home_screen.dart)
- Integrate `SectionNav` attachment, scroll listener for active section detection, query parameter initial scrolling (`?section=...`), and keyed subsections (`HowToSection`, `AboutSection`, `ContactSection`).
#### [MODIFY] [nav_bar.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/shared/widgets/nav_bar.dart)
- Update navbar links to trigger smooth scrolling via `SectionNav.scrollTo` when on home, or redirect (`/home?section=...`) from other pages. Add active section underlines.

### 3. Public Section Widgets
#### [MODIFY] [how_to_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/how_to/how_to_screen.dart)
- Convert `HowToScreen` into `HowToSection`.
#### [MODIFY] [about_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/about/about_screen.dart)
- Convert `AboutScreen` into `AboutSection`.
#### [MODIFY] [contact_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/contact/contact_screen.dart)
- Convert `ContactScreen` into `ContactSection`.

### 4. Router
#### [MODIFY] [app_router.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/routes/app_router.dart)
- Remove old screen imports for about/contact/how_to.
- Update `/home` route to pass `section` query parameter.
- Replace `/how-to-use`, `/about`, and `/contact` routes with redirects to `/home?section=...`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify static typing and compilation.

### Manual Verification
- Test smooth scrolling when clicking navbar links on the home page.
- Test deep linking (`/home?section=about`, `/about`) to ensure smooth scrolling to the requested section.
