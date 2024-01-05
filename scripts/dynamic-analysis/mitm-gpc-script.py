import mitmproxy

class HeaderModifier:
    def request(self, flow: mitmproxy.http.HTTPFlow):
        flow.request.headers["Sec-GPC"] = "1"

addons = [
    HeaderModifier()
]
