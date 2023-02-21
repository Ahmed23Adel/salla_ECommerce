from rest_framework import serializers
from .models import NrmlSerller
from datetime import date


class NrmlSlrUserSerializer(serializers.ModelSerializer):
    age = serializers.SerializerMethodField(read_only=True)
    class Meta:
        model = NrmlSerller
        fields = [  'usertype',
                    'signupdatetime',
                    'mobileauthenticationenabled',
                    'emailauthenticationenabled',
                    'mobilephone',
                    'profilepiclink',
                    'birthdate',
                    'age',
                    ]
        

    def get_age(self, instance):
        today =date.today()
        one_or_zero = ((today.month, today.day) < (instance.birthdate.month, instance.birthdate.day))
        year_difference = today.year - instance.birthdate.year
        age = year_difference - one_or_zero
        return age

        

       

        