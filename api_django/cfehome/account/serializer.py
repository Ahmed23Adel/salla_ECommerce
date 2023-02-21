from .models import UserData
from rest_framework import serializers
from users.serializers import NrmlSlrUserSerializer
from users.models import NrmlSerller
from password_strength import PasswordPolicy



class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserData    
        UserFullData = NrmlSlrUserSerializer(source='nrmlseller', many=True)
        fields = ["id", "email", "first_name", 'last_name', "password", 'is_seller', 'is_normal', 'is_emp']

    def create(self, validated_data):
        user = UserData.objects.create(email=validated_data['email'],
                                       first_name=validated_data['first_name'],
                                       last_name=validated_data['last_name'],
                                       is_seller = validated_data['is_seller'],
                                       is_normal = validated_data['is_normal'],
                                       is_emp = validated_data['is_emp'],
                                       
                                       )
        
        user.set_password(validated_data['password'])
        user.save()
        return user
    
    def has_numbers(self,string):
        return any(char.isdigit() for char in string)


    def validate(self, attrs):
        policy = PasswordPolicy.from_names(
            length=8,  # min length: 8
            uppercase=2,  # need min. 2 uppercase letters
            numbers=2,  # need min. 2 digits
            special=2,  # need min. 2 special characters
            nonletters=2,  # need min. 2 non-letter characters (digits, specials, anything)
        )
        password_op = policy.test(attrs['password'])
        if not len(password_op)  == 0:
            raise serializers.ValidationError(f"Password strengh check has failed, some checks have failed, which are {str(password_op)}")
        if attrs['is_seller'] and attrs['is_normal'] :
            raise serializers.ValidationError("You can't be serller and normal user at the same time.")
        if self.has_numbers(attrs['first_name']) or  self.has_numbers(attrs['last_name']):
            raise serializers.ValidationError("You must insert first and last name.")
        if attrs['is_emp']:
            raise serializers.ValidationError("You don't have the permission to create an employee.")
        return attrs
        # TODO make user login and make sure that he is an employee who has permission to insert another emp and then allow him



