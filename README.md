<p align="center">
  <img src="docs/branding/exports/app-icon-1024.png" width="120" alt="InterFind app icon">
</p>

<h1 align="center">InterFind</h1>

<p align="center">An offline-first iOS app for students looking for their first internship.</p>

<p align="center">
  <img src="docs/screenshots/01-onboarding.png" width="200" alt="Onboarding">
  <img src="docs/screenshots/02-home.png" width="200" alt="Home">
  <img src="docs/screenshots/03-search.png" width="200" alt="Search">
  <img src="docs/screenshots/04-detail.png" width="200" alt="Internship detail">
</p>

## About

InterFind is a redesigned, solo version of **PasaFinder**, a university team project. It starts from that codebase and reworks it into a self-contained portfolio app: no backend, no Firebase, no cloud accounts. Everything runs and is stored on the device.

## Features

- **Onboarding** that only shows on first launch
- **Local accounts**: sign up and log in on the device, or tap *Continue as Daiv (demo)*
- **Home** with Big Tech program banners, internships closing soon and the latest listings
- **Search** across title, company and perks
- **Saved** internships stored with Core Data
- **Admin tools** to publish and delete internships, with an image from the photo library
- **Profile** with an initials avatar, editable details and log out

## Demo account

| Name | Email | Password |
|---|---|---|
| Daiv | `daiv@interfind.app` | `interfind` |

It is also the admin account, so it can publish and delete internships.

## How it works

| Concern | Implementation |
|---|---|
| Internships | JSON file in `Documents`, seeded from `Resources/SampleData/internships.json` |
| Images | JPG files in `Documents/Images`; companies without a logo get a generated initials badge |
| Accounts | Profile in `UserDefaults`, password stored as a salted SHA-256 hash |
| Session | Token in the Keychain, expires after 30 days |
| Saved internships | Core Data |
| Navigation | `AppRouter` swaps the root between onboarding, login and the tab bar |

The sample internships use fictional companies. The Big Tech banners only link to each company's official student careers page.

## Project structure

```
InterFind/
├── InterFind.xcodeproj
├── InterFind/
│   ├── App/            AppDelegate, SceneDelegate, AppRouter
│   ├── Components/     Reusable buttons, labels, text fields and views (IF prefix)
│   ├── Controllers/    Screen logic (home, login, search, admin)
│   ├── Extensions/
│   ├── Managers/       LocalStore, Core Data, Keychain, UserDefaults
│   ├── Model/          Models and the Core Data stack (Model/CoreData)
│   ├── Resources/      Assets, launch screen, sample data
│   ├── Utils/
│   └── Views/          Onboarding, Login, SignUp, Home, Search, JobDetail, Favorite, Profile, Admin
├── InterFindUITests/
└── docs/
    ├── branding/       Logo source files, exports and concept sheet
    └── screenshots/
```

## Requirements

- Xcode 16 or later
- iOS 16.6 or later

Open `InterFind.xcodeproj`, pick a simulator and run. To run on a device, choose your own team under *Signing & Capabilities*.

## Branding

The logo is an "i" (the intern) walking through an open arch: your door into the industry. Source SVGs live in `docs/branding/logo`; the wordmark is set in [Inter](https://rsms.me/inter/) (SIL Open Font License) and converted to outlines.

| Color | Hex |
|---|---|
| Navy | `#130160` |
| Orange | `#FF9228` |

## Credits

Based on PasaFinder, originally built as a team project. The original authors are kept in the file headers and in `LICENSE`.

## License

MIT. See [LICENSE](LICENSE).
