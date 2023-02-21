

# first create token:
#def get_token(username, password):


import requests
access =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc2ODQzODE0LCJpYXQiOjE2NzY4NDAyMTQsImp0aSI6ImE1ZWE1NjhiMTU1YzQ1NTc5MDRkODAyZTQ5MmM4YWJkIiwidXNlcl9pZCI6MX0.P1qYDrHXVdt7dTXfcqIApmFfZkjc6gJPsNFxQGnOT-U"
cred = {
    "Authorization" : f"Bearer {access}"

}

ep = "http://127.0.0.1:8000/api/v1/users/normalserller/"

req_res = requests.get(ep, headers=cred)
print(req_res.json())
