from django.http import JsonResponse

from src.health import status

def get_health(request):
    """
    Health endpoint for ActNow.
    """
    return JsonResponse(status())
