# Social Backend

Standalone Express + MongoDB OAuth backend for Localyse social connect.

## What it does

- starts OAuth for `youtube` and `instagram`
- verifies the app user with Firebase Admin
- signs and validates OAuth state
- stores provider tokens encrypted at rest
- redirects back to the Flutter app after callback

## Endpoints

- `GET /health`
- `POST /api/:provider/session`
- `GET /api/:provider/callback`
- `GET /api/social/connections`
- `DELETE /api/social/:provider`

Supported providers:

- `youtube`
- `instagram`

## App flow

The Flutter app can open:

- `POST /api/youtube/session`
- `POST /api/instagram/session`

With:

- `Authorization: Bearer <firebase-id-token>`
- JSON body: `{ "uid": "<firebase-uid>" }`

On callback success, the backend redirects to:

- `localyse://social-connect?provider=youtube&status=success`
- `localyse://social-connect?provider=instagram&status=success`

## Instagram requirements

The Instagram provider in this backend is intended for Instagram API with
Instagram Login for professional/business accounts, not the older Basic Display
profile-only flow.

Make sure your Meta app is configured with:

- the exact callback URI:
  `https://your-domain.com/api/instagram/callback`
- business/professional Instagram login enabled
- the Instagram scopes you actually request, such as:
  - `instagram_business_basic`
  - `instagram_business_manage_messages`
  - `instagram_business_manage_comments`
  - `instagram_business_content_publish`
  - `instagram_business_manage_insights`

## Setup

1. Copy `.env.example` to `.env`.
2. Fill the Firebase Admin and OAuth provider credentials.
3. Install dependencies:

```bash
cd social
npm install
```

4. Run:

```bash
npm run dev
```

## Notes

- Provider access and refresh tokens are stored only on the backend.
- `TOKEN_ENCRYPTION_KEY` must be a 64-character hex string.
- The Flutter app is already set up to consume app redirects using the
  `localyse://social-connect` deep link.
