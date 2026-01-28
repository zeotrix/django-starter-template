#!/bin/bash

# Django Project Setup Script
# This script checks for Python and sets up a Django project based on the MD file instructions

set -e  # Exit immediately if a command exits with a non-zero status

echo "Django Project Setup Script"
echo "============================"

# Ask for the directory to set up the Django project
echo ""
mkdir -p "django_template"
cd "django_template"
DJANGO_PROJECT_NAME="config"

# Main execution
main() {
    echo "Checking prerequisites..."
    echo ""

    check_python_version
    check_pip
    check_venv

    echo ""
    echo "All prerequisites are met!"
    echo "Setting up Django project environment..."

    # First create the virtual environment
    create_virtual_environment
    setup_virtual_environment
    install_django
    # Then create the Django project structure
    create_django_project  # This function ends in the project directory

    # Functions that need to run from the project directory
    create_settings_structure
    update_manage_py

    # Functions that need to run from the parent directory
    create_requirements_files
    create_env_file  # Create .env file before installing requirements
    install_requirements  # Install requirements after creating the files
    create_apps_directory
    create_static_directory
    update_wsgi_py
    run_initial_migrations

    echo ""
    echo "Django project setup completed successfully!"
    echo ""
    echo "Next steps (based on the Django Project Setup guide):"
    echo "1. Create a superuser: python manage.py createsuperuser"
    echo "2. Create your first app: python manage.py startapp myapp apps/myapp"
    echo "3. Add your app to INSTALLED_APPS in $DJANGO_PROJECT_NAME/settings/local.py"
    echo "4. Update your .env file with proper values for production"
    echo "5. Set the DJANGO_SETTINGS_MODULE environment variable:"
    echo "   export DJANGO_SETTINGS_MODULE=$DJANGO_PROJECT_NAME.settings.local"
    echo ""
    echo "To activate the virtual environment in the future, run:"
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        echo "  .venv\\Scripts\\activate"
    else
        echo "  source .venv/bin/activate"
    fi
    echo "To deactivate the virtual environment later, run: deactivate"
    echo ""
}

# Function to check Python version
check_python_version() {
    if ! command -v python3 &> /dev/null; then
        echo "Error: Python is not installed."
        echo ""
        echo "According to the Django Project Setup guide, you need to install Python first."
        echo "Please install Python 3.11, 3.12, or 3.13 (latest stable) before continuing."
        echo ""
        echo "Installation options:"
        echo "  - On Ubuntu/Debian: sudo apt update && sudo apt install python3.13 python3.13-venv python3.13-dev"
        echo "  - On macOS with Homebrew: brew install python@3.13"
        echo "  - On Windows: Download from https://www.python.org/downloads/"
        echo "  - Using pyenv (recommended):"
        echo "      curl https://pyenv.run | bash"
        echo "      pyenv install 3.13.11"
        echo "      pyenv global 3.13.11"
        echo ""
        exit 1
    fi

    # Get Python version
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)

    echo "Found Python version: $PYTHON_VERSION"

    # Check if Python version is compatible (3.11, 3.12, or 3.13)
    if [[ $PYTHON_MAJOR -eq 3 ]] && [[ $PYTHON_MINOR -ge 11 ]] && [[ $PYTHON_MINOR -le 13 ]]; then
        echo "Python version is compatible with Django setup requirements."
        return 0
    else
        echo "Warning: Python version $PYTHON_VERSION may not be compatible."
        echo "According to the Django Project Setup guide, Python 3.11, 3.12, or 3.13 are recommended."
        echo "Please consider upgrading to a compatible version."
        echo ""
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}


# Function to check if pip is available
check_pip() {
    if ! command -v pip &> /dev/null; then
        echo "Error: pip is not installed or not in PATH."
        echo ""
        echo "Please install pip (Python package installer) before continuing."
        echo "This is required for installing Django and other packages."
        echo ""
        exit 1
    fi
    
    echo "Found pip: $(pip --version)"
}

# Function to check if venv module is available
check_venv() {
    if ! python3 -m venv --help > /dev/null 2>&1; then
        echo "Error: venv module is not available."
        echo ""
        echo "Please install python3-venv package:"
        echo "  - On Ubuntu/Debian: sudo apt install python3-venv"
        echo "  - On other systems, check your Python installation"
        echo ""
        exit 1
    fi

    echo "Virtual environment (venv) module is available."
}

# Function to create virtual environment
create_virtual_environment() {
    echo ""
    echo "Creating virtual environment..."

    # Create virtual environment in the current directory (project root)
    if [ -d ".venv" ]; then
        echo "Warning: .venv directory already exists."
        read -p "Do you want to recreate it? This will delete the existing one. (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf .venv
            python3 -m venv .venv
            echo "New virtual environment created in .venv"
        else
            echo "Using existing .venv directory."
        fi
    else
        python3 -m venv .venv
        echo "Virtual environment created in .venv"
    fi
}
        
# Function to check if pip is available
check_pip() {
    if ! command -v pip &> /dev/null; then
        echo "Error: pip is not installed or not in PATH."
        echo ""
        echo "Please install pip (Python package installer) before continuing."
        echo "This is required for installing Django and other packages."
        echo ""
        exit 1
    fi
    
    echo "Found pip: $(pip --version)"
}

# Function to check if venv module is available
check_venv() {
    if ! python3 -m venv --help > /dev/null 2>&1; then
        echo "Error: venv module is not available."
        echo ""
        echo "Please install python3-venv package:"
        echo "  - On Ubuntu/Debian: sudo apt install python3-venv"
        echo "  - On other systems, check your Python installation"
        echo ""
        exit 1
    fi

    echo "Virtual environment (venv) module is available."
}

# Function to create virtual environment
create_virtual_environment() {
    echo ""
    echo "Creating virtual environment..."

    # Create virtual environment in the current directory (project root)
    if [ -d ".venv" ]; then
        echo "Warning: .venv directory already exists."
        read -p "Do you want to recreate it? This will delete the existing one. (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf .venv
            python3 -m venv .venv
            echo "New virtual environment created in .venv"
        else
            echo "Using existing .venv directory."
        fi
    else
        python3 -m venv .venv
        echo "Virtual environment created in .venv"
    fi
}

# Function to activate virtual environment and upgrade pip
setup_virtual_environment() {
    echo ""
    echo "Setting up virtual environment..."

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        VENV_PYTHON=.venv\\Scripts\\python.exe
        VENV_PIP=.venv\\Scripts\\pip.exe
    else
        # Linux/macOS
        VENV_PYTHON=.venv/bin/python
        VENV_PIP=.venv/bin/pip
    fi

    # Upgrade pip using the virtual environment's Python
    echo "Upgrading pip in the virtual environment..."
    $VENV_PYTHON -m pip install --upgrade pip
    echo "Pip upgraded successfully in the virtual environment."
}


# Function to install Django
install_django() {
    echo ""
    echo "Installing Django..."

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        VENV_PIP=.venv\\Scripts\\pip.exe
    else
        # Linux/macOS
        VENV_PIP=.venv/bin/pip
    fi

    $VENV_PIP install Django~=6.0.0
    echo "Django installed successfully."
}


# Function to create Django project
create_django_project() {
    echo ""
    echo "Creating Django project..."

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        DJANGO_ADMIN=.venv\\Scripts\\django-admin.exe
    else
        # Linux/macOS
        DJANGO_ADMIN=.venv/bin/django-admin
    fi

    # Check if Django project already exists
    if [ -d "$DJANGO_PROJECT_NAME" ] && [ -f "$DJANGO_PROJECT_NAME/manage.py" ]; then
        echo "Django project already exists."
    else
        # Create the project directory using Django's startproject command from current directory
        $DJANGO_ADMIN startproject "$DJANGO_PROJECT_NAME" .
        echo "Django project created successfully."
    fi
}


# Function to create settings directory structure
create_settings_structure() {
    echo ""
    echo "Creating settings directory structure..."

    cd "$DJANGO_PROJECT_NAME"

    # Create settings directory
    mkdir -p settings

    # Create __init__.py file
    touch settings/__init__.py

    # Create base settings file
    cat > settings/base.py << EOF
import os
from pathlib import Path
import environ

# Initialize environment variables
env = environ.Env(
    # set casting, default value
    DEBUG=(bool, False)
)

# Read .env file
environ.Env.read_env()

BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env('DEBUG')

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env('SECRET_KEY')

# ALLOWED_HOSTS from environment variable
ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=[])

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # Add your apps here later
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = '${DJANGO_PROJECT_NAME}.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.template.context_processors.media',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = '${DJANGO_PROJECT_NAME}.wsgi.application'

# Database
DATABASES = {
    'default': {
        'ENGINE': env('DB_ENGINE'),
        'NAME': env('DB_NAME'),
        'USER': env('DB_USER'),
        'PASSWORD': env('DB_PASSWORD'),
        'HOST': env('DB_HOST'),
        'PORT': env('DB_PORT'),
    }
}

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# Static files (CSS, JavaScript, Images)
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    BASE_DIR / "static",
]
STATIC_ROOT = BASE_DIR / "staticfiles"

# Media files
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Email settings
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = env('EMAIL_HOST')
EMAIL_PORT = env('EMAIL_PORT')
EMAIL_HOST_USER = env('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = env('EMAIL_HOST_PASSWORD')
EMAIL_USE_TLS = env('EMAIL_USE_TLS')

# Default primary key field type
# Django 6.0+ now defaults to BigAutoField instead of AutoField
# If upgrading from older Django versions, you may want to maintain backward compatibility:
DEFAULT_AUTO_FIELD = 'django.db.models.AutoField'  # For backward compatibility
# For new projects, you can use:
# DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
EOF

    # Create local settings file
    cat > settings/local.py << EOF
from .base import *

DEBUG = True

# Override specific settings for local development
ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# Use SQLite for local development (optional)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Email backend for development
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Content Security Policy for development (report-only mode)
SECURE_CSP_REPORT_ONLY = {
    'default-src': "'self'",
    'script-src': ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
    'style-src': ["'self'", "'unsafe-inline'"],
    'img-src': ["'self'", 'data:', 'localhost:*'],
    'font-src': ["'self'"],
    'connect-src': ["'self'", 'localhost:*'],
    'frame-ancestors': ["'self'"],
}

# Background Tasks Framework (New in Django 6.0)
TASKS = {
    'default': {
        'BACKEND': 'django.tasks.backends.development.DevelopmentBackend',
        'OPTIONS': {}
    }
}
EOF

    # Create staging settings file
    cat > settings/staging.py << EOF
from .base import *

DEBUG = False

# Staging-specific settings
ALLOWED_HOSTS = ['staging.yourdomain.com']

# Security settings for staging
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_SECONDS = 31536000
SECURE_REDIRECT_EXEMPT = []
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# Use the database settings from environment variables
# DATABASES configuration comes from base.py

# Content Security Policy (New in Django 6.0)
SECURE_CSP_REPORT_ONLY = {
    'default-src': "'self'",
    'script-src': ["'self'", "'unsafe-inline'", 'www.google-analytics.com'],
    'style-src': ["'self'", "'unsafe-inline'", 'fonts.googleapis.com'],
    'img-src': ["'self'", 'data:', 'www.google-analytics.com'],
    'font-src': ["'self'", 'fonts.gstatic.com'],
    'connect-src': ["'self'", 'api.staging.yourdomain.com'],
    'frame-ancestors': ["'none'"],
}

# Background Tasks Framework (New in Django 6.0)
TASKS = {
    'default': {
        'BACKEND': 'django.tasks.backends.redis.RedisBackend',
        'OPTIONS': {
            # Redis backend options
            'host': 'localhost',
            'port': 6379,
            'db': 0,
        }
    }
}
EOF

    # Create production settings file
    cat > settings/production.py << EOF
from .base import *

DEBUG = False

# Production-specific settings
ALLOWED_HOSTS = ['yourdomain.com', 'www.yourdomain.com']

# Security settings for production
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_SECONDS = 31536000
SECURE_REDIRECT_EXEMPT = []
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# Additional production security settings
SECURE_REFERRER_POLICY = 'same-origin'
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# Content Security Policy (New in Django 6.0)
SECURE_CSP = {
    'default-src': "'self'",
    'script-src': ["'self'", 'www.google-analytics.com'],
    'style-src': ["'self'", 'fonts.googleapis.com'],
    'img-src': ["'self'", 'data:', 'www.google-analytics.com'],
    'font-src': ["'self'", 'fonts.gstatic.com'],
    'connect-src': ["'self'", 'api.yourdomain.com'],
    'frame-ancestors': ["'none'"],
}

# Background Tasks Framework (New in Django 6.0)
TASKS = {
    'default': {
        'BACKEND': 'django.tasks.backends.database.DatabaseBackend',
        'OPTIONS': {
            # Database backend options
        }
    }
}
EOF

    # Create testing settings file
    cat > settings/testing.py << EOF
from .base import *

DEBUG = True

# Use an in-memory database for faster tests
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

# Disable migrations for faster testing
class DisableMigrations:
    def __contains__(self, item):
        return True

    def __getitem__(self, item):
        return None

MIGRATION_MODULES = DisableMigrations()

# Use console email backend for testing
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Content Security Policy for testing
SECURE_CSP_REPORT_ONLY = {
    'default-src': "'self'",
    'script-src': ["'self'", "'unsafe-inline'"],
    'style-src': ["'self'", "'unsafe-inline'"],
    'img-src': ["'self'", 'data:'],
    'font-src': ["'self'"],
    'connect-src': ["'self'"],
    'frame-ancestors': ["'none'"],
}

# Background Tasks Framework for testing
TASKS = {
    'default': {
        'BACKEND': 'django.tasks.backends.testing.TestingBackend',
        'OPTIONS': {}
    }
}
EOF
    cd ..
    echo "Settings directory structure created successfully."
}


# Function to create requirements files
create_requirements_files() {
    echo ""
    echo "Creating requirements directory and files..."

    # Create requirements directory
    mkdir -p requirements

    # Create base requirements file
    cat > requirements/base.txt << 'EOF'
# Django Framework
Django~=6.0.0

# Environment variables management
django-environ

# Database drivers (choose based on your database)
psycopg2-binary>=2.9.9  # For PostgreSQL, updated for Django 6.0 compatibility
# mysqlclient>=2.2.0     # For MySQL (uncomment if using MySQL), updated for Django 6.0 compatibility

# Essential packages
Pillow>=10.0.0          # For image handling, updated for Django 6.0 compatibility
whitenoise>=6.6.0       # For static file serving in development, updated for Django 6.0 compatibility
python-decouple>=3.8    # Alternative to django-environ (optional), updated for Django 6.0 compatibility
EOF

    # Create local requirements file
    cat > requirements/local.txt << 'EOF'
# Include base requirements
-r base.txt

# Development tools
django-debug-toolbar>=4.3.0  # Updated for Django 6.0 compatibility
django-extensions>=3.2.3     # Updated for Django 6.0 compatibility

# Testing tools
pytest-django>=4.8.0         # Updated for Django 6.0 compatibility
factory-boy>=3.3.0           # Updated for Django 6.0 compatibility
coverage>=7.6.0              # Updated for Django 6.0 compatibility

# Code quality
flake8>=7.0.0               # Updated for Django 6.0 compatibility
black>=24.0.0               # Updated for Django 6.0 compatibility
isort>=5.13.0               # Updated for Django 6.0 compatibility
pre-commit>=3.5.0           # Updated for Django 6.0 compatibility

# Additional development utilities
django-livereload-server>=0.4
Werkzeug>=3.0.0             # For better debugging, updated for Django 6.0 compatibility
EOF

    # Create staging requirements file
    cat > requirements/staging.txt << 'EOF'
# Include base requirements
-r base.txt

# Monitoring and performance
sentry-sdk>=2.0.0        # Error tracking, updated for Django 6.0 compatibility
django-silk>=5.2.0       # Profiling, updated for Django 6.0 compatibility

# Additional staging-specific packages
gunicorn>=22.0.0         # WSGI server, updated for Django 6.0 compatibility
EOF

    # Create production requirements file
    cat > requirements/production.txt << 'EOF'
# Include base requirements
-r base.txt

# Production-specific packages
gunicorn>=22.0.0         # WSGI server, updated for Django 6.0 compatibility
sentry-sdk>=2.0.0        # Error tracking, updated for Django 6.0 compatibility
django-storages>=1.14.0  # Cloud storage backends, updated for Django 6.0 compatibility
boto3>=1.34.0            # AWS SDK for S3 (if using S3), updated for Django 6.0 compatibility
whitenoise>=6.6.0        # Static file serving, updated for Django 6.0 compatibility

# Security packages
django-cors-headers>=4.3.0    # CORS handling, updated for Django 6.0 compatibility
djangorestframework>=3.15.0   # If building APIs, updated for Django 6.0 compatibility
EOF

    echo "Requirements files created successfully."
}

# Function to create apps directory
create_apps_directory() {
    echo ""
    echo "Creating apps directory..."

    # Create apps directory in the current directory (parent directory where we are now)
    mkdir -p apps
    touch apps/__init__.py

    echo "Apps directory created successfully."
}


# Function to create static directory
create_static_directory() {
    echo ""
    echo "Creating static directory..."

    # Create static directory in the project directory (inside config)
    mkdir -p static
    mkdir -p staticfiles
    echo "Static directory created successfully."

}


# Function to update wsgi.py
update_wsgi_py() {
    echo ""
    echo "Updating wsgi.py for proper settings module..."

    cd "$DJANGO_PROJECT_NAME"

    # Update wsgi.py to use local settings
    sed -i "s|'${DJANGO_PROJECT_NAME}.settings'|'${DJANGO_PROJECT_NAME}.settings.local'|g" wsgi.py

    echo "wsgi.py updated successfully."

    # Go back to parent directory
    cd ..
}


# Function to update manage.py
update_manage_py() {
    echo ""
    echo "Updating manage.py for apps directory support..."

    # We're already in the project directory where manage.py is located
    # Create the manage.py file with the project name substituted
    cat > manage.py << EOF
#!/usr/bin/env python
import os
import sys

# Add the project directory to the Python path so Django can find the apps and the inner config module
project_root = os.path.dirname(__file__)
sys.path.insert(0, project_root)
# Also add the apps directory to Python path so the individual apps can be imported
sys.path.insert(0, os.path.join(project_root, 'apps'))

if __name__ == '__main__':
    # Import environ to load .env file before Django settings are processed
    import environ

    # Load environment variables from .env file
    env = environ.Env()
    environ.Env.read_env(os.path.join(project_root, '.env'))

    # Get the Django settings module from environment variable, default to local
    settings_module = os.environ.get('DJANGO_SETTINGS_MODULE', '$DJANGO_PROJECT_NAME.settings.local')
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', settings_module)
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)
EOF

    echo "manage.py updated successfully."
}


# Function to run initial migrations
run_initial_migrations() {
    echo ""
    echo "Running initial migrations..."

    # We're in the parent directory where virtual environment and .env file are located
    # Run migrations using the virtual environment from current directory and project from subdirectory
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        # Set environment variable and run migrations
        export DJANGO_SETTINGS_MODULE=$DJANGO_PROJECT_NAME.settings.local
        .venv\\Scripts\\python.exe $DJANGO_PROJECT_NAME/manage.py migrate
    else
        # Linux/macOS
        # Set the DJANGO_SETTINGS_MODULE environment variable
        export DJANGO_SETTINGS_MODULE=$DJANGO_PROJECT_NAME.settings.local

        # Run migrations using the virtual environment from current directory and project from subdirectory
        # Source the virtual environment to ensure all packages are available
        source .venv/bin/activate
        python manage.py migrate
    fi

    echo "Initial migrations completed successfully."
}


# Function to create .env file
create_env_file() {
    echo ""
    echo "Creating .env file with default values..."

    # Generate a random secret key for Django
    SECRET_KEY_VALUE=$(python3 -c "import secrets; print(secrets.token_urlsafe(50))")

    # Create .env file in the current directory (project root) with the generated secret key
    {
        echo "# Security"
        echo "SECRET_KEY=$SECRET_KEY_VALUE"
        echo "DEBUG=True"
        echo "ALLOWED_HOSTS=localhost,127.0.0.1,.localhost"
        echo ""
        echo "# Database (SQLite for development)"
        echo "DB_ENGINE=django.db.backends.sqlite3"
        echo "DB_NAME=db.sqlite3"
        echo "DB_USER="
        echo "DB_PASSWORD="
        echo "DB_HOST="
        echo "DB_PORT="
        echo ""
        echo "# Email settings (using console backend for development)"
        echo "EMAIL_HOST=smtp.gmail.com"
        echo "EMAIL_PORT=587"
        echo "EMAIL_HOST_USER=your-email@gmail.com"
        echo "EMAIL_HOST_PASSWORD=your-app-password"
        echo "EMAIL_USE_TLS=True"
        echo ""
        echo "# Redis Configuration (for caching, sessions, or background tasks)"
        echo "REDIS_URL=redis://127.0.0.1:6379/0"
        echo ""
        echo "# Logging level"
        echo "LOG_LEVEL=INFO"
        echo ""
        echo "# Timezone"
        echo "TIME_ZONE=UTC"
    } > .env

    # Also create the credentials directory and copy the .env file there for safekeeping
    mkdir -p "credentials"
    cp .env credentials/.env

    echo ".env file created successfully in project root and copied to credentials directory."
}

# Function to install requirements
install_requirements() {
    echo ""
    echo "Installing requirements from requirements/local.txt..."

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        VENV_PIP=.venv\\Scripts\\pip.exe
    else
        # Linux/macOS
        VENV_PIP=.venv/bin/pip
    fi

    $VENV_PIP install -r requirements/local.txt

    echo "Requirements installed successfully."
}

# Call main function
main "$@"