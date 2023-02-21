import requests
import pathlib 
import json


def create_token(username = None,password = None):
    endpoint = "http://127.0.0.1:8000/api/v1/account/login/"
    idx = 11
    cred = {}
    if username is None and password is None:
        cred =  {"email":f"ahmed35{idx}@gmail.com", "password": "AhmedAd*86@3"}
    req_resp = requests.post(endpoint, json=cred)
    cred_path: pathlib.Path = pathlib.Path("creds.json")
    if cred_path:
        cred_path.write_text(json.dumps(req_resp.json()))


def refresh_token():
    endpoint = "http://127.0.0.1:8000/api/v1/account/refresh/"
    cred = {}
    with open('creds.json') as json_file:
        data = json.load(json_file)
        cred =  {"refresh": data['refresh']}
    req_resp = requests.post(endpoint, json=cred)
    cred['access'] = req_resp.json()['access']
    print(cred)
    cred_path: pathlib.Path = pathlib.Path("creds.json")
    if cred_path:
        cred_path.write_text(json.dumps(cred))
    return req_resp.status_code


def verify_token():
    endpoint = "http://127.0.0.1:8000/api/v1/account/verify/"
    cred = {}
    with open('creds.json') as json_file:
        data = json.load(json_file)
        cred = {
            # "Authorization" : f"Bearer {data['access']}", 
            "token": data['access']
            # <Response [401]> {'detail': 'Token is invalid or expired', 'code': 'token_not_valid'}
        }
    req_resp = requests.post(endpoint, json=cred)
    print("verify_token", req_resp, req_resp.json())
    #return req_resp.status_code

def tokin_auth():
    print("Try verify")
    if verify_token() == 401:
        print("Try refresh")
        if refresh_token() == 401:
            print("Try create")
            create_token()


tokin_auth()