import json
from datetime import datetime

pkg_name = 'com.ubercab'
opted_out = 'not_opted_out'
file_path = './mitm-captures/' + pkg_name + '/' + opted_out + '.jsonl'  # JSON lines format

def response(flow):
    try:
        # Collect data
        entry = { 
            "timestamp": datetime.utcnow().isoformat(),
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

        # Append to file
        with open(file_path, 'a', encoding='utf-8') as f:
            f.write(json.dumps(entry, ensure_ascii=False) + '\n')

    except Exception as e:
        with open(file_path, 'a', encoding='utf-8') as f:
            error_entry = {
                "timestamp": datetime.utcnow().isoformat(),
                "error": str(e),
                "url": flow.request.pretty_url
            }
            f.write(json.dumps(error_entry) + '\n')
