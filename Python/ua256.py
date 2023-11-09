import requests, hashlib
'''
url = "https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar.sha256"
'''

def checkSha256():
    """check sha256 of file"""
    url = "https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar.sha256"
    r = requests.get(url=url)
    try:
        r.raise_for_status()
    except:
        print("Error in request.\n\n{r.status_code}")
        quit()
    response = r.text.replace(" wss-unified-agent.jar", "")
    #print(response)
    return response

def currentSha256():
    """get sha256 of existing UA file"""
    UA_location = "C:/UAgent/wss-unified-agent.jar"
    with open(UA_location, "rb") as f:
        data = f.read() # read entire file as bytes
        readable_hash = hashlib.sha256(data).hexdigest()
        #print(readable_hash)
        return readable_hash

online_sha = checkSha256()
local_sha = currentSha256()

if online_sha.strip() == local_sha.strip():
    print("SHA256 match!")
elif online_sha != local_sha:
    print("SHA256 does not match, BEWARE.")
else:
    print("what exactly did you do to get here?")
