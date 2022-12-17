import os
import json
import argparse
import datetime


# Get arguments
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--app', type=str, required=True)
    parser.add_argument('--version', type=str, required=True)
    parser.add_argument('--arch', type=str, required=True)
    parser.add_argument("--notes", type=str, required=False, default="No notes")
    args = parser.parse_args()
    return args

arguments = get_args()

json_dict = {
    "version": f"v{arguments.version}",
    "notes": arguments.notes,
    "pub_date": datetime.datetime.now().isoformat(),
    "platforms": {}
}

print("Generate JSON file for app: " + arguments.app + " and version: " + arguments.version)
archs = arguments.arch.split(",")
print("Architectures: ", archs)

for arch in archs:
    sig_path = f"builds/{arguments.app}/{arguments.version}/{arguments.app}_{arguments.version}_{arch}.tar.gz.sig"
    package_path = f"builds/{arguments.app}/{arguments.version}/{arguments.app}_{arguments.version}_{arch}.tar.gz"
    # Get content of .sig file
    with open(sig_path, "r") as f:
        sig = f.read()

    print("Signature for", arch, sig)
    json_dict["platforms"][f"linux-{arch}"] = {
        "signature": sig,
        "url": f"https://github.com/K4CZP3R/plu-v2-updates/raw/main/{package_path}"
    }

print(repr(json.dumps(json_dict)))