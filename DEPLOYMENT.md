# Deployment Guide

This guide explains how to configure the app for deployment through Codemagic with the Render backend API.

## Environment Configuration

The app uses environment variables to switch between local development and production API endpoints.

### Local Development

When running locally, the app automatically uses:
- **Web**: `http://localhost:8000`
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`
- **Desktop**: `http://localhost:8000`

### Production (Codemagic)

When building through Codemagic, the app uses the Render API URL specified in the `codemagic.yaml` file.

## Setting Up Codemagic

### 1. Update Render API URL

Edit `codemagic.yaml` and replace the placeholder with your actual Render backend URL:

```yaml
vars:
  BACKEND_API_URL: "https://your-backend-app.onrender.com"
  APP_ENVIRONMENT: "production"
```

**Important**: Replace `https://your-backend-app.onrender.com` with your actual Render backend URL.

### 2. Configure Codemagic Secrets (Optional but Recommended)

For better security, you can store the API URL as a secret in Codemagic:

1. Go to your Codemagic project settings
2. Navigate to **Environment variables**
3. Add a new variable:
   - **Name**: `BACKEND_API_URL`
   - **Value**: Your Render backend URL (e.g., `https://your-backend-app.onrender.com`)
   - **Group**: Create a new group or use existing
4. Update `codemagic.yaml` to reference the secret:

```yaml
environment:
  groups:
    - your_secrets_group  # Add your secrets group here
  vars:
    APP_ENVIRONMENT: "production"
```

Then update the build scripts to use the environment variable:

```yaml
scripts:
  - name: Build iOS
    script: |
      flutter build ios \
        --release \
        --dart-define=BACKEND_API_URL="$BACKEND_API_URL" \
        --dart-define=APP_ENVIRONMENT="$APP_ENVIRONMENT"
```

### 3. Build Configuration

The `codemagic.yaml` file is configured to build for:
- **iOS** (release)
- **Android** (APK release)
- **Web** (release)

All builds automatically include the `BACKEND_API_URL` and `APP_ENVIRONMENT` variables.

### 4. Automatic Deployment

The workflow is configured to automatically trigger on:
- **Pushes to the `main` branch**: Every commit to `main` will automatically trigger a build and deployment

This means you don't need to manually trigger builds - simply push to `main` and Codemagic will handle the rest.

## How It Works

1. **Environment Detection**: The app checks for the `BACKEND_API_URL` environment variable set via `--dart-define` during build.

2. **Priority Order**:
   - If `BACKEND_API_URL` is set (production builds), use it
   - Otherwise, fall back to platform-specific localhost URLs (local development)

3. **Environment Mode**: The `APP_ENVIRONMENT` variable controls:
   - Debug mode (disabled in production)
   - Logging levels
   - Other environment-specific features

## Testing Locally with Production URL

To test the production configuration locally, you can run:

```bash
flutter run --dart-define=BACKEND_API_URL=https://your-backend-app.onrender.com --dart-define=APP_ENVIRONMENT=production
```

Or for a specific platform:

```bash
# Android
flutter build apk --dart-define=BACKEND_API_URL=https://your-backend-app.onrender.com --dart-define=APP_ENVIRONMENT=production

# iOS
flutter build ios --dart-define=BACKEND_API_URL=https://your-backend-app.onrender.com --dart-define=APP_ENVIRONMENT=production

# Web
flutter build web --dart-define=BACKEND_API_URL=https://your-backend-app.onrender.com --dart-define=APP_ENVIRONMENT=production
```

## Verification

After deployment, verify the app is using the correct API URL by:

1. Checking the app logs (if debug mode is enabled)
2. Testing API calls to ensure they're going to the Render backend
3. Using the `AppConfig.getBackendApiUrlForLogging()` method in debug builds

## Troubleshooting

### App Still Using Localhost in Production

- Verify `BACKEND_API_URL` is set in `codemagic.yaml`
- Check that the build scripts include `--dart-define=BACKEND_API_URL="$BACKEND_API_URL"`
- Ensure the Render URL is correct and accessible

### API Calls Failing

- Verify your Render backend is running and accessible
- Check CORS configuration on your backend to allow requests from your app's domain
- Verify the API URL format (should include `https://` and not have a trailing slash)

### Build Errors

- Ensure all environment variables are properly quoted in `codemagic.yaml`
- Check that the Render URL doesn't contain special characters that need escaping
- Verify Codemagic has access to any required secrets groups
