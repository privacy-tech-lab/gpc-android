import json
from datetime import datetime

pkg_name = 'APP PACKAGE NAME HERE'
opted_out = 'not_opted_out'
file_path = './mitm-captures/' + pkg_name + '/' + opted_out + '.json'  # JSON format
data = [] # The data that will be saved to the JSON file afterwards

# Called whenever a full HTTP response is read to append the request/response information to data
def response(flow):
    try:
        # Collect data
        entry = { 
            "timestamp": datetime.now().isoformat(),
            "request": {
                "method": flow.request.method,
                "url": flow.request.pretty_url,
                "http_version": flow.request.http_version,
                "headers": dict(flow.request.headers),
                "body": flow.request.get_text(),
            },
            "response": {
                "status_code": flow.response.status_code if flow.response else None,
                "reason": flow.response.reason if flow.response else None,
                "http_version": flow.response.http_version if flow.response else None,
                "headers": dict(flow.response.headers) if flow.response else {},
                "body": flow.response.get_text() if flow.response else "",
            }
        }

        # Append to data
        data.append(entry)

    except Exception as e:
        error_entry = {
            "timestamp": datetime.utcnow().isoformat(),
            "error": str(e),
            "url": flow.request.pretty_url
        }
        # Append to data
        data.append(error_entry)

# Called on shutdown to write the contents of data to a JSON file. Should be the last event this script reads
def done():
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)