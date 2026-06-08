# Parkealo Backend

Express and MongoDB API for the Parkealo authentication screens.

## Setup

```bash
npm install
copy .env.example .env
npm run seed:parkings
npm run dev
```

Set `MONGODB_URI` in `.env` before starting the server.
Use `MONGODB_DB=parkealo` when the database name is not already fixed in the URI.

## Postman

Import these files into Postman:

```text
postman/Parkealo API.postman_collection.json
postman/Parkealo Local.postman_environment.json
```

Select the `Parkealo Local` environment before running requests. Run `Auth > Sign Up` or `Auth > Sign In` first so Postman saves `{{token}}` automatically.

## Parking APIs

### List Parking Places

`GET /api/parkings`

Query parameters:

```text
search=colonial
accessType=public
vehicleType=car
services=covered,camera
sort=recommended
lat=18.4734
lng=-69.8841
```

Sort values: `recommended`, `nearest`, `price_low`, `price_high`, `available`.

### Parking Details

`GET /api/parkings/:id`

`:id` can be a Mongo id or a slug like `parking-colonial-premium`.

## Booking APIs

### Price Quote

`POST /api/bookings/quote`

```json
{
  "parkingId": "parking-colonial-premium",
  "date": "today",
  "arrivalTime": "10:30 AM",
  "durationHours": 2,
  "insuranceIncluded": true
}
```

### Safety Check

`POST /api/bookings/safety-check`

```json
{
  "leavingValuables": true
}
```

### Confirm Booking

Requires `Authorization: Bearer <token>`.

`POST /api/bookings`

```json
{
  "parkingId": "parking-colonial-premium",
  "date": "today",
  "arrivalTime": "10:30 AM",
  "durationHours": 2,
  "insuranceIncluded": true,
  "paymentMethod": "card",
  "cardNumber": "4111111111111111",
  "safetyAcknowledged": true,
  "leavingValuables": true
}
```

The API stores only `cardLast4`; it does not store the full card number.

### My Bookings

`GET /api/bookings?tab=active`

Requires `Authorization: Bearer <token>`.

Tabs:

```text
active
requests
history
```

Top filters:

```text
type=rapid
type=pending
```

### Booking Confirmation

`GET /api/bookings/:id`

Requires `Authorization: Bearer <token>`. Returns booking details and `qrCodeDataUrl`.

### Notify Host

`POST /api/bookings/:id/notify-host`

Requires `Authorization: Bearer <token>`. Use this when the reserved parking space is occupied. Returns the "Notification sent" response.

### Check In

`POST /api/bookings/:id/check-in`

Requires `Authorization: Bearer <token>`.

```json
{
  "confirmationCode": "PKL-XXXX-XXXX"
}
```

### Extension Options

`GET /api/bookings/:id/extension-options`

Requires `Authorization: Bearer <token>`.

### Extension Quote

`POST /api/bookings/:id/extension-quote`

Requires `Authorization: Bearer <token>`.

```json
{
  "additionalHours": 1
}
```

### Extend Time

`POST /api/bookings/:id/extend`

Requires `Authorization: Bearer <token>`.

```json
{
  "additionalHours": 1,
  "paymentMethod": "card"
}
```

### Check Out

`POST /api/bookings/:id/check-out`

Requires `Authorization: Bearer <token>`. Returns the final charged total and completed booking.

### Directions

`GET /api/bookings/:id/directions`

Requires `Authorization: Bearer <token>`. Returns Google Maps, Apple Maps, and Waze links.

## Favorites APIs

All favorites endpoints require `Authorization: Bearer <token>`.

### List Favorites

`GET /api/favorites`

Returns an empty-state message when there are no saved parking lots.

### Add Favorite

`POST /api/favorites/:parkingId`

`:parkingId` can be a Mongo id or slug.

### Remove Favorite

`DELETE /api/favorites/:parkingId`

## Account APIs

All account endpoints require `Authorization: Bearer <token>`.

### Profile

```text
GET   /api/account/profile
PATCH /api/account/profile
POST  /api/account/logout
```

Update profile body:

```json
{
  "fullName": "Carlos Marte",
  "phoneNumber": "+1 (809) 555-1234",
  "email": "carlos@email.com"
}
```

### Vehicles

```text
GET    /api/account/vehicles
POST   /api/account/vehicles
GET    /api/account/vehicles/:id
PATCH  /api/account/vehicles/:id
PATCH  /api/account/vehicles/:id/default
DELETE /api/account/vehicles/:id
```

Create vehicle body:

```json
{
  "type": "sedan",
  "plate": "A123456",
  "brand": "Toyota",
  "model": "Corolla",
  "year": 2020,
  "color": "White",
  "notes": "Small scratch on rear bumper."
}
```

Vehicle types: `sedan`, `suv_4x4`, `pickup`, `coupe`, `minivan_van`, `motorcycle`.

### Payment Methods

```text
GET    /api/account/payment-methods
POST   /api/account/payment-methods
PATCH  /api/account/payment-methods/:id/default
DELETE /api/account/payment-methods/:id
```

Create payment method body:

```json
{
  "cardNumber": "4111111111114242",
  "cardholderName": "CARLOS MARTE",
  "expiry": "12/28"
}
```

Only card metadata is stored: brand, last four digits, expiration, and cardholder name.

### Referrals

```text
GET  /api/account/referrals
POST /api/account/referrals
```

Create referral test body:

```json
{
  "referredName": "Roberto P",
  "status": "earned",
  "amount": 50
}
```

### Settings, Legal, Support

```text
GET   /api/account/settings
PATCH /api/account/settings
GET   /api/account/legal
GET   /api/account/legal/terms
GET   /api/account/legal/privacy
GET   /api/account/support
POST  /api/account/support/tickets
```

Support ticket body:

```json
{
  "type": "chat",
  "subject": "Need help",
  "message": "I need help with my booking."
}
```

## Host APIs

All host endpoints require `Authorization: Bearer <token>`.

### Host Welcome / Summary

`GET /api/host/summary`

Returns whether the user is a host, host invite code, and existing host parking drafts/listings.

### Start Host Onboarding

`POST /api/host/onboarding`

Marks the signed-in user as a host and creates the host invite code.

### Host Options

`GET /api/host/options`

Returns sectors, parking types, services, reservation modes, bank names, account types, and overtime multiplier options.

### Create Parking Draft

`POST /api/host/parkings`

```json
{
  "name": "Parking Carlos de Juan",
  "zone": "Colonial Zone",
  "addressLine": "Street number and building",
  "latitude": 18.4734,
  "longitude": -69.8849,
  "contactPhone": "+1 (809) 000-0000"
}
```

### Publish Wizard Steps

```text
PATCH /api/host/parkings/:id/location
PATCH /api/host/parkings/:id/details
PATCH /api/host/parkings/:id/spaces
PATCH /api/host/parkings/:id/services
PATCH /api/host/parkings/:id/photos
GET   /api/host/parkings/:id/review
POST  /api/host/parkings/:id/submit
```

Submitted listings are saved as `under_review` and are not public until approved.

### Host Panel

```text
GET /api/host/dashboard
GET /api/host/parkings
GET /api/host/parkings/:id
```

### Income and Withdrawals

```text
GET  /api/host/income
GET  /api/host/bank-account
PUT  /api/host/bank-account
POST /api/host/withdrawals
```

Bank account body:

```json
{
  "bankName": "Banco Popular",
  "accountType": "checking",
  "accountNumber": "01234567890",
  "accountHolderName": "Juan Carlos Perez",
  "identityDocument": "001-1234567-8"
}
```

### Host Pricing

```text
GET /api/host/parkings/:id/pricing
PUT /api/host/parkings/:id/pricing
```

```json
{
  "pricingMode": "per_section",
  "dynamicPricing": {
    "enabled": true,
    "occupancyThresholdPercent": 80,
    "peakIncreasePercent": 20
  },
  "sections": [
    {
      "code": "A",
      "name": "Ground Floor",
      "enabled": true,
      "rate": { "hourly": 150, "daily": 800, "weekly": 4500 }
    },
    {
      "code": "B",
      "name": "Level 1",
      "enabled": true,
      "rate": { "hourly": 120, "daily": 650, "weekly": 3800 }
    }
  ],
  "overtime": {
    "multiplier": 1.5,
    "graceMinutes": 0
  }
}

## Endpoints

Base URL: `http://localhost:5000`

### Health

`GET /api/health`

### Sign Up

`POST /api/auth/signup`

```json
{
  "firstName": "Juan",
  "lastName": "Perez",
  "phoneNumber": "+1 (809) 000-0000",
  "vehiclePlate": "A123456",
  "email": "juan@example.com",
  "password": "secret123",
  "confirmPassword": "secret123",
  "termsAccepted": true
}
```

`email` is optional because the provided sign-up screen does not show an email field. Add it if you want forgot-password by email to work for that user.

### Sign In

`POST /api/auth/signin`

```json
{
  "identifier": "juan@example.com",
  "password": "secret123",
  "rememberMe": true
}
```

`identifier` can be an email or phone number.

### Social Sign In

`POST /api/auth/social-signin`

```json
{
  "provider": "google",
  "providerUserId": "google-user-id",
  "email": "juan@example.com",
  "firstName": "Juan",
  "lastName": "Perez"
}
```

Supported providers: `google`, `apple`, `facebook`.

### Forgot Password

`POST /api/auth/forgot-password`

```json
{
  "email": "juan@example.com"
}
```

In development, the response includes `devResetCode`. In production, wire `issueResetCode` in `src/controllers/authController.js` to your email provider and do not return the code.

### Resend Code

`POST /api/auth/resend-reset-code`

```json
{
  "email": "juan@example.com"
}
```

### Verify Code

`POST /api/auth/verify-reset-code`

```json
{
  "email": "juan@example.com",
  "code": "123456"
}
```

Returns a short-lived `resetToken`.

### Set New Password

`POST /api/auth/reset-password`

```json
{
  "resetToken": "token-from-verify-reset-code",
  "newPassword": "newsecret123",
  "confirmPassword": "newsecret123"
}
```

### Current User

`GET /api/auth/me`

Header:

```text
Authorization: Bearer <token>
```
