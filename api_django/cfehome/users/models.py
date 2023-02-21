from django.db import models
from django.conf import settings
from datetime import date

# Create your models here.

class NrmlSerller(models.Model):
    userid = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, primary_key=True,db_column='UserID', unique=True)  # from table user.
    usertype = models.IntegerField(db_column='UserType')  # Field name made lowercase.
    signupdatetime = models.DateTimeField(db_column='SignUpDateTime', blank=True, null=True)  # Field name made lowercase.
    mobileauthenticationenabled = models.IntegerField(db_column='MobileAuthenticationEnabled', default=0)  # Field name made lowercase.
    emailauthenticationenabled = models.IntegerField(db_column='EmailAuthenticationEnabled', default=0)  # Field name made lowercase.
    mobilephone = models.CharField(db_column='MobilePhone', max_length=20, blank=True, null=True)  # Field name made lowercase.
    profilepiclink = models.CharField(db_column='ProfilePicLink', max_length=128, blank=True, null=True)  # Field name made lowercase.
    birthdate = models.DateField(db_column='BirthDate', auto_now_add=True, blank=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'nrmlseller'

