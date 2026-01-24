# Django Project Setup From Scratch Guide

This guide will walk you through setting up a Django project from the very beginning, covering everything from installation to initial configuration.

## Prerequisites

Before starting, ensure you have the following installed:
- Python 3.11, 3.12, or 3.13 (latest stable)
- pip (Python package installer)
- Virtual environment tool (venv or virtualenv)

### Upgrading Python

To upgrade to Python 3.13, use one of these methods:

#### Using pyenv (recommended):
```bash
# Install pyenv if you don't have it
curl https://pyenv.run | bash

# Install and set Python 3.13.x as global
pyenv install 3.13.11
pyenv global 3.13.11
```

#### Using package managers:
```bash
# On Ubuntu/Debian
sudo apt update
sudo apt install python3.13 python3.13-venv python3.13-dev

# On macOS with Homebrew
brew install python@3.13

# On Windows
# Download from https://www.python.org/downloads/
```

## Step 1: Setting Up Your Environment

### Create a Virtual Environment

```bash
# Create a virtual environment named '.venv'
python -m venv .venv

# On Windows
python -m venv .venv

# On macOS/Linux
python3 -m venv .venv
```

### Activate the Virtual Environment

```bash
# On Windows
.venv\Scripts\activate

# On macOS/Linux
source .venv/bin/activate
```

### Upgrade pip (recommended)

```bash
python -m pip install --upgrade pip
```

## Step 2: Setting Environment Variables and Installing Django

Set the Django settings module environment variable before installing Django:

The DJANGO_SETTINGS_MODULE can be set to different environments depending on your needs:

- `config.settings.local` - For local development
- `config.settings.staging` - For staging environment
- `config.settings.production` - For production environment
- `config.settings.testing` - For running tests

For local development, set the environment variable:

```bash
# Set the environment variable for the current session
export DJANGO_SETTINGS_MODULE=config.settings.local
```

To make this setting persistent across system restarts, add it to your shell profile file:

For **bash** (add to `~/.bashrc` or `~/.bash_profile`):
```bash
echo 'export DJANGO_SETTINGS_MODULE=config.settings.local' >> ~/.bashrc
source ~/.bashrc
```

For **zsh** (add to `~/.zshrc`):
```bash
echo 'export DJANGO_SETTINGS_MODULE=config.settings.local' >> ~/.zshrc
source ~/.zshrc
```

For **system-wide configuration** (add to `/etc/environment` on Ubuntu/Debian):
```bash
echo 'DJANGO_SETTINGS_MODULE=config.settings.local' | sudo tee -a /etc/environment
```

For **Windows**, set the environment variable through System Properties or PowerShell:
```powershell
[Environment]::SetEnvironmentVariable("DJANGO_SETTINGS_MODULE", "config.settings.local", "User")
```

Now install Django:

```bash
pip install Django
```

To install a specific version of Django (recommended for stability):

```bash
pip install Django~=6.0.0
```

## Step 3: Creating Your Django Project

```bash
mkdir -p ~/Projects/DjangoProject
cd ~/Projects/DjangoProject
django-admin startproject config .
```

This creates a project structure like:

```
~/Projects/DjangoProject/
    manage.py
    config/
        __init__.py
        settings.py
        urls.py
        wsgi.py
        asgi.py
```

## Step 4: Basic Configuration

### Environment Variables Setup

For better security and configuration management, use environment variables for sensitive settings:

```bash
pip install django-environ
```

Create a `.env` file in your project root directory (`~/Projects/DjangoProject/.env`):

```
# Security
SECRET_KEY=your-very-long-and-random-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,.yourdomain.com

# Database
DB_ENGINE=django.db.backends.postgresql
DB_NAME=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_HOST=localhost
DB_PORT=5432

# Email settings
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
EMAIL_USE_TLS=True

# Third-party API keys
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key
```

### Using Multiple Settings Files

Following the practices, organize your settings into multiple files:

```bash
# Inside the config directory, create a settings subdirectory
mkdir config/settings
touch config/settings/__init__.py
touch config/settings/base.py
touch config/settings/local.py
touch config/settings/staging.py
touch config/settings/production.py
touch config/settings/testing.py
```

Move the default settings from `config/settings.py` to `config/settings/base.py`:

**config/settings/base.py**
```python
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

BASE_DIR = Path(__file__).resolve().parent.parent.parent

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
    'django.contrib.contenttypes.middleware.ContentTypeMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

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

WSGI_APPLICATION = 'config.wsgi.application'

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
```

**config/settings/local.py**
```python
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

```

# Background Tasks Framework (New in Django 6.0)
TASKS = {
    'default': {
        'BACKEND': 'django.tasks.backends.development.DevelopmentBackend',
        'OPTIONS': {}
    }
}
```

**config/settings/staging.py**
```python
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
```

**config/settings/production.py**
```python
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
```

**config/settings/testing.py**
```python
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
```

To use different settings files, specify the settings module when running Django commands:

```bash
# For local development
python manage.py runserver --settings=config.settings.local

# For staging
python manage.py runserver --settings=config.settings.staging

# For production
python manage.py runserver --settings=config.settings.production

# Once you set the environment variable (as shown earlier),
# you can run commands without specifying settings each time
python manage.py runserver
```

### Requirements Files

Following the practices, organize your requirements into multiple files for different environments:

```bash
# Create a requirements directory
mkdir requirements

# Create requirements files for different environments
touch requirements/base.txt
touch requirements/local.txt
touch requirements/staging.txt
touch requirements/production.txt
```

**requirements/base.txt**
```txt
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
```

**requirements/local.txt**
```txt
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
```

**requirements/staging.txt**
```txt
# Include base requirements
-r base.txt

# Monitoring and performance
sentry-sdk>=2.0.0        # Error tracking, updated for Django 6.0 compatibility
django-silk>=5.2.0       # Profiling, updated for Django 6.0 compatibility

# Additional staging-specific packages
gunicorn>=22.0.0         # WSGI server, updated for Django 6.0 compatibility
```

**requirements/production.txt**
```txt
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
```

To install requirements for a specific environment:

```bash
# For local development
pip install -r requirements/local.txt

# For staging
pip install -r requirements/staging.txt

# For production
pip install -r requirements/production.txt
```

This approach allows you to:
- Keep core dependencies in base.txt
- Add development-specific tools to local.txt
- Include monitoring tools in staging.txt
- Add production-specific packages to production.txt
- Easily manage dependencies for different environments
- Follow the DRY principle by inheriting from base requirements

## Step 5: Update manage.py for Apps Directory

When using an apps directory, you need to update manage.py to ensure Django can find your apps:

**manage.py**
```python
#!/usr/bin/env python
import os
import sys

# Add the project root directory to the Python path so Django can find the apps
project_root = os.path.dirname(__file__)
sys.path.insert(0, project_root)
# Also add the apps directory to Python path so the individual apps can be imported
sys.path.insert(0, os.path.join(project_root, 'apps'))

if __name__ == '__main__':
    # Get the Django settings module from environment variable, default to local
    settings_module = os.environ.get('DJANGO_SETTINGS_MODULE', 'config.settings.local')
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
```

## Step 6: Create Apps Directory and Your First App

Create an apps directory to organize your Django applications:

```bash
# Create an apps directory
mkdir apps
touch apps/__init__.py
```

Now create your first app inside the apps directory:

```bash
# Create your app inside the apps directory
python manage.py startapp myapp apps/myapp
```

Add your app to `INSTALLED_APPS` in the appropriate settings file (e.g., `config/settings/local.py`):

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'apps.myapp',  # Add your app here with the apps prefix
]
```

For better organization, you can create multiple apps in the apps directory:

```bash
# Create additional apps
python manage.py startapp accounts apps/accounts
python manage.py startapp blog apps/blog
python manage.py startapp contact apps/contact
```

Then add them to your INSTALLED_APPS:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'apps.myapp',
    'apps.accounts',
    'apps.blog',
    'apps.contact',
]
```

This approach helps keep your project organized as it grows, with all custom applications contained within the apps directory.

## Step 7: Version Control with Git

Initialize a Git repository for your Django project:

```bash
# Initialize git repository
git init

# Create a .gitignore file to exclude unnecessary files
touch .gitignore
```

Add the following content to your `.gitignore` file:

```
# Created by https://www.toptal.com/developers/gitignore/api/django,python,venv
# Edit at https://www.toptal.com/developers/gitignore?templates=django,python,venv

### Django ###
*.log
*.pot
*.pyc
__pycache__/
local_settings.py
db.sqlite3
db.sqlite3-journal
media

# If your build process includes running collectstatic, then you probably don't need or want to include staticfiles/
# in your Git repository. Update and uncomment the following line accordingly.
# <django-project-name>/staticfiles/

### Django.Python Stack ###
# Byte-compiled / optimized / DLL files
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo

# Django stuff:

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
#poetry.lock

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#pdm.lock
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/#use-with-ide
.pdm.toml

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#  and can be added to the global gitignore or merged into this file.  For a more nuclear
#  option (not recommended) you can uncomment the following to ignore the entire idea folder.
#.idea/

### Python ###
# Byte-compiled / optimized / DLL files

# C extensions

# Distribution / packaging

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.

# Installer logs

# Unit test / coverage reports

# Translations

# Django stuff:

# Flask stuff:

# Scrapy stuff:

# Sphinx documentation

# PyBuilder

# Jupyter Notebook

# IPython

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/#use-with-ide

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm

# Celery stuff

# SageMath parsed files

# Environments

# Spyder project settings

# Rope project settings

# mkdocs documentation

# mypy

# Pyre type checker

# pytype static type analyzer

# Cython debug symbols

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#  and can be added to the global gitignore or merged into this file.  For a more nuclear
#  option (not recommended) you can uncomment the following to ignore the entire idea folder.

### Python Patch ###
# Poetry local configuration file - https://python-poetry.org/docs/configuration/#local-configuration
poetry.toml

# ruff
.ruff_cache/

# LSP config files
pyrightconfig.json

### venv ###
# Virtualenv
# http://iamzed.com/2009/05/07/a-primer-on-virtualenv/
[Bb]in
[Ii]nclude
[Ll]ib
[Ll]ib64
[Ll]ocal
[Ss]cripts
pyvenv.cfg
pip-selfcheck.json

# End of https://www.toptal.com/developers/gitignore/api/django,python,venv
```

Configure Git for your project:

```bash
# Add all files to git
git add .

# Make your first commit
git commit -m "Initial commit: Django project setup with multiple settings and requirements files"
```

Set up a remote repository (optional but recommended):

```bash
# Add a remote origin (replace with your actual repository URL)
git remote add origin https://github.com/yourusername/your-repo-name.git

# Push your initial commit
git push -u origin main
```

Best practices for Git with Django:
- Never commit sensitive information (passwords, API keys, etc.)
- Use environment variables for sensitive data
- Commit your requirements files to track dependencies
- Use meaningful commit messages
- Create branches for new features
- Regularly pull changes from the main branch when working in teams

## Step 8: Run Initial Migrations

```bash
python manage.py migrate
```

## Step 9: Create a Superuser

```bash
python manage.py createsuperuser
```

Follow the prompts to set username, email, and password.

## Step 10: Create Models (in apps/myapp/models.py)

```python
from django.db import models

class MyModel(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
```

## Step 11: Create and Apply Migrations

```bash
python manage.py makemigrations
python manage.py migrate
```

## Step 12: Register Models in Admin (apps/myapp/admin.py)

```python
from django.contrib import admin
from .models import MyModel

@admin.register(MyModel)
class MyModelAdmin(admin.ModelAdmin):
    list_display = ('title', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('title',)
```

## Step 13: Create Views (apps/myapp/views.py)

```python
from django.shortcuts import render
from django.http import HttpResponse
from apps.myapp.models import MyModel

def home(request):
    my_objects = MyModel.objects.all()
    return render(request, 'myapp/home.html', {'objects': my_objects})

def detail(request, pk):
    obj = MyModel.objects.get(pk=pk)
    return render(request, 'myapp/detail.html', {'object': obj})
```

## Step 14: Configure URLs

Create `myapp/urls.py`:

```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('<int:pk>/', views.detail, name='detail'),
]
```

Update `config/urls.py`:

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('apps.myapp.urls')),
]
```

## Step 15: Create Templates

Create the template directory structure:

```
~/Projects/DjangoProject/
    templates/
        myapp/
            base.html
            home.html
            detail.html
```

### templates/myapp/base.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}My Django Site{% endblock %}</title>
</head>
<body>
    <header>
        <h1>My Django Site</h1>
    </header>
    
    <main>
        {% block content %}
        {% endblock %}
    </main>
    
    <footer>
        <p>&copy; 2023 My Django Site</p>
    </footer>
</body>
</html>
```

### templates/myapp/home.html

```html
{% extends 'myapp/base.html' %}

{% block title %}Home - {{ block.super }}{% endblock %}

{% block content %}
<h2>Welcome to My Django Site</h2>
<div>
    {% for obj in objects %}
        <div>
            <h3><a href="{% url 'detail' obj.pk %}">{{ obj.title }}</a></h3>
            <p>{{ obj.content|truncatewords:30 }}</p>
        </div>
    {% empty %}
        <p>No objects yet.</p>
    {% endfor %}
</div>
{% endblock %}
```

## Step 16: Collect Static Files

```bash
python manage.py collectstatic
```

## Step 17: Run the Development Server

```bash
python manage.py runserver
```

Your Django project should now be accessible at `http://127.0.0.1:8000/`.



## Common Next Steps

1. Set up proper logging
2. Configure caching
3. Add form handling
4. Implement user authentication
5. Add testing
6. Set up deployment configuration

## Useful Management Commands

```bash
# Check for any issues in your project
python manage.py check

# Create a superuser (if not done already)
python manage.py createsuperuser

# Open Django shell
python manage.py shell

# Clear migrations (for development only!)
python manage.py flush

# Find duplicate migrations
python manage.py showmigrations
```

This guide provides a solid foundation for starting a Django project. Customize the settings and structure based on your specific project needs.