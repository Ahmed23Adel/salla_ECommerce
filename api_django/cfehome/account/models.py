from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager


'''
Basically in the above code we created a class UserData which extends the UserManager class.
 The ‘username’ is set to be none because we want to authenticate the user by its unique email id instead of a username.

We have written ‘email’ in the USERNAME_NAME field which tells django that we want to input email id instead of username when authenticating.
'''
class UserManager(BaseUserManager):

    use_in_migration = True

    def create_user(self, email, password=None, **extra_fields):
        print("email", email)
        print("extra_fields", extra_fields)
        if not email:
            raise ValueError('Email is Required')
        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff = True')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser = True')

        return self.create_user(email, password, **extra_fields)


class UserData(AbstractUser):

    username = None
    #name = models.CharField(max_length=100, unique=True)
    email = models.EmailField(max_length=100, unique=True)
    date_joined = models.DateTimeField(auto_now_add=True)
    is_admin = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_normal = models.BooleanField(default=False)
    is_seller = models.BooleanField(default=False)
    is_emp = models.BooleanField(default=False)
    is_seller_activated = models.BooleanField(default=False)
    
    objects = UserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name','is_normal', 'is_seller','is_emp']

    def __str__(self):
        return self.name