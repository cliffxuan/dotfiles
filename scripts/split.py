#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
spit large csv into smaller chunks
"""
import os
import argparse


def split(fileobj, size):
    header = fileobj.next()
    outdir = fileobj.name + '-split'
    if not os.path.exists(outdir):
        os.makedirs(outdir)

    def _batch():
        filename = os.path.join(
            outdir, os.path.basename(fileobj.name) + '.{}'.format(batch_cnt))
        print filename
        batch_fileobject = open(filename, 'w')
        batch_fileobject.write(header)
        return batch_fileobject

    batch_cnt = 0
    batch = _batch()
    for cnt, row in enumerate(fileobj):
        if cnt > 0 and cnt % size == 0:
            batch.close()
            batch_cnt += 1
            batch = _batch()
        batch.write(row)
    else:
        batch.close()


def argument_parser():
    parser = argparse.ArgumentParser(
        description='split large csv file')
    parser.add_argument(
        'filename', type=argparse.FileType('r'),
        help='name of the csv file to split')
    parser.add_argument('--size', '-s', type=int, default=200,
                        help='size of one patch')
    return parser


def main(argv=None):
    args = argument_parser().parse_args(argv)
    split(args.filename, args.size)


if __name__ == '__main__':
    main()