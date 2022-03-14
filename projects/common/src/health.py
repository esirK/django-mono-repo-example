import django

def status():
    return {"status": "UP", "version": django.get_version()}
