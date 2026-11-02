"""Send the user's copy shortcut through core's immediate terminal stream."""
import json
import struct
import subprocess
import sys


def main():
    with subprocess.Popen(["hc", "connect"], stdin=subprocess.PIPE, stdout=subprocess.PIPE) as core:
        core.stdin.write(b'{"jsonrpc":"2.0","id":0,"method":"hello","params":{"framed":true}}\n')
        core.stdin.flush()
        check_reply(json.loads(core.stdout.readline()))

        terminal = request(core, 1, "terminal.get", {"terminal": sys.argv[1]})
        attached = request(core, 2, "terminal.attach", {
            "terminal": sys.argv[1], "cols": terminal["cols"], "rows": terminal["rows"],
            "resumed": True,
        })
        channel = attached["channel"]
        send_frame(core, channel, 0, b" y")
        # A control reply confirms that core has read the input frame before we detach.
        request(core, 3, "terminal.get", {"terminal": sys.argv[1]})
        send_frame(core, channel, 2, b"")
        core.stdin.close()


def request(core, ident, method, params):
    send_frame(core, 0, 0, json.dumps({"jsonrpc": "2.0", "id": ident, "method": method, "params": params}).encode())
    while True:
        channel, kind, length = struct.unpack("<IBI", read_exact(core.stdout, 9))
        payload = read_exact(core.stdout, length)
        if channel == 0 and kind == 0:
            reply = json.loads(payload)
            if reply.get("id") == ident:
                return check_reply(reply)
        elif channel != 0 and kind == 0:
            send_frame(core, channel, 1, struct.pack("<I", length))


def check_reply(reply):
    if "error" in reply:
        raise RuntimeError(reply["error"])
    return reply["result"]


def send_frame(core, channel, kind, payload):
    core.stdin.write(struct.pack("<IBI", channel, kind, len(payload)) + payload)
    core.stdin.flush()


def read_exact(stream, length):
    data = b""
    while len(data) < length:
        chunk = stream.read(length - len(data))
        if not chunk:
            raise EOFError("Core disconnected")
        data += chunk
    return data


if __name__ == "__main__":
    main()
