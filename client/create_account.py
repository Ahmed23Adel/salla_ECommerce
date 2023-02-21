import requests

endpoint = "http://127.0.0.1:8000/api/v1/account/register/"


idx = 11
cred = {"first_name":"ahmed", "last_name": "adel", "name": f"ahmed adel2{idx}", "email":f"ahmed35{idx}@gmail.com", "password": "AhmedAd*86@3", "is_seller": "True", "is_normal":"False", "is_emp": "False"}
auth_resp = requests.post(endpoint, json=cred)
print("done")
print(auth_resp.json())

