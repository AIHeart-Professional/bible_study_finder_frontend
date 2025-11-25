# Configuration Guide

This directory contains configuration files for the Bible Study Finder app.

## Files

- **app_config.dart** - Main configuration file for API keys, URLs, and app settings
- **url_store.dart** - Legacy compatibility layer (deprecated, use app_config.dart instead)

## Usage

### Frontend Configuration (Flutter)

The main configuration is in `app_config.dart`. Import and use it like this:

```dart
import '../utils/app_config.dart';

// Get API configuration
final apiUrl = AppConfig.bibleApiUrl;
final apiKey = AppConfig.bibleApiKey;

// Get backend URL
final backendUrl = AppConfig.getBackendBaseUrl();

// Check environment
if (AppConfig.isDevelopment()) {
  // Development-only code
}
```

### Backend Configuration (Python)

The main configuration is in `config.py`. Import and use it like this:

```python
from config import config

# Get configuration values
db_url = config.DATABASE_URL
api_key = config.BIBLE_API_KEY

# Check environment
if config.is_development():
    # Development-only code
```

## Environment Variables (Backend)

You can override configuration values using environment variables or a `.env` file:

```bash
# .env file
DEBUG=true
ENVIRONMENT=development
DATABASE_URL=postgresql://user:password@localhost/bible_study
BIBLE_API_KEY=your-api-key-here
```

## Security Warning

**⚠️ IMPORTANT**: These configuration files are for development only.

For production deployment (e.g., OpenShift, Kubernetes):
1. Use environment variables or secrets management
2. Never commit sensitive data to version control
3. Use CI/CD pipelines to inject configuration at deployment time
4. Consider using services like:
   - OpenShift Secrets
   - Kubernetes Secrets
   - AWS Secrets Manager
   - HashiCorp Vault

## Configuration Values

### Frontend (app_config.dart)
- API URLs and keys
- Backend base URL
- App metadata (name, version)
- Feature flags
- Cache settings
- API timeouts
- Pagination defaults

### Backend (config.py)
- Server configuration (host, port)
- CORS settings
- Database configuration
- API versioning
- Security settings
- External API keys
- Environment detection

## Migration to Production

When moving to production:
1. Remove hardcoded values from both config files
2. Set up environment variables or secret management
3. Update CI/CD pipelines to inject configuration
4. Use platform-specific secret management (OpenShift, Kubernetes, etc.)
5. Enable secure configuration loading

