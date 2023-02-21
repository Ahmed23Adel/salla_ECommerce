from django.shortcuts import render
from rest_framework  import generics
from .models import NrmlSerller
from .serializers import NrmlSlrUserSerializer
from rest_framework import permissions, authentication
from rest_framework_simplejwt.authentication import JWTAuthentication

# Create your views here.

class NrmlSellerDetails(generics.ListCreateAPIView):
    queryset = NrmlSerller.objects.all()
    serializer_class = NrmlSlrUserSerializer
    authentication_classes = [JWTAuthentication ]
    permission_classes = [permissions.IsAuthenticated]

