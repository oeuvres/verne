#!/usr/bin/env python3

import argparse
import glob
import sys
from pathlib import Path

from lxml import etree


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("xslt", type=Path)
    parser.add_argument("glob")
    # parser.add_argument("output", type=Path)
    # parser.add_argument("--ext", default=".xml")
    args = parser.parse_args()

    transform = etree.XSLT(etree.parse(args.xslt))
    # args.output.mkdir(parents=True, exist_ok=True)

    for src_name in sorted(glob.glob(args.glob, recursive=True)):
        src = Path(src_name)
        print(f"### {src}", file=sys.stderr)
        doc = etree.parse(src)
        result = transform(
            doc,
            filename=etree.XSLT.strparam(src.stem),
        )
        result.write_output(src)


if __name__ == "__main__":
    main()