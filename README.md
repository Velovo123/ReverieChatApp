# Reverie — iOS Chat App

A clean, minimal chat app for iOS built with SwiftUI and Supabase. The project was primarily a playground for exploring modern iOS features — realtime WebSockets, Metal shaders, and progressive blur UI.

## Demo

[![Reverie Demo](https://img.youtube.com/vi/zwh22iN2SeU/0.jpg)](https://youtube.com/shorts/zwh22iN2SeU)

---

## Stack

- **SwiftUI** + **Supabase** (Auth, Postgres, Realtime)
- **ProgressiveBlurHeader** — progressive blur nav bar matching Apple Music / Photos
- **Metal shaders** — custom GPU-rendered backgrounds via SwiftUI's `.colorEffect`

---

## Features

- Email sign up and sign in with field validation
- Session persistence — app restores login on relaunch
- Channels and direct messages
- Realtime messaging via WebSocket — messages appear instantly without polling
- Mute notifications per conversation
- Clear conversation (DMs only)

---

## Database

Five Postgres tables with Row Level Security — users only see conversations and messages they have access to.

| Table | Purpose |
|---|---|
| `users` | Profile data |
| `conversations` | Channels and DMs |
| `conversation_members` | Membership join table |
| `messages` | All messages |
| `presence` | Online status and typing (schema ready) |

---

## UI

**Progressive blur headers** on every screen — content scrolls underneath and blurs progressively, identical to the behavior in Apple Music and the App Store.

**Metal shader backgrounds** — this was the fun part. Played around with GPU-rendered backgrounds using SwiftUI's `.colorEffect`:

- Login and sign up — animated cloud shader, soft pastels morphing slowly
- Chat — subtle dot grid, notebook feel
- Conversation list — animated aurora rainbow stripe on the left edge

**Custom transitions** — spring push, fade + scale, slide with parallax, and hero matched geometry all built and explorable.

---

## Security

Supabase credentials stored in a gitignored `Secrets.xcconfig` file, read at build time via `Info.plist`.
