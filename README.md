# Django Starter Template

A comprehensive guide and template for setting up Django projects from scratch with best practices.

## Overview

This repository contains a detailed guide for setting up Django projects following industry best practices, including:
- Proper project structure
- Environment configuration
- Settings organization
- Requirements management
- Security considerations

## Contents

The guide covers everything from initial setup to deployment considerations, including:
- Python environment setup
- Django project creation
- Settings configuration for different environments
- Requirements management
- App organization
- Git configuration

## Automated Setup

This repository includes an automated setup script (`setup_django.sh`) that implements all the steps described in the manual guide. The script will:

- Check for Python prerequisites and version compatibility
- Create a virtual environment
- Install Django and required packages
- Generate the complete project structure with settings files for different environments
- Create requirements files for different environments
- Set up static and media directories
- Configure environment variables
- Run initial migrations

### Usage

To use the automated setup script:

1. Make the script executable:
   ```bash
   chmod +x setup_django.sh
   ```

2. Run the script:
   ```bash
   ./setup_django.sh
   ```

The script will create a new directory called `django_template` with your complete Django project structure inside.

### Features

The automated setup script creates:

- A Django project with a `config` directory containing:
  - Multiple settings files for different environments (base, local, staging, production, testing)
  - Proper environment variable configuration using `django-environ`
  - Security configurations for each environment
- Virtual environment in `.venv`
- Requirements files organized by environment
- Apps directory for custom applications
- Static and media file directories
- Proper `.env` file with default settings
- Credentials directory for secure storage of sensitive files

### Project Structure

After running the script, you'll have the following project structure:

```
django_template/
├── .env                          # Environment variables
├── .gitignore                    # Git ignore file
├── credentials/                  # Secure directory for sensitive files
│   └── .env                     # Copy of environment variables
├── apps/                        # Directory for custom Django apps
│   └── __init__.py
├── config/                      # Django project settings
│   ├── __init__.py
│   ├── settings/                # Environment-specific settings
│   │   ├── __init__.py
│   │   ├── base.py              # Base settings shared across environments
│   │   ├── local.py             # Local development settings
│   │   ├── staging.py           # Staging environment settings
│   │   ├── production.py        # Production environment settings
│   │   └── testing.py           # Testing environment settings
│   ├── urls.py                  # URL configuration
│   ├── wsgi.py                  # WSGI configuration
│   └── asgi.py                  # ASGI configuration
├── requirements/                # Environment-specific requirements
│   ├── base.txt                 # Base requirements
│   ├── local.txt                # Development requirements
│   ├── staging.txt              # Staging requirements
│   └── production.txt           # Production requirements
├── static/                      # Static files directory
├── staticfiles/                 # Collected static files
├── templates/                   # Templates directory
├── manage.py                    # Django management utility
└── .venv/                       # Virtual environment
```

## Manual Setup

Alternatively, follow the guide in [Django_Project_Setup_From_Scratch.md](Django_Project_Setup_From_Scratch.md) to set up your Django project manually.

## Contributing

Feel free to submit issues or pull requests to improve this starter template.