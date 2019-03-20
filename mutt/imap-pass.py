#!/usr/bin/env python2
# vim: set fileencoding=utf-8

#  ╻┏┳┓┏━┓┏━┓   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┃┣━┫┣━┛   ┣━┛┣━┫┗━┓┗━┓
#  ╹╹ ╹╹ ╹╹     ╹  ╹ ╹┗━┛┗━┛

from subprocess import check_output

def imap_pass(name):
    return check_output("pass show " + name, shell=True).splitlines()[0]

