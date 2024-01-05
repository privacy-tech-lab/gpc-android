import mitmproxy

class HeaderModifier:
    def request(self, flow: mitmproxy.http.HTTPFlow):
        flow.request.headers["X-Dummy"] = "1"

addons = [
    HeaderModifier()
]
