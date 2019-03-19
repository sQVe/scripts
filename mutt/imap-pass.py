#!/usr/bin/env python2

#  ╻┏┳┓┏━┓┏━┓   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┃┣━┫┣━┛   ┣━┛┣━┫┗━┓┗━┓
#  ╹╹ ╹╹ ╹╹     ╹  ╹ ╹┗━┛┗━┛

from subprocess import check_output

def imap_pass(name):
    return check_output("pass show " + name, shell=True).splitlines()[0]
