from django.shortcuts import render
from rest_framework.views import APIView
from .serializer import UserSerializer
from rest_framework.response import Response
from users.serializers import NrmlSlrUserSerializer


# view for registering users
class RegisterView(APIView):
    def post(self, request):
        user_serializer = UserSerializer(data=request.data)
        if user_serializer.is_valid(raise_exception=True):
            #nrml_slr_serializer = NrmlSlrUserSerializer(data=request.data)
            #nrml_slr_serializer.is_valid(raise_exception=True)
            user_serializer.save()
            #nrml_slr_serializer.save()
            return Response(user_serializer.data)
        
        return Response(user_serializer.data)
    

