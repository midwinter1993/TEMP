#!/usr/bin/env python


import re
import sys
import pprint
import matplotlib.pyplot as plt
from collections import Counter


class Info:
    LINE_PAT = re.compile(r'(?P<task_pid>.+?)\s+\[(?P<cpu>\w+)\]\s+(?P<tldr>.+?)\s+(?P<tsc>\d+.\d+):\s+(?P<func>\w+):(?P<args>.+)')

    def __init__(self, line):
        match = Info.LINE_PAT.match(line.strip())
        self.task_pid_ = match.group('task_pid')
        self.cpu_ = match.group('cpu')
        # match.group('tldr')
        self.tsc_sec_, self.tsc_usec_ = map(int, match.group('tsc').split('.'))
        self.func_name_ = match.group('func')
        self.func_info_ = match.group('args').strip()

        self._parse_func_info()

    def _parse_func_info(self):
        infos = self.func_info_.split()
        self.info_kv_pairs_ = dict([info.split('=') for info in infos])

    @property
    def full_tsc_usec_(self):
        return self.tsc_sec_ * 1000000 + self.tsc_usec_

    @property
    def call_site_(self):
        return self.info_kv_pairs_['call_site']


class KmallocInfo(Info):
    def __init__(self, line):
        super().__init__(line)

    @property
    def ptr_(self):
        return self.info_kv_pairs_['ptr']

    @property
    def bytes_req_(self):
        return int(self.info_kv_pairs_['bytes_req'])

    @property
    def bytes_alloc_(self):
        return  int(self.info_kv_pairs_['bytes_alloc'])

    @property
    def fragment_(self):
        return self.bytes_alloc_ - self.bytes_req_


class KmallocNodeInfo(KmallocInfo):
    def __init__(self, line):
        super().__init__(line)

    @property
    def node_(self):
        return  int(self.info_kv_pairs_['node'])


class KfreeInfo(Info):
    def __init__(self, line):
        super().__init__(line)

    @property
    def ptr_(self):
        return self.info_kv_pairs_['ptr']

    def set_lifetime(self, alloc_info):
        self.lifetime_ = self.full_tsc_usec_ - alloc_info.full_tsc_usec_


with open('./trace') as fd:
    kmalloc_pool = {}
    lifetime_list = []
    fragment_list = []

    for (line_no, line) in enumerate(fd):
        if line.startswith('#'):
            continue
        if 'kmalloc:' in line:
            info = KmallocInfo(line)
            kmalloc_pool[info.ptr_] = info
            fragment_list.append(info.fragment_)
        elif 'kmalloc_node:' in line:
            info = KmallocNodeInfo(line)
            kmalloc_pool[info.ptr_] = info
            fragment_list.append(info.fragment_)
        elif 'kfree:' in line:
            info = KfreeInfo(line)
            alloc_info = kmalloc_pool.pop(info.ptr_, None)
            if alloc_info:
                info.set_lifetime(alloc_info)
                lifetime_list.append(info.lifetime_)

    pprint.pprint(Counter(fragment_list))
    pprint.pprint(Counter(lifetime_list))
    # n, bins, patches = plt.hist(x=lifetime_list, bins='auto', color='#0504aa',
                            # alpha=0.7, rwidth=0.85)
    # plt.show()